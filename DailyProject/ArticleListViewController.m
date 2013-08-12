//
//  ArticleListViewController.m
//  HappyLife
//
//  Created by Ramonqlee on 8/8/13.
//
//

#import "ArticleListViewController.h"
#import "RMArticlesView.h"
#import "CommonHelper.h"
#import "EarnGoldMultiPageViewController.h"
#import "RMArticle.h"

@interface ArticleListViewController ()<tableViewClickDelegate>
@property(nonatomic,retain)RMArticlesView* articleController;
@property(nonatomic,retain)NSArray* dataList;
@property(nonatomic,assign)BOOL loadingData;
@end

@implementation ArticleListViewController
@synthesize title;
@synthesize dataList;
@synthesize dataDelegate;
@synthesize tableViewRefreshLoadMoreDelegate;

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
    //rc.size.height = kDeviceHeight - kTabHeight - kNavigationBarHeight;
    rc.origin.y = 0;
    
    BOOL existView = YES;
    if(!self.articleController)
    {
        existView = NO;
        self.articleController = [[RMArticlesView alloc]initWithFrame:rc];
    }
    
    self.articleController.delegate = self;
    self.articleController.tableViewDelegate = self;
    if (self.tableViewRefreshLoadMoreDelegate) {
        self.articleController.tableViewRefreshHanlder = self.tableViewRefreshLoadMoreDelegate;
    }
    
    if(!existView)
    {
        [self.view addSubview:self.articleController];
    }
    
    if (!self.dataList && !self.loadingData) {
        //load data on background view
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

#pragma  mark tableviewDelegate
- (BOOL)canSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RMArticle* article = [self.dataList objectAtIndex:indexPath.row];
    if (kHideFavoriteFlag==article.favoriteNumber) {//favorite items
        return YES;
    }
    
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
-(void)refreshData
{
    if (!self.loadingData) {
        //load data on background view
        [self performSelectorInBackground:@selector(updateData) withObject:nil];
        [self addActivityIndicatorView];
    }
}
-(void)updateData
{
    if(self.loadingData)
    {
        return;
    }
    self.loadingData = YES;
    self.dataList = [dataDelegate loadData:self.title withKeyWord:self.title];
    self.loadingData = NO;
    [self performSelectorOnMainThread:@selector(loadDataOnMainThread) withObject:nil waitUntilDone:YES];
}
-(void)loadDataOnMainThread
{
    [self stopActivityIndicatorView];
    [self.articleController setData:dataList];
}
-(void)setTableViewRefreshLoadMoreDelegate:(id<TableViewRefreshLoadMoreDelegate>)delegate
{
    tableViewRefreshLoadMoreDelegate = delegate;
    if(tableViewRefreshLoadMoreDelegate)
    {
        [tableViewRefreshLoadMoreDelegate retain];
    }
    if(self.articleController)
    {
        self.articleController.tableViewRefreshHanlder = delegate;
    }
}
-(void)setData:(NSArray*)data
{
    [self.articleController setData:data];
}
-(NSArray*)getData
{
    return self.articleController.data;
}
@end
