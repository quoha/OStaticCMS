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
    return nextNode;
}

@end
