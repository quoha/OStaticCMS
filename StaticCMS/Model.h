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
#import "QStack.h"

@interface Model : NSObject
{
    NSMutableDictionary *locals;
}

-(Boolean   ) addVariable: (NSString *)name withValue:(NSString *)value;
-(Boolean   ) addVariablesFromFile: (NSString *)fileName withSearchPath: (QStack *)searchPath;
-(Boolean   ) addVariablesFromPath: (NSString *)filePath;
-(Boolean   ) addVariablesFromString: (NSString *)string;
-(void      ) dump;
-(NSString *) getVariable: (NSString *)name;

@end

#endif