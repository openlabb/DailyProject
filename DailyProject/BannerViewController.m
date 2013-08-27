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
    CGSize size = [self showBanners];
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    rect.origin.y += 2*rect.size.height;
    rect.size.height = self.view.frame.size.height/2;
    
    self.label = [[[UILabel alloc]initWithFrame:rect]autorelease];
    [self.label release];
    label.font = [UIFont boldSystemFontOfSize:kTitleFontSize];
    label.baselineAdjustment = UIBaselineAdjustmentNone;
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textColor = [UIColor redColor];
    [label setBackgroundColor:[UIColor clearColor]];
    label.numberOfLines = 0;
    label.text = [NSString stringWithFormat:@"点广告，返回就赚 %d 积分\n\n看不到广告?请稍等...\n\n小窍门：可以在其他广告条出现的地方点击，储备积分。",kGoldByClickingBanner];
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
