//
//  ExecutableAST_NOOP.m
//  StaticCMS
//
//  Created by Michael Henderson on 1/7/13.
//  Copyright (c) 2013 Michael Henderson. All rights reserved.
//

#import "ExecutableAST_NOOP.h"

@implementation ExecutableAST_NOOP

-(id) init {
    self = [super init];
    if (self) {
        //
    }
    return self;
}

-(void) dump {
    NSLog(@"**ast:\tno-op");
}

-(ExecutableAST *) execute: (QStack *) stack withTrace:(BOOL)doTrace {
    if (doTrace) {
        NSLog(@">>ast:\trun no-op");
    }
    return nextNode;
}

@end
