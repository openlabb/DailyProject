//
//  ArticleListViewController.m
//  HappyLife
//
//  Created by Ramonqlee on 8/8/13.
//
//

#import "ArticleListViewController.h"
#import "SQLiteManager.h"
#import "RMArticle.h"
#import "RMArticlesView.h"
#import "CommonHelper.h"
#import "EarnGoldMultiPageViewController.h"

#define PAGE_SEPARATOR @"|||"

@interface ArticleListViewController ()<tableViewClickDelegate>
@property(nonatomic,retain)RMArticlesView* articleController;
@property(nonatomic,retain)NSArray* dataList;
@property(nonatomic,assign)BOOL loadingData;
@end

@implementation ArticleListViewController
@synthesize title;
@synthesize dataList;

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
    CGRect rc = self.view.frame;
    rc.size.height = kDeviceHeight - kTabHeight - kNavigationBarHeight;
    rc.origin.y = 0;
    
    BOOL existView = YES;
    if(!self.articleController)
    {
        existView = NO;
        self.articleController = [[RMArticlesView alloc]initWithFrame:rc];
    }
    
    
    self.articleController.delegate = self;
    self.articleController.tableViewDelegate = self;
    
    if(!existView)
    {
        [self.view addSubview:self.articleController];
    }
    
    if (!self.dataList && !self.loadingData) {
        //load data on background view
        self.loadingData = YES;
        [self performSelectorInBackground:@selector(updateData) withObject:nil];
        [self addActivityIndicatorView];
    }
}
-(void)addActivityIndicatorView
{
    UIActivityIndicatorView* view = [[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]autorelease];
    view.frame = self.view.frame;
    view.color = [UIColor orangeColor];
    view.hidesWhenStopped = YES;
    
    [self.view addSubview:view];
    [view startAnimating];
}
-(void)stopActivityIndicatorView
{
    for (UIView* view in [self.view subviews]) {
        if([view isKindOfClass:[UIActivityIndicatorView class]])
        {
            [((UIActivityIndicatorView*)view) stopAnimating];
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark util methods
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
        
        
        [data addObject:article];
    }
    
    return data;
}
-(NSArray*)getSqlData:(NSString*)dbName withKeyWord:(NSString*)keywords
{
    //single file
#define kDataFile @"data.sql"
    NSString* resourceDbFile = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle]resourcePath],kDataFile];
    if ([[NSFileManager defaultManager]fileExistsAtPath:resourceDbFile]) {
        return [self getCommonSqlData:kDataFile withKeyWord:keywords];
    }
    
    SQLiteManager* dbManager = [[[SQLiteManager alloc] initWithDatabaseNamed:[NSString stringWithFormat:@"%@.sql",dbName]]autorelease];
    
    NSMutableArray* data = [[[NSMutableArray alloc]init]autorelease];
    
    //TODO::get today's data
    //day of year
    //no data,then from beginning
#define kDaysOfYear 365
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"DDD"];
    NSInteger dayInYear = [[dateFormat stringFromDate:today] integerValue];
    NSInteger rowCount = [dbManager getRecordCount:@"Content"];
    NSInteger kMaxCountForOneDay = (rowCount-rowCount%kDaysOfYear)/kDaysOfYear;
    NSInteger startIndex = dayInYear*kMaxCountForOneDay;
    while (startIndex>rowCount) {
        startIndex /= 2;
    }
    
    //clean null rows
    //[dbManager doQuery:@"DELETE FROM Content WHERE title is null"];
    //select range
    NSString* query = [NSString stringWithFormat:@"SELECT * FROM Content LIMIT %d OFFSET %d",kMaxCountForOneDay,startIndex];
    
    
    NSLog(@"query:%@",query);
    NSArray* rows=[dbManager getRowsForQuery:query];

    
    for (NSDictionary* row in rows) {
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
        
        article.summary = [row objectForKey:@"summary"];
        if (!article.summary) {
            article.summary = [row objectForKey:@"Summary"];
        }
        
        [data addObject:article];
    }
    
    return data;
}

#pragma  mark tableviewDelegate
- (BOOL)canSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //FIXME::temp for test
    NSInteger gold = [CommonHelper gold];
    [CommonHelper setGold:--gold];
    NSLog(@"gold left:%d",gold);
    return gold>=0;
}
-(void)popTipView
{
    //TODO::pop up gold-earning view
    CGRect rect = self.view.frame;
    
    EarnGoldMultiPageViewController* controller = [[[EarnGoldMultiPageViewController alloc]initWithFrame:rect]autorelease];
    UIResponder *responder = self;
    while (responder && ![responder isKindOfClass:[MultiPageViewController class]]) {
        responder = [responder nextResponder];
    }
    UINavigationController* navi = [[[UINavigationController alloc]initWithRootViewController:controller]autorelease];
    [(UIViewController*)responder presentViewController:navi animated:YES completion:nil];
}

#pragma mark update data methods
-(void)updateData
{
    self.dataList = [self getSqlData:self.title withKeyWord:self.title];
    self.loadingData = NO;
    [self performSelectorOnMainThread:@selector(loadDataOnMainThread) withObject:nil waitUntilDone:YES];
}
-(void)loadDataOnMainThread
{
    [self stopActivityIndicatorView];
    [self.articleController setData:dataList];
}
@end
