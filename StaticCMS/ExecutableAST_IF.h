//
//  ExecutableAST_IF.h
//  StaticCMS
//
//  Created by Michael Henderson on 1/7/13.
//  Copyright (c) 2013 Michael Henderson. All rights reserved.
//

#ifndef StaticCMS_ExecutableAST_IF_H
#define StaticCMS_ExecutableAST_IF_H

#import <Foundation/Foundation.h>
#import "ExecutableAST.h"

@interface ExecutableAST_IF : ExecutableAST
{
    ExecutableAST *branchElse;
    ExecutableAST *branchThen;
}

-(void           ) dump;
-(ExecutableAST *) execute: (QStack *) stack withTrace:(BOOL)doTrace;
-(void           ) setElse: (ExecutableAST *)node;
-(void           ) setNext: (ExecutableAST *)node;
-(void           ) setThen: (ExecutableAST *)node;

@end

#endif
