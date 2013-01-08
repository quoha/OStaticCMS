//
//  ExecutableAST.m
//  StaticCMS
//
//  Created by Michael Henderson on 1/6/13.
//  Copyright (c) 2013 Michael Henderson. All rights reserved.
//

#import "ExecutableAST.h"
#import "ExecutableAST_ELSE.h"
#import "ExecutableAST_ENDIF.h"
#import "ExecutableAST_IF.h"
#import "ExecutableAST_NOOP.h"
#import "ExecutableAST_TEXT.h"
#import "ExecutableAST_WORD.h"

@implementation ExecutableAST

//   for each Node
//     if the Node is "IF"
//     else if the Node is "TEXT"
//       node = next node
//     else
//       else
//         throw an exception
//       node = next node

-(id) init {
    self = [super init];
    if (self) {
        nextNode   = nil;
    }
    return self;
}

+(void) dump: (ExecutableAST *) node {
    while (node) {
        [node dump];
        node = node->nextNode;
    }
}

-(void) dump {
    NSLog(@"**ast:\tbase AST node");
}

-(ExecutableAST *) execute: (QStack *) stack withTrace:(BOOL)doTrace {
    if (doTrace) {
        NSLog(@">>ast:\trun node");
    }
    return nextNode;
}

+(ExecutableAST *) execute:(ExecutableAST *) ast withStack:(QStack *) stack andModel:(Model *)model andTrace:(BOOL)doTrace {
    while (ast) {
        if (doTrace) {
            //[ast dump];
        }
        ExecutableAST *nextNode = [ast execute:stack withTrace:doTrace];
        
        ast = nextNode;

#if 0
        if (ast->isIF) {
            // pop top element from Stack
            //
            id object = [stack popTop];
            
            // if value is TRUE
            //    node = branchThen node
            // else
            //    node = branchThen node
            // somehow use object to derive condition
            //
            Boolean priorWord = object ? true : false;

            // based on that condition, take a branch
            //
            if (priorWord) {
                ast = ast->nextNode;
            } else {
                ast = ast->branchElse;
            }
        } else if (ast->isNOOP) {
            // no-op means to do nothing
            //
            ast = ast->nextNode;
        //} else if (ast->isTEXT) {
        //    // push TEXT to Stack
        //    //
        //    [stack pushTop:ast->text];
        //    ast = ast->nextNode;
        //} else if (ast->isWORD) {
        //    //       check if the Node's word is defined in the Model
        //    //       if the Word is a function
        //    //         execute the function with AST, Stack and Model
        //    //         ? how do we handle INCLUDE ?
        //    //           INCLUDE will load a View
        //    //           ask the View to return an AST
        //    //           invoke the Interpreter against the AST
        //    ast = ast->nextNode;
        } else {
            NSLog(@"error:\tunexpected AST type");
            return nil;
        }
#endif
    }
    return nil;
}

+(ExecutableAST *) fixupIF: (ExecutableAST *)root {
    if (!root) {
        return root;
    }

    ExecutableAST *tail = root;

    QStack *ifStack = [[QStack alloc] init];

    while (tail) {
        if ([tail isKindOfClass:[ExecutableAST_IF class]]) {
            // when we find IF, we need to branch the tree
            //
            // link the parent IF to the THEN branch
            //
            ExecutableAST_IF *parentIF = (ExecutableAST_IF *)tail;
            [parentIF setThen:tail];

            // push this node onto the stack
            //
            [ifStack pushTop:parentIF];
        } else if ([tail isKindOfClass:[ExecutableAST_ELSE class]]) {
            // first check that we're in an IF block
            //
            if ([ifStack isEmpty]) {
                // error in the source
                //
                NSLog(@"error:\tfound 'else' outside of 'if ... else ... endif'");
                return nil;
            }

            // link the parent IF to the ELSE branch
            //
            ExecutableAST_IF *parentIF = [ifStack peekTop];
            [parentIF setElse:tail];
        } else if ([tail isKindOfClass:[ExecutableAST_ENDIF class]]) {
            // first check that we're in an IF block
            //
            if ([ifStack isEmpty]) {
                // error in the source
                //
                NSLog(@"error:\tfound 'endif' outside of 'if ... else ... endif'");
                return nil;
            }

            // link the parent IF to the ENDIF
            //
            ExecutableAST_IF *parentIF = [ifStack popTop];
            [parentIF setNext:tail];
        }

        tail = tail->nextNode;
    }

    return root;
}

