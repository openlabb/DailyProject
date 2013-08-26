//
//  RMHistoryController.m
//  DailyProject
//
//  Created by Ramonqlee on 8/21/13.
//  Copyright (c) 2013 iDreems. All rights reserved.
//

#import "RMHistoryController.h"
#import "ArticleListViewController.h"
#import "SQLiteManager.h"
#import "RMArticle.h"

@interface RMHistoryController ()<ArticleListViewDelegate>

@end

@implementation RMHistoryController
-(id)initWithFrame:(CGRect)rc
{
    return [super initWithFrame:rc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ArticleListViewDelegate
- (NSArray*)loadData:(NSString*)dbName withKeyWord:(NSString*)keywords  withDate:(NSDate*)date
{
    //定义了kTodayinHistory
    if ([dbName isEqualToString:kTodayinHistory])
    {
        return [RMHistoryController getSqlData:dbName withKeyWord:keywords withDate:date];
    }
    
    return  [super loadData:dbName withKeyWord:keywords  withDate:date];
}
//获取明天的内容简介
+(NSString*)getTomorrowSummary:(NSString*)dbName withKeyWord:(NSString*)keywords
{
    NSDate* tomorrow = [[NSDate  date] dateByAddingTimeInterval: +86400.0];
    NSArray* items = [RMHistoryController getSqlData:dbName withKeyWord:keywords withDate:tomorrow];
    
    //get title
    if (items.count>2) {
        RMArticle* first = [items objectAtIndex:0];
        RMArticle* second = [items objectAtIndex:1];
        return [NSString stringWithFormat:@"%@-%@",first.title,second.title];
    }
    
    return @"";
}
+(NSArray*)getSqlData:(NSString*)dbName withKeyWord:(NSString*)keywords withDate:(NSDate*)date
{
    SQLiteManager* dbManager = [[[SQLiteManager alloc] initWithDatabaseNamed:[NSString stringWithFormat:@"%@.sql",dbName]]autorelease];
    //get today's data
//    if (!_viewDate || ![_viewDate isKindOfClass:[NSDate class]]) {
//        _viewDate = [NSDate date];
//    }
    NSDate* time = date?date:[NSDate date];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:time]; // Get necessary date components
    NSString* query = [NSString stringWithFormat:@"SELECT * FROM %@ where %@ LIKE '%%年%d月%d日%%'",kDBTableName,kDBTitle,[components month],[components day]];
//    NSString* query = [NSString stringWithFormat:@"SELECT * FROM %@ LIMIT 10 OFFSET 0",kDBTableName];
    
    
    NSLog(@"query:%@",query);
    
    return [ArticlesMultiPageViewController dictItems:[dbManager getRowsForQuery:query]];
}

@end
