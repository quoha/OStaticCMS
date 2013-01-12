//
//  ExecutableAST_compileText.h
//  StaticCMS
//
//  Created by Michael Henderson on 1/10/13.
//  Copyright (c) 2013 Michael Henderson. All rights reserved.
//

#ifndef StaticCMS_ExecutableAST_compileText_H
#define StaticCMS_ExecutableAST_compileText_H

#import <Foundation/Foundation.h>
#import "ExecutableAST.h"

@interface ExecutableAST_compileText : ExecutableAST

-(void           ) dump;
-(ExecutableAST *) execute: (QStack *) stack withTrace:(BOOL)doTrace;

@end

#endif