//
//  RMHistoryController.h
//  DailyProject
//
//  Created by Ramonqlee on 8/21/13.
//  Copyright (c) 2013 iDreems. All rights reserved.
//

#import "ArticlesMultiPageViewController.h"

@interface RMHistoryController : ArticlesMultiPageViewController
-(id)initWithFrame:(CGRect)rc;

//获取明天的内容简介
+(NSString*)getTomorrowSummary:(NSString*)dbName withKeyWord:(NSString*)keywords;
@end
