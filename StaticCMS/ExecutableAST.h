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
#import "Model.h"
#import "QStack.h"
#import "SearchPath.h"

@interface ExecutableAST : NSObject
{
    ExecutableAST *nextNode;
}

+(void           ) dump: (ExecutableAST *) node;
+(ExecutableAST *) execute: (ExecutableAST *) ast withStack:(QStack *)stack  andModel:(Model *)model andTrace:(BOOL)doTrace andSearchPath:(SearchPath *)searchPath;
+(ExecutableAST *) fixupIF: (ExecutableAST *) root;
+(ExecutableAST *) fromStack: (QStack *) stack;
+(ExecutableAST *) fromString: (NSString *) string;
+(Model         *) getModel;
+(SearchPath    *) getSearchPath;

-(void           ) dump;
-(ExecutableAST *) execute: (QStack *) stack withTrace:(BOOL)doTrace;
-(ExecutableAST *) getNextNode;
-(void           ) setNextNode:(ExecutableAST *)nextNode;

@end

#endif