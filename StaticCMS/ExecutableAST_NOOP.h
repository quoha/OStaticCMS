//
//  ExecutableAST_NOOP.h
//  StaticCMS
//
//  Created by Michael Henderson on 1/7/13.
//  Copyright (c) 2013 Michael Henderson. All rights reserved.
//

#ifndef StaticCMS_ExecutableAST_NOOP_H
#define StaticCMS_ExecutableAST_NOOP_H

#import <Foundation/Foundation.h>
#import "ExecutableAST.h"

@interface ExecutableAST_NOOP : ExecutableAST

-(void           ) dump;
-(ExecutableAST *) execute: (QStack *) stack withTrace:(BOOL)doTrace;

@end

#endif
