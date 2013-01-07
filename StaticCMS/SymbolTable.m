//
//  SymbolTable.m
//  StaticCMS
//
//  Created by Michael Henderson on 1/5/13.
//  Copyright (c) 2013 Michael Henderson. All rights reserved.
//

#import "SymbolTable.h"

@implementation SymbolTable

-(id) init
{
    self = [super init];
    if (self) {
        symbolTable = [NSMutableDictionary dictionaryWithCapacity:1024];
    }
    return self;
}

-(void) addReference:(Reference *)r
{
    [symbolTable setObject:r forKey:[r name]];
}

-(id) objectForKey: (NSString  *)name;
{
    return [symbolTable objectForKey:name];
}

@end
