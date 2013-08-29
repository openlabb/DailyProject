//
//  EarnGoldMultiPageViewController.m
//  HappyLife
//
//  Created by Ramonqlee on 8/9/13.
//
//

#import "EarnGoldMultiPageViewController.h"
#import "ArticleListViewController.h"
#import "DAPagesContainer.h"
#import "ThemeManager.h"
#import "BannerViewController.h"
#import "CommonHelper.h"
#import "RecommendViewController.h"
#import "AdsConfiguration.h"
#import "MobiSageSDK.h"
#import "MSRecommendContentView+MSRecommendContentViewEx.h"
#import "Flurry.h"
#import "RMGoldHelpController.h"

@interface EarnGoldMultiPageViewController ()
@property(nonatomic,assign)NSInteger mInitGold;
@end

@implementation EarnGoldMultiPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSingleTap:) name:kClickRecommendViewEvent object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleBannerSingleTap:) name:kClickBannerEvent object:nil];
}

-(void) viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [BaseViewController showSpot:nil];
    
    [[MobiSageManager getInstance]setPublisherID:[[AdsConfiguration sharedInstance]mobisageId]];
    self.mInitGold = [CommonHelper gold];
    
    self.title = self.mInitGold>0?[NSString stringWithFormat:NSLocalizedString(@"Premium", @""),self.mInitGold]:[NSString stringWithFormat:NSLocalizedString(kNoEnoughPoints, nil)];
    
	// Do any additional setup after loading the view.
    UIViewController *mb = [[[BannerViewController alloc] init]autorelease];
    mb.title = NSLocalizedString(kEarnGoldMethodGPC, nil);//@"GPC积分";
    
    UIViewController *bs = [[[RecommendViewController alloc] init]autorelease];
    bs.title = NSLocalizedString(kEarnGoldMethodGPR, nil);//@"GPR积分";
    
    UIViewController *helpController = [[[RMGoldHelpController alloc] init]autorelease];
    helpController.title = NSLocalizedString(kConsumeGoldHelp, nil);
    
    //UIViewController *ys = [[[ArticleListViewController alloc] init]autorelease];
    //ys.title = @"IAP积分";
    
    self.pagesContainer.viewControllers = @[bs,mb,helpController];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"Back",@"") style: UIBarButtonItemStyleBordered target: self action: @selector(back)];
    newBackButton.tintColor = TintColor;
    [[self navigationItem] setLeftBarButtonItem:newBackButton];
    [newBackButton release];
}
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark notification callback
- (void) appWillEnterForegroundNotification{
    NSLog(@"trigger event when will enter foreground.");
    NSInteger currentGold = [CommonHelper gold];
    self.title = [NSString stringWithFormat:@"赚积分(当前积分:%d)",currentGold];
    
    if (currentGold>self.mInitGold) {
        if([self.view respondsToSelector:@selector(makeToast:)])
        {
            [self.view performSelectorOnMainThread:@selector(makeToast:) withObject:[NSString stringWithFormat:@"恭喜，赚取了 %d 积分",currentGold-self.mInitGold] waitUntilDone:YES];
        }
        self.mInitGold = currentGold;
    }
}
-(void)handleSingleTap:(NSNotification*)notification
{
//    if (notification && [notification.name isEqualToString:kClickRecommendViewEvent])
    {
        [self appWillEnterForegroundNotification];
    }
}
-(void)handleBannerSingleTap:(NSNotification*)notification
{
//    if (notification && [notification.name isEqualToString:kMobisageRecommnedAdSingleTapNotification])
    {
        [self appWillEnterForegroundNotification];
    }
}

@end
