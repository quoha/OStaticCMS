//
//  ExecutableAST_include.m
//  StaticCMS
//
//  Created by Michael Henderson on 1/7/13.
//  Copyright (c) 2013 Michael Henderson. All rights reserved.
//

#import "ExecutableAST_include.h"

@implementation ExecutableAST_include

-(id) init {
    self = [super init];
    if (self) {
        //
    }
    return self;
}

-(void) dump {
    NSLog(@"**ast:\tinclude");
}

//
// include
//   t -- {included file}
//
-(ExecutableAST *) execute: (QStack *) stack withTrace:(BOOL)doTrace {
    if (doTrace) {
        NSLog(@">>ast:\tinclude");
    }
  
    if (!stack ||[stack size] < 1) {
        NSLog(@"error:\tinclude requires at least one argument on the stack");
        return nil;
    }

    id object = [stack popTop];
    if (![object isKindOfClass:[NSString class]]) {
        NSLog(@"error:\tinclude requires a string argument on the stack");
        return nil;
    }
    
    if (doTrace) {
        NSLog(@">>ast:\tinclude <%@>", object);
    }

    return nextNode;
}

@end
