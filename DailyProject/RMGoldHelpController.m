//
//  RMGoldHelpController.m
//  DailyProject
//
//  Created by Ramonqlee on 8/30/13.
//  Copyright (c) 2013 iDreems. All rights reserved.
//

#import "RMGoldHelpController.h"

@interface RMGoldHelpController ()

@end

@implementation RMGoldHelpController

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
    
    [self showBanner:NSLocalizedString(kConsumeGoldDetail, nil)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