+(ExecutableAST *) fromStack:(QStack *)stack {
    ExecutableAST *root = [[ExecutableAST_NOOP alloc] init];
#if 0
    ExecutableAST *tail = root;

    // go through all the words and create nodes from them
    NSEnumerator *e = [stack objectEnumerator];
    id object;
    while ((object = [e nextObject])) {
        if ([object isKindOfClass:[ExecutableAST class]]) {
            ExecutableAST *ast = (ExecutableAST *)object;
            if (ast->isTEXT) {
                tail->nextNode = [ExecutableAST initTEXT:ast->text];
                NSLog(@"fromStack text '%@'", ast->text);
            } else if (ast->isWORD) {
                NSLog(@"fromStack word '%@'", ast->text);
            } else {
                NSLog(@"fromStack uknown AST");
            }
        } else {
            NSLog(@"fromStack uknown object");
        }
    }
#endif
    return root;
}

// create a tree by pulling text and words from the
// string. add them to the tree with the appropriate
// node type
//
+(ExecutableAST *) fromString:(NSString *)string {
    ExecutableAST *root = [[ExecutableAST_NOOP alloc] init];
    ExecutableAST *tail = root;

    NSLog(@"staring fromString");
    
    NSString       *codeStart  = @"<cms";
    NSString       *codeEnd    = @"/>";
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSCharacterSet *quoteOpen  = [NSCharacterSet characterSetWithCharactersInString:@"<"];

    NSScanner *theScanner = [NSScanner scannerWithString:string];
    while ([theScanner isAtEnd] == NO) {
        NSString *theText    = nil;
        NSString *theCode    = nil;

        [theScanner scanUpToString:codeStart intoString:&theText];
        [theScanner scanString:codeStart     intoString:nil];
        [theScanner scanUpToString:codeEnd   intoString:&theCode];
        [theScanner scanString:codeEnd       intoString:nil];

        if (theText) {
            // add TEXT directly to the tree
            //
            tail->nextNode = [[ExecutableAST_TEXT alloc] initWithString:theText];
            tail = tail->nextNode;
        }

        if (theCode) {
            // break theCode into the individual words before adding
            // it to the tree
            //
            NSScanner *theScanner = [NSScanner scannerWithString:theCode];
            
            while ([theScanner isAtEnd] == NO) {
                // skip leading whitespace
                //
                [theScanner scanCharactersFromSet:whitespace intoString:nil];

                NSString *theWord  = nil;

                // if first character is '<' then treat as a quoted word
                //
                NSString *theQuote = nil;
                [theScanner scanCharactersFromSet:quoteOpen intoString:&theQuote];

                if (!theQuote) {
                    // word does not start with a quote so it is terminated by whitespace
                    //
                    [theScanner scanUpToCharactersFromSet:whitespace intoString:&theWord];
                } else {
                    // word starts with a quote so it is terminated by '>'
                    //
                    [theScanner scanUpToString:@">" intoString:&theWord];
                    [theScanner scanString:@">"     intoString:nil];
                }

                // if we found a word, create a node for it
                //
                if (theWord) {
                    // if we have text or special words, update the node directly
                    //
                    if (theQuote) {
                        tail->nextNode = [[ExecutableAST_TEXT alloc] initWithString:theWord];
                    } else if ([theWord isEqualToString:@"if"]) {
                        tail->nextNode = [[ExecutableAST_IF alloc] init];
                    } else if ([theWord isEqualToString:@"else"]) {
                        tail->nextNode = [[ExecutableAST_ELSE alloc] init];
                    } else if ([theWord isEqualToString:@"endif"]) {
                        tail->nextNode = [[ExecutableAST_ENDIF alloc] init];
                    } else {
                        tail->nextNode = [[ExecutableAST_WORD alloc] initWithString:theWord];
                    }
                    tail = tail->nextNode;
                }
            }
        }
    }

    // make sure that the tree always ends with a no-op
    //
    if (tail != root) {
        tail->nextNode = [[ExecutableAST_NOOP alloc] init];
    }

    // we ignored IF statements. run through the tree and add them back in
    //
    return [ExecutableAST fixupIF:root];
}

@end
