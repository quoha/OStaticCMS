//
//  ExecutableAST_IF.m
//  StaticCMS
//
//  Created by Michael Henderson on 1/7/13.
//  Copyright (c) 2013 Michael Henderson. All rights reserved.
//

#import "ExecutableAST_IF.h"

@implementation ExecutableAST_IF

-(id) init {
    self = [super init];
    if (self) {
        branchElse = nil;
        branchThen = nil;
    }
    return self;
}

-(void) dump {
    NSLog(@"**ast:\tif");
}

-(ExecutableAST *) execute: (QStack *) stack withTrace:(BOOL)doTrace {
    if (doTrace) {
        NSLog(@">>ast:\trun if");
    }
    if ([stack isEmpty]) {
        NSLog(@"error:\tif requires a condition to be on the stack");
        return nil;
    }

    BOOL result = NO;

    Model *model = [ExecutableAST getModel];
    if (!model) {
        // answer must always be false
        //
        if (doTrace) {
            NSLog(@">>ast:\tif found no model, forcing to false");
        }
        result = NO;
    } else {
        // pop top element from Stack. if it is 'true' or 'false', use it.
        // otherwise, see if it is a variable. if it is a defined, non-nul
        // variable, treat as 'true', otherwise treat as 'false.'
        //
        id object = [stack popTop];
        NSLog(@">>ast:\tif popped %@", object);
        if ([object isKindOfClass:[NSString class]]) {
            NSString *condition = (NSString *)object;
            NSLog(@">>ast:\tif popped condition %@", condition);
            if ([condition isEqualToString:@"true"]) {
                result = YES;
            } else if ([condition isEqualToString:@"false"]) {
                result = NO;
            } else {
                // lookup variable in the model
                //
                NSString *val = [model getVariable:condition];
                
                // if found and not null or zero length, set result to true
                //
                if (val) {
                    NSLog(@">>ast:\tif found %@ %@", condition, val);
                    if ([val length] > 0) {
                        NSLog(@">>ast:\tif true  %@", condition);
                        result = YES;
                    }
                }
            }
        }
    }

    if (result == YES) {
        NSLog(@">>ast:\tif taking then branch");
        return branchThen;
    }
    if (branchElse) {
        NSLog(@">>ast:\tif taking else branch");
        return branchElse;
    }
    NSLog(@">>ast:\tif taking nextNode branch");
    return nextNode;
}

-(void) setElse: (ExecutableAST *)node {
    branchElse = node;
}

-(void) setNext: (ExecutableAST *)node {
    nextNode = node;
}

-(void) setThen: (ExecutableAST *)node {
    branchThen = node;
}

#if 0

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
#endif

@end
