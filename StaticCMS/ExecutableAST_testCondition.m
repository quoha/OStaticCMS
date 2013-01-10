//
//  ExecutableAST_testCondition.m
//  StaticCMS
//
//  Created by Michael Henderson on 1/8/13.
//  Copyright (c) 2013 Michael Henderson. All rights reserved.
//

#import "ExecutableAST_testCondition.h"

@implementation ExecutableAST_testCondition

-(id) init {
    self = [super init];
    if (self) {
        //
    }
    return self;
}

-(void) dump {
    NSLog(@"**ast:\ttestCondition");
}

//
// {variableName} -- {true if variable is set and not-null}
//
-(ExecutableAST *) execute: (QStack *) stack withTrace:(BOOL)doTrace {
    if (doTrace) {
        NSLog(@">>ast:\trun testCondition");
    }

    if ([stack isEmpty]) {
        NSLog(@"error:\ttestCondition requires a variable name to be on the stack");
        return nil;
    }
    
    BOOL result = NO;
    
    Model *model = [ExecutableAST getModel];
    if (!model) {
        // answer must always be false
        //
        if (doTrace) {
            NSLog(@">>ast:\ttestCondition found no model, forcing to false");
        }
    } else {
        // pop top element from Stack
        //
        id object = [stack popTop];
        NSLog(@">>ast:\ttestCondition looking for %@", object);

        if ([object isKindOfClass:[NSString class]]) {
            // lookup variable in the model
            //
            NSString *val = [model getVariable:object];
            
            // if found and not null or zero length, set result to true
            //
            if (val) {
                NSLog(@">>ast:\ttestCondition found %@ %@", object, val);
                if ([val length] > 0) {
                    NSLog(@">>ast:\ttestCondition true  %@", object);
                    result = YES;
                }
            }
        }
    }

    if (result == YES) {
        NSLog(@">>ast:\ttestCondition push true");
        [stack pushTop:@"true"];
    } else {
        NSLog(@">>ast:\ttestCondition push false");
        [stack pushTop:@"false"];
    }
    
    return nextNode;
}

@end
