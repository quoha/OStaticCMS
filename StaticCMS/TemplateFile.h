//
//  TemplateFile.h
//  StaticCMS
//
//  Created by Michael Henderson on 1/4/13.
//  Copyright (c) 2013 Michael Henderson. All rights reserved.
//
#ifndef StaticCMS_TemplateFile_H
#define StaticCMS_TemplateFile_H

#import <Foundation/Foundation.h>
#include "QStack.h"

@interface TemplateFile : NSObject
{
    NSString *data;
    NSString *errmsg;
    NSString *fullName;
    NSString *name;
    NSString *path;
}

-(NSString *) data;
-(Boolean   ) findFile:(NSString *)fileName withSearchPath:(QStack *)searchPath;
-(NSString *) fullFileName;
-(Boolean   ) loadFile;

@end

#endif