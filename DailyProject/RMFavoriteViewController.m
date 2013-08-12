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

@interface RMFavoriteViewController ()<ArticleListViewDelegate>
@property(nonatomic,retain)RMArticlesView* articleController;
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
						
- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    [self makeSureDBExist];
    
    ArticleListViewController *jj = [[[ArticleListViewController alloc] init]autorelease];
    jj.title = NSLocalizedString(Tab_Title_Favorites, nil);
    jj.dataDelegate = self;
    
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
-(void)makeSureDBExist
{
    SQLiteManager* dbManager = [[[SQLiteManager alloc]initWithDatabaseNamed:FAVORITE_DB_NAME]autorelease];
    if (![dbManager openDatabase]) {
        //create table
        
        NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT PRIMARY KEY )",kDBTableName,kDBTitle,kDBSummary,kDBContent,kDBPageUrl];
        [dbManager doQuery:sqlCreateTable];
        
        [dbManager closeDatabase];
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
        [data addObject:article];
    }
    return data;
}

+(void)addToFavorite:(RMArticle*)article
{

    SQLiteManager* dbManager = [[[SQLiteManager alloc] initWithDatabaseNamed:FAVORITE_DB_NAME]autorelease];
    NSString *sql = [NSString stringWithFormat:
                      @"INSERT INTO '%@' ('%@', '%@', '%@', '%@') VALUES ('%@', '%@', '%@', '%@')",
                      kDBTableName, kDBTitle, kDBSummary, kDBContent,kDBPageUrl, article.title,article.summary,article.content,article.url];
    [dbManager doQuery:sql];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kFavoriteDBChangedEvent object:nil];
}

#pragma mark ArticleListViewDelegate
- (NSArray*)loadData:(NSString*)dbName withKeyWord:(NSString*)keywords
{
    NSRange range = NSMakeRange(0, 10);
    return [self getTableValue:FAVORITE_DB_NAME withTableName:kDBTableName withRange:range];
}
@end
