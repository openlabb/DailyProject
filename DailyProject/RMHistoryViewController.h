//
//  RMSecondViewController.h
//  DailyProject
//
//  Created by Ramonqlee on 8/11/13.
//  Copyright (c) 2013 iDreems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticlesMultiPageViewController.h"
#import "RMHistoryController.h"


#ifndef TodayinHistory
@interface RMHistoryViewController : ArticlesMultiPageViewController
#else
@interface RMHistoryViewController : RMHistoryController
#endif

@end
