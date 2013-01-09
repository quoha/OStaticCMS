//
//  Model.h
//  StaticCMS
//
//  Created by Michael Henderson on 1/7/13.
//  Copyright (c) 2013 Michael Henderson. All rights reserved.
//
#ifndef StaticCMS_Model_H
#define StaticCMS_Model_H

#import <Foundation/Foundation.h>
#import "SearchPath.h"

@interface Model : NSObject
{
    NSMutableDictionary *locals;
}

-(BOOL      ) addVariable: (NSString *)name withValue:(NSString *)value;
-(BOOL      ) addVariablesFromFile: (NSString *)fileName withSearchPath: (SearchPath *)searchPath;
-(BOOL      ) addVariablesFromPath: (NSString *)filePath;
-(BOOL      ) addVariablesFromString: (NSString *)string;
-(void      ) dump;
-(NSString *) getVariable: (NSString *)name;

@end

#endif