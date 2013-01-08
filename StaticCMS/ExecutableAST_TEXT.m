//
//  ExecutableAST_TEXT.m
//  StaticCMS
//
//  Created by Michael Henderson on 1/7/13.
//  Copyright (c) 2013 Michael Henderson. All rights reserved.
//

#import "ExecutableAST_TEXT.h"

@implementation ExecutableAST_TEXT

-(id) init {
    return [self initWithString:nil];
}

-(id) initWithString: (NSString *) string {
    self = [super init];
    if (self) {
        text = string;
    }
    return self;
}

-(void) dump {
    NSLog(@"**ast:\ttext <%@>", text);
}

// push text onto stack
//
-(ExecutableAST *) execute: (QStack *) stack withTrace:(BOOL)doTrace {
    if (doTrace) {
        NSLog(@">>ast:\tpush <%@>", text);
    }

    if (stack) {
        [stack pushTop:text];
    }

    return nextNode;
}

@end
