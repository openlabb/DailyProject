//
//  RecommendViewController.m
//  HappyLife
//
//  Created by Ramonqlee on 8/9/13.
//
//

#import "RecommendViewController.h"
#import "CommonHelper.h"
#import "MobiSageSDK.h"

#define kAdMaxCount 4
#define kCellHeight 157

@interface RecommendViewController ()<MobiSageRecommendDelegate>
@property (nonatomic, retain) MSRecommendContentView *recommendView;
@end

@implementation RecommendViewController
@synthesize recommendView;

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

    
    CGRect rect = self.view.frame;
    rect.size.height = 4*kTitleFontSize;
        
    UILabel* label = [[[UILabel alloc]initWithFrame:rect]autorelease];
    label.font = [UIFont boldSystemFontOfSize:kTitleFontSize];
    label.baselineAdjustment = UIBaselineAdjustmentNone;
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textColor = [UIColor redColor];
    [label setBackgroundColor:[UIColor clearColor]];
    label.numberOfLines = 0;
    label.text = [NSString stringWithFormat:@"点击推荐应用，立赚 %d 积分\n\n应用列表加载中，请稍等",kGoldByClickingRecommendView];
    [self.view addSubview:label];

    
    rect.origin.y += rect.size.height;
    rect.size.height = kCellHeight*kAdMaxCount;
    
    self.recommendView = [[[MSRecommendContentView alloc] initWithdelegate:self width:300.0f adCount:kAdMaxCount] autorelease];
    self.recommendView.frame = rect;
    [self.view addSubview:self.recommendView];
    
    //hook tableview in this view
    [self.recommendView hookTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - MobiSageRecommendDelegate 委托函数
#pragma mark

- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}

@end
