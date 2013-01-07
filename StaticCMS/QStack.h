//
//  QStack.h
//  StaticCMS
//
//  Created by Michael Henderson on 1/6/13.
//  Copyright (c) 2013 Michael Henderson. All rights reserved.
//

#ifndef StaticCMS_QStack_H
#define StaticCMS_QStack_H

#import <Foundation/Foundation.h>

@interface QStack : NSObject
{
    NSMutableArray *stack;
}

// create a true copy of the stack
//
-(id) copyWithZone: (NSZone *)zone;

-(void) dump;

// true if empty, false if not
//
-(Boolean) isEmpty;

// return an enumerator for going through the stack
// from bottom to top
//
-(NSEnumerator *) objectEnumerator;

// return an enumerator for going through the stack
// from top to bottom
//
-(NSEnumerator *) reverseObjectEnumerator;

// return object from stack, NULL if empty
// but don't remove it from the stack
//
-(id) peekBottom;
-(id) peekTop;

// return object from stack, NULL if empty
//
-(id) popBottom;
-(id) popTop;

// add object to stack
//
-(void) pushBottom: (id)object;
-(void) pushTop: (id)object;

// number of objects in the stack
//
-(NSInteger) size;

@end

#endif
