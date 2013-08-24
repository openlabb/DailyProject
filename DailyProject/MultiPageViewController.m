//
//  MultiPageViewController.m
//  HappyLife
//
//  Created by Ramonqlee on 8/8/13.
//
//

#import "MultiPageViewController.h"
#import "DAPagesContainer.h"
#import "Constants.h"
#import "ThemeManager.h"
#import "resConstants.h"
#import "ArticleListViewController.h"
@interface MultiPageViewController ()

@end

@implementation MultiPageViewController
@synthesize currentTime;
-(void)dealloc
{
    self.pagesContainer = nil;
    [super dealloc];
}
-(id)initWithFrame:(CGRect)rc
{
    self = [super init];
    self.rect = rc;
    
//    //for tab item
//    self.title = NSLocalizedString(Tab_Title_DailyArticles, "");
//    self.tabBarItem.image = [UIImage imageNamed:kIconHomePage];
//    self.navigationItem.title = NSLocalizedString(Title, "");
    
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
    self.currentTime = [NSDate date];
	// Do any additional setup after loading the view.
    self.pagesContainer = [[DAPagesContainer alloc] init:self.rect];
    self.pagesContainer.topBarBackgroundColor = TintColor;
    
    [self.pagesContainer willMoveToParentViewController:self];
    self.pagesContainer.view.frame = self.view.bounds;
    self.pagesContainer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.pagesContainer.view];
    [self.pagesContainer didMoveToParentViewController:self];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UIApplicationSignificantTimeChangeNotificationSelector) name:UIApplicationSignificantTimeChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
+(BOOL)sameDay:(NSDate*)date1 withDate:(NSDate*)date2
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* componentsDate1 = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date1]; // Get necessary date components
    NSDateComponents* componentsDate2 = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date2];
    
    return (componentsDate1.year==componentsDate2.year&&componentsDate1.month==componentsDate2.month&&componentsDate1.day==componentsDate2.day);
}
-(void)UIApplicationSignificantTimeChangeNotificationSelector
{
    //same day
    NSDate* today = [NSDate date];
    if ([MultiPageViewController sameDay:today withDate:self.currentTime]) {
        return;
    }
    self.currentTime = today;
    for(ArticleListViewController* controller in self.pagesContainer.viewControllers)
    {
        if(controller)
        {
            [controller refreshData:today];
        }
    }
}

@end
