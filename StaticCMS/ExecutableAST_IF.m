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

@end
