//
//  BannerViewController.m
//  HappyLife
//
//  Created by Ramonqlee on 8/9/13.
//
//

#import "BannerViewController.h"
#import "MobiSageSDK.h"
#import "CommonHelper.h"

@interface BannerViewController ()<MobiSageAdBannerDelegate>
@property(nonatomic,assign)BOOL validClick;
@property(nonatomic,retain)UILabel* label;
@end

@implementation BannerViewController
@synthesize label;
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
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    NSString *contentMessage = [NSString stringWithFormat:NSLocalizedString(kEarnGoldTipForBanner, nil),kGoldByClickingBanner];
    [self showBanner:contentMessage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - MobiSageAdViewDelegate 委托
#pragma mark
- (UIViewController *)viewControllerToPresent {
    return self;
}
/**
 *  adBanner请求成功并展示广告
 *  @param adBanner
 */
- (void)mobiSageAdBannerSuccessToShowAd:(MobiSageAdBanner*)adBanner
{
    self.validClick = YES;
    NSLog(@"mobiSageAdBannerSuccessToShowAd");
}
/**
 *  adBanner被点击
 *  @param adBanner
 */
- (void)mobiSageAdBannerClick:(MobiSageAdBanner*)adBanner
{
    //invalid click
    if(!self.validClick)
    {
        //
        NSLog(@"invalid mobiSageAdBannerClick");
        [CommonHelper setGold:[CommonHelper gold]-kGoldByClickingBanner];
    }
    
    
    self.validClick = NO;
    NSLog(@"mobiSageAdBannerClick");
}

@end
