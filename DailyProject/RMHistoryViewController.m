//
//  RMSecondViewController.m
//  DailyProject
//
//  Created by Ramonqlee on 8/11/13.
//  Copyright (c) 2013 iDreems. All rights reserved.
//

#import "RMHistoryViewController.h"
#import "resConstants.h"

@interface RMHistoryViewController ()

@end

@implementation RMHistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(Tab_Title_History, @"");
        self.tabBarItem.image = [UIImage imageNamed:kIconHistory];
    }
    return self;
}
-(id)initWithFrame:(CGRect)rc
{
    self = [super initWithFrame:rc];
    
    //    //for tab item
    self.title = NSLocalizedString(Tab_Title_History, @"");
    self.tabBarItem.image = [UIImage imageNamed:kIconHistory];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
