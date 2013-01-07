//
//  QStack.m
//  StaticCMS
//
//  Created by Michael Henderson on 1/6/13.
//  Copyright (c) 2013 Michael Henderson. All rights reserved.
//

#import "QStack.h"

@implementation QStack

-(id) init {
    self = [super init];
    if (self) {
        stack = [[NSMutableArray alloc] init];
    }
    return self;
}

// return a ?deep? copy of this stack
//
-(id) copyWithZone:(NSZone *)zone
{
    QStack *tgt = [[[self class] alloc] init];
    if (tgt) {
        [tgt->stack addObjectsFromArray:stack];
    }
    return tgt;
}

-(void) dump {
    // do nothing for now
}

// return an enumerator for going through the stack
// from bottom to top
-(NSEnumerator *) objectEnumerator {
    return [stack objectEnumerator];
}

// return true if empty, false if not empty
//
-(Boolean) isEmpty {
    return [stack count] == 0;
}

// return object at the bottom of the stack
// without removing it from the stack
//
-(id) peekBottom {
    id object = nil;
    if (![self isEmpty]) {
        object = [stack objectAtIndex:0];
    }
    return nil;
}

// return object at the top of the stack
// without removing it from the stack
//
-(id) peekTop {
    return [stack lastObject];
}

// return object at the bottom of the stack
//
-(id) popBottom {
    id object = [self peekBottom];
    if (object) {
        [stack removeObjectAtIndex:0];
    }
    return object;
}

// return object at the top of the stack
//
-(id) popTop {
    id object = [self peekTop];
    [stack removeLastObject];
    return object;
}

// push object onto the bottom of the stack
//
-(void) pushBottom:(id)object {
    [stack addObject:object];
}

// push object onto the top of the stack
//
-(void) pushTop:(id)object {
    [stack addObject:object];
}

// return an enumerator for going through the stack
// from bottom to top
-(NSEnumerator *) reverseObjectEnumerator {
    return [stack reverseObjectEnumerator];
}

// return number of objects in the stack
//
-(NSInteger) size {
    return [stack count];
}

@end
