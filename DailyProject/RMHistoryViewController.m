//
//  RMSecondViewController.m
//  DailyProject
//
//  Created by Ramonqlee on 8/11/13.
//  Copyright (c) 2013 iDreems. All rights reserved.
//

#import "RMHistoryViewController.h"
#import "resConstants.h"
#import "DCPathButton.h"
#import "CKCalendarView.h"
#import "CommonHelper.h"
#import "CMPopTipView.h"

@interface RMHistoryViewController ()<DCPathButtonDelegate,CKCalendarDelegate>
@property(nonatomic, retain) CKCalendarView *calendar;
@property(nonatomic, retain) NSDate *minimumDate;
@end

@implementation RMHistoryViewController
@synthesize calendar;
@synthesize minimumDate;
-(void)dealloc
{
    self.calendar = nil;
    self.minimumDate = nil;
    [super dealloc];
}
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
    
    [self addDateSelectionButton];
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)addDateSelectionButton
{
    CGRect rect = self.view.frame;
    const CGFloat BOUNDING_SIZE = 80;
    const CGFloat OFFSET_Y = 80;
    rect.origin.x = kDeviceWidth-BOUNDING_SIZE;
    rect.size.height = BOUNDING_SIZE;
    rect.size.width = BOUNDING_SIZE;
    rect.origin.y = OFFSET_Y;
    
    UIView* selectView = [[[UIView alloc]initWithFrame:rect]autorelease];
    [self.view addSubview:selectView];
    
    //添加标示
    NSString* tipped = [CommonHelper defaultsForString:kHistoryTipKey];
    if (!tipped || tipped.length==0)
    {
        NSString *contentMessage = @"点此穿越";;
		UIColor *backgroundColor = [UIColor whiteColor];
		UIColor *textColor = [UIColor blueColor];
		
		CMPopTipView *popTipView = [[CMPopTipView alloc] initWithMessage:contentMessage];
		popTipView.disableTapToDismiss = YES;
		if (backgroundColor && ![backgroundColor isEqual:[NSNull null]]) {
			popTipView.backgroundColor = backgroundColor;
		}
		if (textColor && ![textColor isEqual:[NSNull null]]) {
			popTipView.textColor = textColor;
		}
        
        popTipView.animation = arc4random() % 2;
		[popTipView presentPointingAtView:selectView inView:self.view animated:YES];
        
        // Delay execution of my block for 10 seconds.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [popTipView removeFromSuperview];
            [popTipView release];
            
            [CommonHelper saveDefaultsForString:kHistoryTipKey withValue:kHistoryTipKey];
        });
    }
    
    DCPathButton *dcPathButton = [[DCPathButton alloc]
                                  initDCPathButtonWithSubButtons:3
                                  totalRadius:30
                                  centerRadius:15
                                  subRadius:15
                                  centerImage:@"custom_center"
                                  centerBackground:nil
                                  subImages:^(DCPathButton *dc){
                                      [dc subButtonImage:@"custom_5" withTag:0];
                                      [dc subButtonImage:@"custom_3" withTag:1];
                                      [dc subButtonImage:@"custom_2" withTag:2];
                                  }
                                  subImageBackground:nil
                                  inLocationX:0 locationY:0 toParentView:selectView];
    dcPathButton.delegate = self;
    [dcPathButton setExpanded:NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark util methods
-(void)setDate:(NSDate*)date
{
    [self refreshData:date];
}
#pragma mark - DCPathButton delegate

- (void)button_0_action{
    NSLog(@"Button Press Tag 0!!");
    NSDate *yesterday = [[NSDate  date] dateByAddingTimeInterval: -2*86400.0];
    [self setDate:yesterday];
}
- (void)button_1_action{
    NSLog(@"Button Press Tag 2!!");
    NSDate *yesterday = [[NSDate  date] dateByAddingTimeInterval: -86400.0];
    [self setDate:yesterday];
}

- (void)button_2_action{
    NSLog(@"Button Press Tag 1!!");
    CKCalendarView *cal = [[CKCalendarView alloc] initWithStartDay:startMonday];
    self.calendar = cal;
    calendar.delegate = self;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    self.minimumDate = [dateFormatter dateFromString:@"01/01/2013"];
    
    calendar.onlyShowCurrentMonth = NO;
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    
    calendar.frame = CGRectMake(10, 10, 300, 320);
    [self.view addSubview:calendar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange) name:NSCurrentLocaleDidChangeNotification object:nil];
    
}

- (void)localeDidChange {
    [self.calendar setLocale:[NSLocale currentLocale]];
}

- (BOOL)dateIsDisabled:(NSDate *)date {
    return [date compare:[NSDate date]]!=NSOrderedAscending;
}

#pragma mark -
#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    // TODO: play with the coloring if we want to...
    if ([self dateIsDisabled:date]) {
        dateItem.backgroundColor = [UIColor grayColor];
        dateItem.textColor = [UIColor whiteColor];
    }
}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    return ![self dateIsDisabled:date];
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    //    self.dateLabel.text = [self.dateFormatter stringFromDate:date];
    [self.calendar removeFromSuperview];
    [self setDate:date];
}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {
    if ([date laterDate:self.minimumDate] == date) {
        self.calendar.backgroundColor = [UIColor blueColor];
        return YES;
    } else {
        self.calendar.backgroundColor = [UIColor grayColor];
        return NO;
    }
}

- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame {
    NSLog(@"calendar layout: %@", NSStringFromCGRect(frame));
}

@end
