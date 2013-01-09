//
//  SearchPath.m
//  StaticCMS
//
//  Created by Michael Henderson on 1/8/13.
//  Copyright (c) 2013 Michael Henderson. All rights reserved.
//

#import "SearchPath.h"

@implementation SearchPath

-(id) init {
    self = [super init];
    if (self) {
        searchPath = [[NSMutableArray alloc] init];
    }
    return self;
}

// add a path to the list of paths to search
//
-(BOOL) addPath: (NSString *)path {
    if (path) {
        [searchPath addObject:path];
    }
    return YES;
}

//
//
-(void) dump {
    // do nothing for now
}

// use the list of paths to find a file. return the full path
// to the file if found, nil if not found
//
-(NSString *) findFile: (NSString *)fileName {
    // the enumerator will search the list of paths LIFO
    //
    NSEnumerator *e = [searchPath reverseObjectEnumerator];

    id object;
    while (object = [e nextObject]) {
        NSString *filePath = object;
        NSString *fullPath = [filePath stringByAppendingString:fileName];
        
        NSLog(@"search:\tlooking for %@", fullPath);
        
        // search for the file
        //
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
            NSLog(@"search:\tfound       %@", fullPath);
            return fullPath;
        }
    }
    return nil;
}

@end
