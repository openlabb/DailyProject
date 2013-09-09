//
//  main.m
//  DailyProject
//
//  Created by Ramonqlee on 8/11/13.
//  Copyright (c) 2013 iDreems. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RMAppDelegate.h"

void uncaughtExceptionHandler(NSException *exception) {
    NSLogv(@"CRASH: %@", exception);
    NSLogv(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}

int main(int argc, char *argv[])
{
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([RMAppDelegate class]));
    }
}
