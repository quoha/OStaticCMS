//
//  ExecutableAST_ELSE.m
//  StaticCMS
//
//  Created by Michael Henderson on 1/7/13.
//  Copyright (c) 2013 Michael Henderson. All rights reserved.
//

#import "ExecutableAST_ELSE.h"

@implementation ExecutableAST_ELSE

-(id) init {
    self = [super init];
    if (self) {
        //
    }
    return self;
}

-(void) dump {
    NSLog(@"**ast:\telse");
}

-(ExecutableAST *) execute: (QStack *) stack withTrace:(BOOL)doTrace {
    if (doTrace) {
        NSLog(@">>ast:\trun else");
    }
    return nextNode;
}

@end
