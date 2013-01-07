//
//  Reference.h
//  StaticCMS
//
//  Created by Michael Henderson on 1/5/13.
//  Copyright (c) 2013 Michael Henderson. All rights reserved.
//
#ifndef StaticCMS_Reference_H
#define StaticCMS_Reference_H

#import <Foundation/Foundation.h>

@interface Reference : NSObject
{
    NSString *name;
    NSObject *obj;
}

-(NSString *) name;
-(void      ) setName: (NSString *) name;
-(void      ) setObject: (id)obj;

@end
#endif
