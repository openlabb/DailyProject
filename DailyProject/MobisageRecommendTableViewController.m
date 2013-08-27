//
//  ViewController.m
//  MSTableRecommendDemo
//
//  Created by stick on 12-12-4.
//  Copyright (c) 2012年 stick. All rights reserved.
//

#import "MobisageRecommendTableViewController.h"
#import "AdsConfiguration.h"
#import "resConstants.h"
#import "appConstants.h"

#define MobiSage_Table_Recommend_Tag 1001  //表格式荐计划视图的tag值




@interface MobisageRecommendTableViewController ()

@end

@implementation MobisageRecommendTableViewController

@synthesize tableView=_tableView;
@synthesize recommendView;


-(id)init
{
    self = [super init];
    
    //for tab item
    self.title = NSLocalizedString(Tab_Title_RecommmendApps, @"");
    self.tabBarItem.image = [UIImage imageNamed:kICN_recommend_tab];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[MobiSageManager getInstance] setPublisherID:[[AdsConfiguration sharedInstance]mobisageId]];
    
    //表格式荐计划
    self.recommendView = [[MSRecommendContentView alloc] initWithdelegate:self width:300.0f adCount:kMobisageRecommendTableViewCount];
    [self.recommendView release];
    
    self.recommendView.tag = MobiSage_Table_Recommend_Tag;
    //hook tableview in this view
    if ([self.recommendView respondsToSelector:@selector(hookTableView)]) {
        [self.recommendView performSelector:@selector(hookTableView)];
    }
    
    //表格控件
    CGSize adSize = [self showBanners];
    CGRect rect = self.view.bounds;
    rect.origin.y += adSize.height;
    
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView release];
    
}



- (void)viewDidUnload {
    
    
    self.tableView = nil;
    self.recommendView = nil;
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableViewDataSource 委托函数
#pragma mark


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (![cell isKindOfClass:[UITableViewCell class]]) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    // Configure the cell...
    
    
    cell.textLabel.text = nil;
    UIView *subView = [cell.contentView viewWithTag:MobiSage_Table_Recommend_Tag];
    if (subView != self.recommendView) {
        
        [cell.contentView addSubview:self.recommendView];
    }
    
    
    return cell;
}





#pragma mark - UITableViewDelegate 委托函数
#pragma mark


- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //    if (1 == indexPath.section)
    {
        
//        if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom) {
//            
//            return 157 * kMobisageRecommendTableViewCount *(700.0/640.0);
//            
//        }else {
        
            return 157 * kMobisageRecommendTableViewCount *(300.0/640.0);
//        }
    }
    
    return 44;
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"didSelectRowAtIndexPath");
    
}



#pragma mark - MobiSageRecommendDelegate 委托函数
#pragma mark

- (UIViewController *)viewControllerForPresentingModalView {
    
    return self;
}





@end
