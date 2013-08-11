//
//  RMAppDelegate.m
//  DailyProject
//
//  Created by Ramonqlee on 8/11/13.
//  Copyright (c) 2013 iDreems. All rights reserved.
//

#import "RMAppDelegate.h"

#import "RMFavoriteViewController.h"
#import "ArticlesMultiPageViewController.h"
#import "RMHistoryViewController.h"
#import "CommonHelper.h"
#import "SettingsViewController.h"
#import "resConstants.h"
#import "UMSocial.h"


@interface RMAppDelegate()
{
    BOOL      _EnterBylocalNotification;
}
@end

@implementation RMAppDelegate

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initLaunch];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    CGRect rc = [[UIScreen mainScreen]applicationFrame];
    
    // Override point for customization after application launch.
    UIViewController *favoriteViewController, *historyViewController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        favoriteViewController = [[[RMFavoriteViewController alloc] initWithNibName:@"RMFavoriteViewController_iPhone" bundle:nil] autorelease];
        historyViewController = [[[RMHistoryViewController alloc] initWithNibName:@"RMHistoryViewController_iPhone" bundle:nil] autorelease];
    } else {
        favoriteViewController = [[[RMFavoriteViewController alloc] initWithNibName:@"RMFavoriteViewController_iPad" bundle:nil] autorelease];
        historyViewController = [[[RMHistoryViewController alloc] initWithNibName:@"RMHistoryViewController_iPad" bundle:nil] autorelease];
    }
    UIViewController* dailyArticlesController = [[[ArticlesMultiPageViewController alloc]initWithFrame:rc]autorelease];
    
    UIViewController* tmp = [[[SettingsViewController alloc]init]autorelease];
    UINavigationController* setting = [[[UINavigationController alloc]initWithRootViewController:tmp]autorelease];
    
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = @[dailyArticlesController,historyViewController, favoriteViewController,setting];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    _EnterBylocalNotification = NO;
    NSLog(@"applicationDidEnterBackground");
    
    if ([self scheduleNotificationWhenQuit]) {
        
        const NSTimeInterval kDelay = 0;//1;
        NSString* popContent = NSLocalizedString(appFriendlyTip,"");
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [self scheduleLocalNotification:popContent delayTimeInterval:kDelay];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/
#pragma  mark init launch methods
-(void)initLaunch
{
    [UMSocialData setAppKey:UMENG_APPKEY];
    //init launch task
    if([CommonHelper initLaunch])
    {
        [CommonHelper setGold:kDefaultGold];
        [CommonHelper setNotInitLaunch];
        
        //enable quit notification
        [self setQuitNotification:YES];
    }
}

#pragma mark  quit switch
#define kQuitNotificationKey @"kQuitNotificationKey"
-(BOOL)scheduleNotificationWhenQuit
{
    NSUserDefaults* defaultSetting = [NSUserDefaults standardUserDefaults];
    return [defaultSetting boolForKey:kQuitNotificationKey];
}
-(void)setQuitNotification:(BOOL)enable
{
    NSUserDefaults* defaultSetting = [NSUserDefaults standardUserDefaults];
    [defaultSetting setBool:enable forKey:kQuitNotificationKey];
    [defaultSetting synchronize];
}

#pragma mark schedule notification

-(void)scheduleLocalNotification:(NSString*)alertBody
{
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {
        NSDate *now=[NSDate date];
#define kOneDayInSeconds 24*60*60
        notification.fireDate=[now dateByAddingTimeInterval:kOneDayInSeconds];
        NSLog(@"alertDate::%@",now);
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.applicationIconBadgeNumber = notification.applicationIconBadgeNumber+1;
        notification.alertBody=alertBody;
        [[UIApplication sharedApplication]   scheduleLocalNotification:notification];
    }
    [notification release];
}
-(void)scheduleLocalNotification:(NSString*)alertBody delayTimeInterval:(NSTimeInterval)delay
{
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {
        NSDate *now=[NSDate date];
        notification.fireDate=[now dateByAddingTimeInterval:delay];
        NSLog(@"alertDate::%@",now);
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.applicationIconBadgeNumber = notification.applicationIconBadgeNumber;
        notification.alertBody=alertBody;
        notification.hasAction = NO;
        [[UIApplication sharedApplication]   scheduleLocalNotification:notification];
    }
    [notification release];
}


@end
