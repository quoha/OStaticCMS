//
//  ExecutableAST_WORD.m
//  StaticCMS
//
//  Created by Michael Henderson on 1/7/13.
//  Copyright (c) 2013 Michael Henderson. All rights reserved.
//

#import "ExecutableAST_WORD.h"

@implementation ExecutableAST_WORD

-(id) init {
    return [self initWithString:nil];
}

-(id) initWithString: (NSString *) string {
    self = [super init];
    if (self) {
        name = string;
    }
    return self;
}

-(void) dump {
    NSLog(@"**ast:\tword %@", name);
}

-(ExecutableAST *) execute: (QStack *) stack withTrace:(BOOL)doTrace {
    if (doTrace) {
        NSLog(@">>ast:\trun word %@", name);
    }
    
    // nothing to do for a null word
    //
    if (!name) {
        return nextNode;
    }

    Model *model = [ExecutableAST getModel];
    if (model) {
        // lookup variable in the model
        //
        NSString *val = [model getVariable:name];
        if (val) {
            [stack pushTop:val];
            return nextNode;
        }
    }

    NSLog(@"error:\no idea on how to execute '%@'", name);

    return nil;
}

#if 0
    //} else if (ast->isWORD) {
    //    //       check if the Node's word is defined in the Model
    //    //       if the Word is a function
    //    //         execute the function with AST, Stack and Model
    //    //         ? how do we handle INCLUDE ?
    //    //           INCLUDE will load a View
    //    //           ask the View to return an AST
    //    //           invoke the Interpreter against the AST
    //    ast = ast->nextNode;
}
#endif

@end
