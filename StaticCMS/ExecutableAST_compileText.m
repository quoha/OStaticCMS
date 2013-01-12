//
//  ExecutableAST_compileText.m
//  StaticCMS
//
//  Created by Michael Henderson on 1/10/13.
//  Copyright (c) 2013 Michael Henderson. All rights reserved.
//

#import "ExecutableAST_compileText.h"

@implementation ExecutableAST_compileText

-(id) init {
    self = [super init];
    if (self) {
        //
    }
    return self;
}

-(void) dump {
    NSLog(@"**ast:\tcompileText");
}

//
// compile
//   t -- {results of compiling and executing t}
//
-(ExecutableAST *) execute: (QStack *) stack withTrace:(BOOL)doTrace {
    if (doTrace) {
        NSLog(@">>ast:\tcompile");
    }
    
    if (!stack ||[stack size] < 1) {
        NSLog(@"error:\tcompile requires at least one argument on the stack");
        return nil;
    }
    
    id object = [stack popTop];
    if (![object isKindOfClass:[NSString class]]) {
        NSLog(@"error:\tcompile requires a string argument on the stack");
        return nil;
    }
    NSString *text = (NSString *)object;
    
    if (doTrace) {
        NSLog(@">>ast:\tcompile <%@>", text);
    }
    
    // parse the text into an AST
    ExecutableAST *ast = [ExecutableAST fromString:text];
    
    // execute it
    [ExecutableAST execute:ast withStack:stack andModel:nil andTrace:doTrace andSearchPath:nil];
    
    return nextNode;
}

@end
