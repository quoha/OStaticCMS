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
    NSString *fileName = (NSString *)object;

    if (doTrace) {
        NSLog(@">>ast:\tinclude <%@>", fileName);
    }

    // find the file to include
    //
    NSString   *fullName   = nil;
    SearchPath *searchPath = [ExecutableAST getSearchPath];
    if (searchPath) {
        fullName = [searchPath findFile:fileName];
        if (!fullName) {
            NSLog(@"error:\tunable to locate view file '%@' using search path", fileName);
            return nil;
        }
    } else {
        fullName = fileName;
    }
    if (doTrace) {
        NSLog(@">>ast:\tinclude <%@>", fullName);
    }

    NSError  *err      = 0;
    NSString *viewData = [NSString stringWithContentsOfFile:fullName encoding:NSUTF8StringEncoding error:&err];
    if (!viewData) {
        NSLog(@">>ast:\terror reading %@\n\t%@\n", fullName, [err localizedFailureReason]);
        return nil;
    }
    NSLog(@"%@", viewData);

    // parse the file into an AST
    ExecutableAST *ast = [ExecutableAST fromString:viewData];
    
    // execute it
    [ExecutableAST execute:ast withStack:stack andModel:nil andTrace:doTrace andSearchPath:nil];
    
    return nextNode;
}

@end
