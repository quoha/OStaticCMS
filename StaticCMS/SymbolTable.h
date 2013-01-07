//
//  SymbolTable.h
//  StaticCMS
//
//  Created by Michael Henderson on 1/5/13.
//  Copyright (c) 2013 Michael Henderson. All rights reserved.
//
#ifndef StaticCMS_SymbolTable_H
#define StaticCMS_SymbolTable_H

#import <Foundation/Foundation.h>
#include "Reference.h"

@interface SymbolTable : NSObject
{
    NSMutableDictionary *symbolTable;
}

-(void) addReference: (Reference *)r;
-(id  ) objectForKey: (NSString  *)name;

@end

#endif
