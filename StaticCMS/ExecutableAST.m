//
//  ExecutableAST.m
//  StaticCMS
//
//  Created by Michael Henderson on 1/6/13.
//  Copyright (c) 2013 Michael Henderson. All rights reserved.
//

#import "ExecutableAST.h"

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
        isELSE     = false;
        isENDIF    = false;
        isIF       = false;
        isNOOP     = true;
        isTEXT     = false;
        isWORD     = false;
        nextNode   = nil;
        branchElse = nil;
        branchThen = nil;
    }
    return self;
}

-(void) dump {
    ExecutableAST *ast = self;

    while (ast) {
        if (ast->isELSE) {
            NSLog(@"ast else");
        } else if (ast->isENDIF) {
            NSLog(@"ast endif");
        } else if (ast->isIF) {
            NSLog(@"ast if");
        } else if (ast->isNOOP) {
            NSLog(@"ast no-op");
        } else if (ast->isTEXT) {
            NSLog(@"ast text '%@'", ast->text);
        } else if (ast->isWORD) {
            NSLog(@"ast word '%@'", ast->text);
        } else {
            NSLog(@"fromStack uknown AST");
        }
        ast = ast->nextNode;
    }
}

+(Boolean) execute: (ExecutableAST *) ast withStack:(QStack *) stack {
    while (ast) {
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
        } else if (ast->isTEXT) {
            // push TEXT to Stack
            //
            [stack pushTop:ast->text];
            ast = ast->nextNode;
        } else if (ast->isWORD) {
            //       check if the Node's word is defined in the Model
            //       if the Word is a function
            //         execute the function with AST, Stack and Model
            //         ? how do we handle INCLUDE ?
            //           INCLUDE will load a View
            //           ask the View to return an AST
            //           invoke the Interpreter against the AST
            ast = ast->nextNode;
        } else {
            NSLog(@"error:\tunexpected AST type");
            return false;
        }
    }
    return true;
}

+(ExecutableAST *) fixupIF: (ExecutableAST *)root {
    if (!root) {
        return root;
    }

    ExecutableAST *tail = root;

    QStack *ifStack = [[QStack alloc] init];

    while (tail) {
        if (tail->isIF) {
            // when we find IF, we need to branch the tree
            //
            ExecutableAST *parentIF = tail;

            // push this node onto the stack
            //
            [ifStack pushTop:parentIF];

            // link the parent IF to the THEN branch
            //
            tail->branchThen = tail->nextNode;
        } else if (tail->isELSE) {
            // first check that we're in an IF block
            //
            if ([ifStack isEmpty]) {
                // error in the source
                //
                NSLog(@"error:\tfound 'else' outside of 'if ... else ... endif'");
                return nil;
            }
            ExecutableAST *parentIF = [ifStack peekTop];

            // link the parent IF to the ELSE branch
            //
            parentIF->branchElse = tail;
        } else if (tail->isENDIF) {
            // first check that we're in an IF block
            //
            if ([ifStack isEmpty]) {
                // error in the source
                //
                NSLog(@"error:\tfound 'endif' outside of 'if ... else ... endif'");
                return nil;
            }
            ExecutableAST *parentIF = [ifStack popTop];

            // link the parent IF to the ENDIF
            //
            parentIF->nextNode = tail;
        }

        tail = tail->nextNode;
    }

    return root;
}

// be kind - fix the type of the word if we know it
//
+(ExecutableAST *) fixWordType: (ExecutableAST *)root {
    ExecutableAST *tail = root;

    while (tail) {
        if (tail->isWORD) {
            if ([tail->text isEqualToString:@"if"]) {
                tail->isWORD  = false;
                tail->isIF    = true;
            } else if ([tail->text isEqualToString:@"else"]) {
                tail->isWORD  = false;
                tail->isELSE  = true;
            } else if ([tail->text isEqualToString:@"endif"]) {
                tail->isWORD  = false;
                tail->isENDIF = true;
            }
        }
        tail = tail->nextNode;
    }

    return root;
}

+(ExecutableAST *) fromStack:(QStack *)stack {
    ExecutableAST *root = [ExecutableAST initNOOP];
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
    ExecutableAST *root = [ExecutableAST initNOOP];
    ExecutableAST *tail = root;

    NSLog(@"staring fromString");
    
    NSString  *codeStart  = @"<cms";
    NSString  *codeEnd    = @"/>";

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
            tail->nextNode = [ExecutableAST initTEXT:theText];
            tail = tail->nextNode;
        }
        if (theCode) {
            // break theCode into the individual words before adding
            // it to the tree
            //
            NSCharacterSet *stopSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
            NSScanner *theScanner = [NSScanner scannerWithString:theCode];
            while ([theScanner isAtEnd] == NO) {
                NSString *theWord = nil;
                [theScanner scanUpToCharactersFromSet:stopSet intoString:&theWord];

                if (theWord) {
                    tail->nextNode = [ExecutableAST initWORD:theWord];
                    tail = tail->nextNode;
                }
            }
        }
    }

    // make sure that the tree always ends with a no-op
    //
    if (tail != root) {
        tail->nextNode = [ExecutableAST initNOOP];
    }

    // we ignored IF statements. run through the tree and add them back in
    //
    [ExecutableAST fixWordType:root];

    return [ExecutableAST fixupIF:root];
}

+(ExecutableAST *) initNOOP {
    ExecutableAST *ast = [[ExecutableAST alloc] init];
    ast->isNOOP = true;
    return ast;
}

+(ExecutableAST *) initTEXT:(NSString *)text {
    ExecutableAST *ast = [[ExecutableAST alloc] init];
    ast->isNOOP = false;
    ast->isTEXT = true;
    ast->text   = text;
    return ast;
}

+(ExecutableAST *) initWORD:(NSString *)text {
    ExecutableAST *ast = [[ExecutableAST alloc] init];
    ast->isNOOP = false;
    ast->isWORD = true;
    ast->text   = text;
    return ast;
}

@end
