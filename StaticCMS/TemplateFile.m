//
//  TemplateFile.m
//  StaticCMS
//
//  Created by Michael Henderson on 1/4/13.
//  Copyright (c) 2013 Michael Henderson. All rights reserved.
//

#import "TemplateFile.h"

@implementation TemplateFile

-(NSString *) data {
    return data;
}

-(Boolean) findFile:(NSString *)fileName withSearchPath:(QStack *)searchPath
{
    NSEnumerator *e = [searchPath reverseObjectEnumerator];
    id            object;
    while (object = [e nextObject]) {
        NSString *filePath = object;
        NSString *fullPath = [filePath stringByAppendingString:fileName];

        NSLog(@"looking for template %@", fullPath);
        
        // search for the file
        //
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
            path     = [filePath copy];
            name     = [fileName copy];
            fullName = [fullPath copy];

            NSLog(@"found       template %@", fullName);
            
            return true;
        }
    }
    
    // if we got here, then we failed to find the file
    //
    return false;
}

-(NSString *) fullFileName
{
    return fullName;
}

-(Boolean) loadFile
{
    NSError *err = 0;
    
    data = [NSString stringWithContentsOfFile:fullName encoding:NSUTF8StringEncoding error:&err];
    if (!data) {
        NSLog(@"error reading %@\n\t%@\n", fullName, [err localizedFailureReason]);
        return false;
    }
    
    NSLog(@"loaded      template %@", fullName);

    return true;
}

@end
