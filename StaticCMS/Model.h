//
//  Model.h
//  StaticCMS
//
//  Created by Michael Henderson on 1/7/13.
//  Copyright (c) 2013 Michael Henderson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject
{
    NSMutableDictionary *locals;
}

-(Boolean   ) addVariable: (NSString *)name withValue:(NSString *)value;
-(Boolean   ) addVariablesFromFile: (NSString *)fileName;
-(Boolean   ) addVariablesFromString: (NSString *)string;
-(void      ) dump;
-(NSString *) getVariable: (NSString *)name;

@end
