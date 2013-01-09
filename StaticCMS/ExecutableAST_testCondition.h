//
//  ExecutableAST_testCondition.h
//  StaticCMS
//
//  Created by Michael Henderson on 1/8/13.
//  Copyright (c) 2013 Michael Henderson. All rights reserved.
//

#ifndef StaticCMS_ExecutableAST_testCondition_H
#define StaticCMS_ExecutableAST_testCondition_H

#import <Foundation/Foundation.h>
#import "ExecutableAST.h"

@interface ExecutableAST_testCondition : ExecutableAST

-(void           ) dump;
-(ExecutableAST *) execute: (QStack *) stack withTrace:(BOOL)doTrace;

@end

#endif