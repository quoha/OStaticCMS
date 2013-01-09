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
    
    // pop top element from Stack
    //
    id object = [stack popTop];
    if ([object isKindOfClass:[NSString class]]) {
        NSString *condition = (NSString *)object;
        if ([condition isEqualToString:@"true"]) {
            result = YES;
        }
    }

    if (result == YES) {
        return branchThen;
    }
    if (branchElse) {
        return branchElse;
    }
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
