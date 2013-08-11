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
#import "Constants.h"
#import "DAPagesContainer.h"
#import "resConstants.h"

@interface ArticlesMultiPageViewController ()

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
    
	// Do any additional setup after loading the view.
#ifdef kMakeup
    UIViewController *mb = [[[ArticleListViewController alloc] init]autorelease];
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
    UIViewController *mb = [[[ArticleListViewController alloc] init]autorelease];
    mb.title = @"夫妻笑话";
    
    UIViewController *tj = [[[ArticleListViewController alloc] init]autorelease];
    tj.title = @"情感攻略";
    
    UIViewController *bs = [[[ArticleListViewController alloc] init]autorelease];
    bs.title = @"生活健康";
    
    UIViewController *jj = [[[ArticleListViewController alloc] init]autorelease];
    jj.title = @"吐槽实录";
    
    UIViewController *qgmw = [[[ArticleListViewController alloc] init]autorelease];
    qgmw.title = @"情感美文";
    
    UIViewController *xxl = [[[ArticleListViewController alloc] init]autorelease];
    xxl.title = @"两性心理";
    
    UIViewController *xbj = [[[ArticleListViewController alloc] init]autorelease];
    xbj.title = @"两性保健";
    self.pagesContainer.viewControllers = @[mb,qgmw,bs,tj,jj,xbj,xxl];
#endif
}

@end
