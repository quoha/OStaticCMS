//
//  main.m
//  StaticCMS
//
//  Created by Michael Henderson on 1/4/13.
//  Copyright (c) 2013 Michael Henderson. All rights reserved.
//
// command line specifies
//   the data file  to use
//   the Controller to use
//
// the system
//   creates functions to
//     manipulate the stack
//     loop
//     test values
//     read View files
//
// the Controller
//   determines
//     which View to use
//     which Model to use
//   load the Model
//   creates the initial AST
//      "name of view" + include
//   return Model and the AST
//
// the Model
//   reads from the data file
//   an example model is
//       ~~~~
//       name value
//       ~~~~
//       articleText
//   creates values
//     push their text to the stack
//     push a sub-stack to the stack
//   creates functions to
//     test data
//     push values to the Stack
//
// the View
//   returns an executable AST when loaded
//
// the AST
//    nodeType ENDIF
//      has nextNode pointer
//    nodeType IF
//      has branchThen and branchElse node pointers
//    nodeType NOOP
//      has nextNode pointer
//    nodeType TEXT
//      pushes text onto the stack
//      has nextNode pointer
//    nodeType WORD
//      expects to execute function named WORD
//      must lookup WORD in Model
//      has nextNode pointer
//
// the Stack
//   holds TEXT only
//
// the Renderer
//   copies data from the Stack to the Output
//

#import <Foundation/Foundation.h>
#include "ExecutableAST.h"
#include "QStack.h"
#include "Reference.h"
#include "SymbolTable.h"
#include "TemplateFile.h"

static const char *optHelp         = "--help";
static const char *optOutputFile   = "--output-file=";
static const char *optSiteName     = "--site-name=";
static const char *optTemplateFile = "--template-file=";
static const char *optTemplatePath = "--template-path=";

//------------------------------------------------------------------
//
static Boolean OptIs(const char *opt, const char *is) {
    while (*opt && *opt == *is) {
        opt++;
        is++;
    }
    return *is ? false : true;
}

//------------------------------------------------------------------
//
int main(int argc, const char * argv[])
{
    @autoreleasepool {
        
        NSLog(@"StaticCMS starting...");

        NSString     *outputFile         = 0;
        TemplateFile *rootFile           = 0;
        SymbolTable  *symbolTable        = [[SymbolTable alloc] init];
        QStack       *templateSearchPath = [[QStack alloc] init];
        NSString     *siteName = @"";
        Reference *r = [[Reference alloc] init];
        [r setName:@"siteName"];
        [r setObject:siteName];

        [symbolTable addReference:r];

        Reference *q = [symbolTable objectForKey:[r name]];
        if (q) {
            NSLog(@"st found '%@'", [q name]);
        }

        for (int idx = 1; idx < argc; idx++) {
            const char *opt = argv[idx];

            // set val to non-NULL if we're working with an option
            // and it has a value. otherwise, set val to NULL.
            //
            NSString   *val = 0;
            const char *s   = opt;
            while (*s && *s != '=') {
                s++;
            }
            if (opt[0] == '-' && opt[1] == '-' && *s == '=') {
                s++;
                val = [NSString stringWithCString:s encoding:NSASCIIStringEncoding];
            }

            // work through the list of options
            //
            if (OptIs(opt, optHelp)) {
                NSLog(@"usage:\t....\n");
                return 2;
            } else if (OptIs(opt, optOutputFile) && *s) {
                // save the output file name
                //
                outputFile = val;
                val = 0;
            } else if (OptIs(opt, optSiteName) && val) {
                siteName = val;
            } else if (OptIs(opt, optTemplateFile) && *s) {
                // use the template search path to find the template file
                //
                if (rootFile) {
                    NSLog(@"error:\tyou may only specify one template file\n");
                    return 2;
                }

                // load and execute (searchPath + fileName)
                //

                rootFile = [[TemplateFile alloc] init];
                Boolean foundFile = [rootFile findFile:val withSearchPath:templateSearchPath];
                if (foundFile) {
                    val = 0;
                } else {
                    NSLog(@"error:\tunable to locate '%@' using template search path", val);
                    [templateSearchPath dump];
                    return 2;
                }

            } else if (OptIs(opt, optTemplatePath) && *s) {
                // add template path
                //
                [templateSearchPath pushTop:val];
            } else {
                NSLog(@"error:\tinvalid option '%s'\n", opt);
                return 2;
            }
        }

        if (!rootFile) {
            NSLog(@"error:\tyou must specify a template file\n");
            return 2;
        }

        // load and execute (searchPath + fileName)
        //
        if (![rootFile loadFile]) {
            NSLog(@"error:\tcould not load template file '%@'", [rootFile fullFileName]);
            return 0;
        }

        NSString *foo = @"textOne<cms codeZero codeOne />textTwo<cms codeTwo if _thenWord_ else _elseWord_ endif charlie/>textThree";

        // test the ast / parser
        //
        ExecutableAST *ast = [ExecutableAST fromString:foo];
        [ast dump];
        ast = [ExecutableAST fromString:[rootFile data]];
        [ast dump];

        if (!outputFile) {
            NSLog(@" warn:\tno output file specified, so not saving results");
            return 1;
        }

        NSLog(@" info:\tcompleted processing %@", [rootFile fullFileName]);

        NSLog(@"StaticCMS complete.");
    }
    return 0;
}

