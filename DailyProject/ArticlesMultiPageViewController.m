//
//  ArticlesMultiPageViewController.m
//  HappyLife
//
//  Created by Ramonqlee on 8/9/13.
//
//

#import "ArticlesMultiPageViewController.h"
#import "MobiSageSDK.h"
#import "CommonHelper.h"
#import "appConstants.h"
#import "DAPagesContainer.h"
#import "resConstants.h"
#import "SQLiteManager.h"
#import "RMArticle.h"

#define PAGE_SEPARATOR @"|||"


@interface ArticlesMultiPageViewController ()

@end

@implementation ArticlesMultiPageViewController
@synthesize viewDate=_viewDate;
@synthesize dbNameList;

-(void)dealloc
{
    self.viewDate= nil;
    self.dbNameList = nil;
    [super dealloc];
}

-(void)setViewDate:(NSDate *)date
{
    _viewDate = [[NSDate alloc]initWithTimeInterval:0 sinceDate:date];
}
-(id)initWithFrame:(CGRect)rc
{
    self = [super init];
    self.rect = rc;
    
    //for tab item
    self.title = NSLocalizedString(Tab_Title_DailyArticles, "");
    self.tabBarItem.image = [UIImage imageNamed:kIconHomePage];
    self.navigationItem.title = NSLocalizedString(Title, "");
    
    _viewDate = [NSDate date];//today
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _viewDate = [NSDate date];//today
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.frame = self.rect;
    
	// Do any additional setup after loading the view.
    NSMutableArray* controllers = [[[NSMutableArray alloc]initWithCapacity:self.dbNameList.count]autorelease];
    for (int i =0; i<self.dbNameList.count; ++i) {
        ArticleListViewController *tmp = [[[ArticleListViewController alloc] initWithRect:self.rect]autorelease];
        tmp.title = [self.dbNameList objectAtIndex:i];
        tmp.dataDelegate = self;
        
        [controllers addObject:tmp];
    }
    self.pagesContainer.viewControllers = controllers;
}

#pragma mark ArticleListViewDelegate
- (NSArray*)loadData:(NSString*)dbName withKeyWord:(NSString*)keywords
{
    return [self getSqlData:dbName withKeyWord:keywords];
}
#pragma mark util methods
-(void)refreshData
{
    for(ArticleListViewController* controller in self.pagesContainer.viewControllers)
    {
        if(controller)
        {
            [controller refreshData];
        }
    }
}

-(NSArray*)getSqlData:(NSString*)dbName withKeyWord:(NSString*)keywords
{
    NSString* resourceDbFile = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle]resourcePath],kDataFile];
    if ([[NSFileManager defaultManager]fileExistsAtPath:resourceDbFile]) {
        return [self getCommonSqlData:kDataFile withKeyWord:keywords];
    }
    
    SQLiteManager* dbManager = [[[SQLiteManager alloc] initWithDatabaseNamed:[NSString stringWithFormat:@"%@.sql",dbName]]autorelease];
    
   
    
    //TODO::get today's data
    if (!_viewDate || ![_viewDate isKindOfClass:[NSDate class]]) {
        _viewDate = [NSDate date];
    }
    //day of year
    //no data,then from beginning
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"DDD"];
    NSInteger dayInYear = [[dateFormat stringFromDate:self.viewDate] integerValue];
    NSInteger rowCount = [dbManager countOfRecords:kDBTableName];
    NSInteger kMaxCountForOneDay = (rowCount-rowCount%kDaysOfYear)/kDaysOfYear;
    NSInteger startIndex = dayInYear*kMaxCountForOneDay;
    while (startIndex>rowCount) {
        startIndex /= 2;
    }
    
    //clean null rows
    //[dbManager doQuery:@"DELETE FROM Content WHERE title is null"];
    //select range
    NSString* query = [NSString stringWithFormat:@"SELECT * FROM %@ LIMIT %d OFFSET %d",kDBTableName,kMaxCountForOneDay,startIndex];
    
    
    NSLog(@"query:%@",query);
    return [self dictItems:[dbManager getRowsForQuery:query]];
}
-(NSArray*)dictItems:(NSArray*)dict
{
     NSMutableArray* data = [[[NSMutableArray alloc]init]autorelease];
    for (NSDictionary* row in dict) {
        RMArticle* article = [[[RMArticle alloc]init]autorelease];
        article.title = [row objectForKey:@"title"];
        //
        if (!article.title) {
            article.title = [row objectForKey:@"Title"];
        }
        
        NSString* content = [row objectForKey:@"Content"];
        if (!content) {
            content = [row objectForKey:@"content"];
        }
        if (!content) {
            content = [NSString stringWithFormat:@"%@%@",[row objectForKey:@"contentA"],[row objectForKey:@"contentB"]];
        }
        NSMutableString* tmp = [NSMutableString stringWithFormat:@"%@",content];
        NSRange range = NSMakeRange(0, tmp.length);
        [tmp replaceOccurrencesOfString:PAGE_SEPARATOR withString:@"\n" options:NSLiteralSearch range:range];
        article.content  = tmp;
        
        article.summary  = [row objectForKey:@"summary"];
        if (!article.summary) {
            article.summary  = [row objectForKey:@"Summary"];
        }
        
        article.url = [row objectForKey:@"PageUrl"];
        
        [data addObject:article];
    }
    return data;
}
-(NSArray*)getCommonSqlData:(NSString*)dbName withKeyWord:(NSString*)keywords
{
    SQLiteManager* dbManager = [[[SQLiteManager alloc] initWithDatabaseNamed:[NSString stringWithFormat:@"%@",dbName]]autorelease];
    
    NSMutableArray* data = [[[NSMutableArray alloc]init]autorelease];
    NSString* query = [NSString stringWithFormat:@"SELECT * FROM Content WHERE Title LIKE '%%%@%%'",keywords];
    
    //clean null rows
    //[dbManager doQuery:@"DELETE FROM Content WHERE Title is null"];
    NSLog(@"query:%@",query);
    NSArray* rows=[dbManager getRowsForQuery:query];
    
    for (NSDictionary* row in rows) {
        RMArticle* article = [[[RMArticle alloc]init]autorelease];
        article.title = [row objectForKey:@"Title"];
        article.content = [NSString stringWithFormat:@"%@",[row objectForKey:@"Content"]];
        NSMutableString* tmp = [NSMutableString stringWithFormat:@"%@",article.content];
        NSRange range = NSMakeRange(0, tmp.length);
        [tmp replaceOccurrencesOfString:PAGE_SEPARATOR withString:@"\n" options:NSLiteralSearch range:range];
        article.content  = tmp;
        
        article.summary = [row objectForKey:@"Summary"];
        article.url = [row objectForKey:@"PageUrl"];
        
        [data addObject:article];
    }
    
    return data;
}
@end
