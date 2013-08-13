//
//  RMFirstViewController.m
//  DailyProject
//
//  Created by Ramonqlee on 8/11/13.
//  Copyright (c) 2013 iDreems. All rights reserved.
//

#import "RMFavoriteViewController.h"
#import "resConstants.h"
#import "SQLiteManager.h"
#import "appConstants.h"
#import "RMArticlesView.h"
#import "ArticleListViewController.h"
#import "RMArticle.h"
#import "DAPagesContainer.h"

#define kLoadMoreUnit 10

@interface RMFavoriteViewController ()<ArticleListViewDelegate,TableViewRefreshLoadMoreDelegate>
@property(nonatomic,retain)RMArticlesView* articleController;
@property(nonatomic,assign)NSInteger loadMoreStartIndex;
@end

@implementation RMFavoriteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(Tab_Title_Favorites, @"");
        self.tabBarItem.image = [UIImage imageNamed:kIconFavorite];
    }
    return self;
}
-(id)initWithFrame:(CGRect)rc
{
    self = [super initWithFrame:rc];
    
    //    //for tab item
    self.title = NSLocalizedString(Tab_Title_Favorites, @"");
    self.tabBarItem.image = [UIImage imageNamed:kIconFavorite];
    
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = self.rect;
	// Do any additional setup after loading the view, typically from a nib.
    CGRect frame = self.view.frame;
    
    
    ArticleListViewController *jj = [[[ArticleListViewController alloc] initWithRect:frame]autorelease];
    jj.title = NSLocalizedString(Tab_Title_Favorites, nil);
    jj.dataDelegate = self;
    jj.tableViewRefreshLoadMoreDelegate = self;
    
    self.pagesContainer.viewControllers = @[jj];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(favoriteDBChanged) name:kFavoriteDBChangedEvent object:nil];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark util methods
-(void)favoriteDBChanged
{
    for(UIViewController* controller in self.pagesContainer.viewControllers)
    {
        if ([controller isKindOfClass:[ArticleListViewController class]]) {
            [((ArticleListViewController*)controller) refreshData];
        }
    }
}

-(NSArray*)getTableValue:(NSString*)dbName withTableName:(NSString*)tableName withRange:(NSRange)range
{
    SQLiteManager* dbManager = [[[SQLiteManager alloc] initWithDatabaseNamed:dbName]autorelease];
    NSString* query = [NSString stringWithFormat:@"SELECT * FROM %@ LIMIT %d OFFSET %d",tableName,range.length,range.location];
    
    NSLog(@"query:%@",query);
    
    NSMutableArray* data = [[[NSMutableArray alloc]init]autorelease];
    
    NSArray* items =  [dbManager getRowsForQuery:query];
    for (NSDictionary* item in items) {
        RMArticle* article = [[[RMArticle alloc]init]autorelease];
        article.title = [item objectForKey:kDBTitle];
        article.summary = [item objectForKey:kDBSummary];
        article.content = [item objectForKey:kDBContent];
        article.url = [item objectForKey:kDBPageUrl];
        
        article.likeNumber = ((NSString*)[item objectForKey:kLikeNumber]).intValue;
        article.commentNumber = ((NSString*)[item objectForKey:kCommentNumber]).intValue;
        article.favoriteNumber = ((NSString*)[item objectForKey:kFavoriteNumber]).intValue;
        [data addObject:article];
    }
    return data;
}


+(void)makeSureDBExist
{
    SQLiteManager* dbManager = [[[SQLiteManager alloc]initWithDatabaseNamed:FAVORITE_DB_NAME]autorelease];
    if (![dbManager openDatabase]) {
        //create table
        
        NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT PRIMARY KEY,%@ INTEGER,%@ INTEGER,%@ INTEGER )",kDBTableName,kDBTitle,kDBSummary,kDBContent,kDBPageUrl,kCommentNumber,kFavoriteNumber,kLikeNumber];
        [dbManager doQuery:sqlCreateTable];
        
        [dbManager closeDatabase];
    }
}

+(void)addToFavorite:(RMArticle*)article
{
    [RMFavoriteViewController makeSureDBExist];
    SQLiteManager* dbManager = [[[SQLiteManager alloc] initWithDatabaseNamed:FAVORITE_DB_NAME]autorelease];
    NSString *sql = [NSString stringWithFormat:
                      @"INSERT INTO '%@' ('%@', '%@', '%@', '%@', '%@', '%@', '%@') VALUES ('%@', '%@', '%@', '%@', '%d', '%d', '%d')",
                      kDBTableName, kDBTitle, kDBSummary, kDBContent,kDBPageUrl,kCommentNumber,kFavoriteNumber,kLikeNumber, article.title,article.summary,article.content,article.url,article.commentNumber,article.favoriteNumber,article.likeNumber];
    [dbManager doQuery:sql];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kFavoriteDBChangedEvent object:nil];
}

#pragma mark ArticleListViewDelegate
- (NSArray*)loadData:(NSString*)dbName withKeyWord:(NSString*)keywords
{
    self.loadMoreStartIndex = 0;
    NSRange range = NSMakeRange(self.loadMoreStartIndex, kLoadMoreUnit);
    return [self getTableValue:FAVORITE_DB_NAME withTableName:kDBTableName withRange:range];
}

#pragma mark TableViewRefreshLoadMoreDelegate
- (BOOL)PullToLoadMoreHandler
{
    self.loadMoreStartIndex += kLoadMoreUnit;
    NSRange range = NSMakeRange(self.loadMoreStartIndex, kLoadMoreUnit);
    NSArray* newItems = [self getTableValue:FAVORITE_DB_NAME withTableName:kDBTableName withRange:range];
    if (!newItems || newItems.count==0) {
        return NO;
    }
    
    //update tableview
    ArticleListViewController* listController = nil;
    for(UIViewController* controller in self.pagesContainer.viewControllers)
    {
        if ([controller isKindOfClass:[ArticleListViewController class]]) {
            listController = ((ArticleListViewController*)controller);
            break;
        }
    }
    
    if (listController) {
        NSArray* items = [listController getData];
        NSMutableArray* newMergedItems = [NSMutableArray arrayWithArray:items];
        [newMergedItems addObjectsFromArray:newItems];
        [listController setData:newMergedItems];
    }
    return YES;
}
@end
