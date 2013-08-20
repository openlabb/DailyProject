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
@end

@implementation BannerViewController

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
    //banner view
    MobiSageAdBanner * adBanner = [[MobiSageAdBanner alloc] initWithAdSize:Ad_320X50 withDelegate:self];
    //设置广告轮显方式
    [adBanner setInterval:Ad_Refresh_15];
    [adBanner setSwitchAnimeType:Random];
    [self.view addSubview:adBanner];
    [adBanner release];
    
    CGRect rect = adBanner.frame;
    rect.origin.y += 2*rect.size.height;
    rect.size.height = self.view.frame.size.height/2;
    
    UILabel* label = [[[UILabel alloc]initWithFrame:rect]autorelease];
    label.font = [UIFont boldSystemFontOfSize:kTitleFontSize];
    label.baselineAdjustment = UIBaselineAdjustmentNone;
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textColor = [UIColor redColor];
    [label setBackgroundColor:[UIColor clearColor]];
    label.numberOfLines = 0;
    label.text = [NSString stringWithFormat:@"点击广告条，立赚 %d 积分\n\n小窍门：可以在其他广告条出现的地方点击，储备积分。",kGoldByClickingBanner];
    [self.view addSubview:label];
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
