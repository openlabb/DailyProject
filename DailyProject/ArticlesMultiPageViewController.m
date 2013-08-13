//
//  ArticlesMultiPageViewController.m
//  HappyLife
//
//  Created by Ramonqlee on 8/9/13.
//
//

#import "ArticlesMultiPageViewController.h"
#import "ArticleListViewController.h"
#import "MobiSageSDK.h"
#import "CommonHelper.h"
#import "appConstants.h"
#import "DAPagesContainer.h"
#import "resConstants.h"
#import "SQLiteManager.h"
#import "RMArticle.h"

#define PAGE_SEPARATOR @"|||"

@interface ArticlesMultiPageViewController ()<ArticleListViewDelegate>

@end

@implementation ArticlesMultiPageViewController

-(id)initWithFrame:(CGRect)rc
{
    self = [super init];
    self.rect = rc;
    
    //for tab item
    self.title = NSLocalizedString(Tab_Title_DailyArticles, "");
    self.tabBarItem.image = [UIImage imageNamed:kIconHomePage];
    self.navigationItem.title = NSLocalizedString(Title, "");
    
    return self;
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
    self.view.frame = self.rect;
    
	// Do any additional setup after loading the view.
#ifdef kMakeup
    UIViewController *mb = [[[ArticleListViewController alloc] initWithFrame:self.rect]autorelease];
    mb.title = @"美白小窍门";
    
    UIViewController *bs = [[[ArticleListViewController alloc] init]autorelease];
    bs.title = @"保湿技巧";
    
    UIViewController *ys = [[[ArticleListViewController alloc] init]autorelease];
    ys.title = @"饮食美容";
    
    self.pagesContainer.viewControllers = @[mb, bs, ys];
#elif defined kMakeToast
    UIViewController *mb = [[[ArticleListViewController alloc] init]autorelease];
    mb.title = @"祝酒词";
    
    UIViewController *tj = [[[ArticleListViewController alloc] init]autorelease];
    tj.title = @"提酒词";
    
    UIViewController *bs = [[[ArticleListViewController alloc] init]autorelease];
    bs.title = @"敬酒词";
    
    UIViewController *jj = [[[ArticleListViewController alloc] init]autorelease];
    jj.title = @"拒酒词";
    
    UIViewController *qj = [[[ArticleListViewController alloc] init]autorelease];
    qj.title = @"劝酒词";
    
    UIViewController *dj = [[[ArticleListViewController alloc] init]autorelease];
    dj.title = @"挡酒词";
    
    self.pagesContainer.viewControllers = @[mb, bs,tj,jj,qj,dj];
#else
    ArticleListViewController *mb = [[[ArticleListViewController alloc] initWithRect:self.rect]autorelease];
    mb.title = @"夫妻笑话";
    mb.dataDelegate = self;
    
    ArticleListViewController *tj = [[[ArticleListViewController alloc] initWithRect:self.rect]autorelease];
    tj.title = @"情感攻略";
    tj.dataDelegate = self;
    
    ArticleListViewController *bs = [[[ArticleListViewController alloc] initWithRect:self.rect]autorelease];
    bs.title = @"生活健康";
    bs.dataDelegate = self;
    
    ArticleListViewController *jj = [[[ArticleListViewController alloc] initWithRect:self.rect]autorelease];
    jj.title = @"吐槽实录";
    jj.dataDelegate = self;
    
    ArticleListViewController *qgmw = [[[ArticleListViewController alloc] initWithRect:self.rect]autorelease];
    qgmw.title = @"情感美文";
    qgmw.dataDelegate = self;
    
    ArticleListViewController *xxl = [[[ArticleListViewController alloc] initWithRect:self.rect]autorelease];
    xxl.title = @"两性心理";
    xxl.dataDelegate = self;
    
    ArticleListViewController *xbj = [[[ArticleListViewController alloc] initWithRect:self.rect]autorelease];
    xbj.title = @"两性保健";
    xbj.dataDelegate = self;
    
    self.pagesContainer.viewControllers = @[mb,qgmw,bs,tj,jj,xbj,xxl];
#endif
}

#pragma mark ArticleListViewDelegate
- (NSArray*)loadData:(NSString*)dbName withKeyWord:(NSString*)keywords
{
    return [self getSqlData:dbName withKeyWord:keywords];
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
        article.url = [row objectForKey:@"PageUrl"];
        
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
        
        article.summary  = [row objectForKey:@"summary"];
        if (!article.summary) {
            article.summary  = [row objectForKey:@"Summary"];
        }
        
        article.url = [row objectForKey:@"PageUrl"];
        
        [data addObject:article];
    }
    
    return data;
}
@end
