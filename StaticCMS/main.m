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
#import "ExecutableAST.h"
#import "Model.h"
#import "QStack.h"
#import "Reference.h"
#import "SearchPath.h"
#import "SymbolTable.h"
#import "TemplateFile.h"

static const char *optHelp         = "--help";
static const char *optModelFile    = "--model-file=";
static const char *optOutputFile   = "--output-file=";
static const char *optSearchPath   = "--search-path=";
static const char *optTemplateFile = "--template-file=";

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

        Model        *model              = [[Model alloc] init];
        NSString     *outputFile         = 0;
        TemplateFile *rootFile           = 0;
        NSString     *rootView           = 0;
        SearchPath   *searchPath         = [[SearchPath alloc] init];
        QStack       *stack              = [[QStack alloc] init];

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
            } else if (OptIs(opt, optModelFile) && *s) {
                // load the model from the file
                //
                if (![model addVariablesFromFile:val withSearchPath:searchPath]) {
                    NSLog(@"error:\tcould not load model '%@'", val);
                    return 2;
                }
                val = 0;
                [model dump];
            } else if (OptIs(opt, optOutputFile) && *s) {
                // save the output file name
                //
                outputFile = val;
                val = 0;
            } else if (OptIs(opt, optSearchPath) && *s) {
                // add search path
                //
                [searchPath addPath:val];
            } else if (OptIs(opt, optTemplateFile) && *s) {
                // use the template search path to find the template file
                //
                if (rootView) {
                    NSLog(@"error:\tyou may only specify one template file\n");
                    return 2;
                }

                rootView = val;
                val      = 0;
            } else {
                NSLog(@"error:\tinvalid option '%s'\n", opt);
                return 2;
            }
        }

        if (!rootView) {
            NSLog(@"error:\tyou must specify a root view to use\n");
            return 2;
        }

        // we're going to create a view that does nothing but include the first
        // template. we'll use that view. i think that the rational for doing
        // this is to make it look exactly like it will in the rest of the code.
        // in other words, we don't have to treat the bootstrapping as anything
        // special
        //
        NSString *firstView = [[NSString alloc] initWithFormat:@"<cms <%@> include />", rootView];

        // test the ast / parser
        //
        ExecutableAST *ast = [ExecutableAST fromString:firstView];
        [ExecutableAST dump:ast];

        // execute that ast
        //
        [ExecutableAST execute:ast withStack:stack andModel:model andTrace:YES andSearchPath:searchPath];
        [stack dump];
        
        if (!outputFile) {
            NSLog(@" warn:\tno output file specified, so not saving results");
            return 1;
        }

        NSLog(@" info:\tcompleted processing %@", [rootFile fullFileName]);

        NSLog(@"StaticCMS complete.");
    }
    return 0;
}

