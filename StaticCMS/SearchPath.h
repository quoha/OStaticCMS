//
//  SearchPath.h
//  StaticCMS
//
//  Created by Michael Henderson on 1/8/13.
//  Copyright (c) 2013 Michael Henderson. All rights reserved.
//

#ifndef StaticCMS_SearchPath_H
#define StaticCMS_SearchPath_H

#import <Foundation/Foundation.h>

@interface SearchPath : NSObject
{
    NSMutableArray *searchPath;
}

// add a path to the list of paths to search
//
-(BOOL) addPath: (NSString *)path;

//
//
-(void) dump;

// use the list of paths to find a file. return the full path
// to the file if found, nil if not found
//
-(NSString *) findFile: (NSString *)fileName;

@end

#endif