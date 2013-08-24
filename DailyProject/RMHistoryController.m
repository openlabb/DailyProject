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
        return [self getSqlDataInner:dbName withKeyWord:keywords withDate:date];
    }
    
    return  [super loadData:dbName withKeyWord:keywords  withDate:date];
}

-(NSArray*)getSqlDataInner:(NSString*)dbName withKeyWord:(NSString*)keywords withDate:(NSDate*)date
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
    
    return [super dictItems:[dbManager getRowsForQuery:query]];
}

@end
