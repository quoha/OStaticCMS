//
//  Model.m
//  StaticCMS
//
//  Created by Michael Henderson on 1/7/13.
//  Copyright (c) 2013 Michael Henderson. All rights reserved.
//

#import "Model.h"

@implementation Model

-(id) init {
    self = [super init];
    if (self) {
        locals = [NSMutableDictionary dictionaryWithCapacity:1024];
    }
    return self;
}

-(BOOL) addVariable: (NSString *)name withValue:(NSString *)value {
    if (!value) {
        value = @"";
    }
    [locals setObject:value forKey:name];

    return YES;
}

//
//
-(BOOL) addVariablesFromFile: (NSString *)fileName withSearchPath:(SearchPath *)searchPath {
    NSString *fullPath = [searchPath findFile:fileName];
    
    if (!fullPath) {
        NSLog(@"error:\tmodel can't locate file '%@' in search path", fileName);
        return NO;
    }

    return [self addVariablesFromPath:fullPath];
}

//
//
-(BOOL) addVariablesFromPath: (NSString *)fileName {
    NSError  *err  = 0;
    NSString *data = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:&err];
    if (!data) {
        NSLog(@"error:\tmodel failed to read %@\n\t%@\n", fileName, [err localizedFailureReason]);
        return false;
    }
    
    return [self addVariablesFromString:data];
}

//
// format should be
//    "name" = "value";
//    ~~~~
//    article
// if there is no separator, then the entire file is treated as name value pairs.
// in other words, the article is optional. the name value pairs are not.
//
-(BOOL) addVariablesFromString:(NSString *)string {
    NSString  *nameValues = nil;
    NSString  *theArticle = nil;
    NSString  *separator  = @"<@<@>@>\n";
    NSScanner *theScanner = [NSScanner scannerWithString:string];

    [theScanner scanUpToString:separator intoString:&nameValues];
    [theScanner scanString:separator     intoString:nil];
    [theScanner scanUpToString:separator intoString:&theArticle];

    if (theArticle) {
        [self addVariable:@"articleText" withValue:theArticle];
    }
    
    if (nameValues) {
        id result = [nameValues propertyListFromStringsFileFormat];
        if (result && [result isKindOfClass:[NSDictionary class]]) {
            // transfer from result to locals
            //
            for (id key in result) {
                id value = [result objectForKey:key];
                if (value) {
                    [self addVariable:key withValue:value];
                } else {
                    [self addVariable:key withValue:@""];
                }
            }
        }
    }

    return true;
}

-(void) dump {
    for (id key in locals) {
        id value = [locals objectForKey:key];
        if (value) {
            NSLog(@"model:\t%@ = %@", key, value);
        } else {
            NSLog(@"model:\t%@ = nil", key);
        }
    }
}

-(NSString *) getVariable: (NSString *)name {
    return [locals objectForKey:name];
}

@end
