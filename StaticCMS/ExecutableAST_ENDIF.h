//
//  ExecutableAST_ENDIF.h
//  StaticCMS
//
//  Created by Michael Henderson on 1/7/13.
//  Copyright (c) 2013 Michael Henderson. All rights reserved.
//

#ifndef StaticCMS_ExecutableAST_ENDIF_H
#define StaticCMS_ExecutableAST_ENDIF_H

#import <Foundation/Foundation.h>
#import "ExecutableAST.h"

@interface ExecutableAST_ENDIF : ExecutableAST

-(void           ) dump;
-(ExecutableAST *) execute: (QStack *) stack withTrace:(BOOL)doTrace;

@end

#endif
