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
@interface MultiPageViewController ()

@end

@implementation MultiPageViewController
-(void)dealloc
{
    self.pagesContainer = nil;
    [super dealloc];
}
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
    self.pagesContainer = [[DAPagesContainer alloc] init];
    self.pagesContainer.topBarBackgroundColor = TintColor;
    
    [self.pagesContainer willMoveToParentViewController:self];
    self.pagesContainer.view.frame = self.view.bounds;
    self.pagesContainer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.pagesContainer.view];
    [self.pagesContainer didMoveToParentViewController:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
