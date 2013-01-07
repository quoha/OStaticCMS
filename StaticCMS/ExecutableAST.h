//
//  ExecutableAST.h
//  StaticCMS
//
//  Created by Michael Henderson on 1/6/13.
//  Copyright (c) 2013 Michael Henderson. All rights reserved.
//
#ifndef StaticCMS_ExecutableAST_H
#define StaticCMS_ExecutableAST_H

#import <Foundation/Foundation.h>
#include "QStack.h"

@interface ExecutableAST : NSObject
{
    Boolean isELSE;
    Boolean isENDIF;
    Boolean isIF;
    Boolean isNOOP;
    Boolean isTEXT;
    Boolean isWORD;
    
    ExecutableAST *branchElse;
    ExecutableAST *branchThen;
    ExecutableAST *nextNode;
    NSString      *text;
}

+(Boolean        ) execute: (ExecutableAST *) ast withStack:(QStack *) stack;
+(ExecutableAST *) fixupIF: (ExecutableAST *) root;
+(ExecutableAST *) fixWordType: (ExecutableAST *) root;
+(ExecutableAST *) fromStack: (QStack *) stack;
+(ExecutableAST *) fromString: (NSString *) string;
+(ExecutableAST *) initNOOP;
+(ExecutableAST *) initTEXT: (NSString *)text;
+(ExecutableAST *) initWORD: (NSString *)text;

-(void) dump;

@end

#endif