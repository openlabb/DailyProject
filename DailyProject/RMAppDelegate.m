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
#import "Flurry.h"
#import "iRate.h"
#import "iVersion.h"
#import "MobisageRecommendTableViewController.h"
#import "YouMiConfig.h"
#import "AdsConfiguration.h"
#import "HTTPHelper.h"
#import "YouMiWall.h"
#import "YouMiConfig.h"
#import "YouMiSpot.h"
#import "RMHistoryController.h"
#import "AdSageManager.h"
#import "YouMiPointsManager.h"
#import "DAAppsViewController.h"
#import "RMArticle.h"
#import "RMFavoriteViewController.h"
#import "WXApi.h"
#import "CPIAPStoreManager.h"

#ifdef DPRAPR_PUSH
#import "DMAPService.h"
#import "DMAPTools.h"
#endif//DPRAPR_PUSH

@interface RMAppDelegate()
{
    BOOL      _EnterBylocalNotification;
}
@property(nonatomic,retain)NSArray* names;
@end

@implementation RMAppDelegate
@synthesize coinview;
+ (void)initialize
{
    //configure iRate
    [iRate sharedInstance].daysUntilPrompt = 5;
    [iRate sharedInstance].usesUntilPrompt = 5;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    CGRect rc = [[UIScreen mainScreen]applicationFrame];
    
    rc.size.height -= (kTopTabHeight+kTabbarHeight);
    
    self.names = @[@"养生排行",@"女性保健",@"男性保健",@"中医育儿"];
    
#ifdef  TraditionalChineseMedicine
    self.names = @[@"养生排行",@"女性保健",@"男性保健",@"中医育儿"];
#elif defined Makeup
    self.names = @[@"美白小窍门",@"保湿技巧",@"饮食美容",@"笑话也美容"];
#elif defined MakeToast
    self.names = @[@"祝酒词",@"提酒词",@"敬酒词",@"拒酒词",@"劝酒词",@"挡酒词"];
#elif defined SpouseTalks
    self.names = @[@"情感攻略",@"生活健康",@"情感美文",@"隐私实录",@"夫妻笑话"];
#elif defined TodayinHistory
    self.names = @[kTodayinHistory,@"中外史记",@"历史故事"];
#endif
    [self initLaunch:launchOptions];
    
#ifndef TodayinHistory
    ArticlesMultiPageViewController* dailyArticlesController = [[[ArticlesMultiPageViewController alloc]initWithFrame:rc]autorelease];
#else
    //定义了kTodayinHistory
    ArticlesMultiPageViewController* dailyArticlesController = [[[RMHistoryController alloc]initWithFrame:rc]autorelease];
#endif
    dailyArticlesController.dbNameList = self.names;
    
    RMFavoriteViewController *favoriteViewController = [[[RMFavoriteViewController alloc] initWithFrame:rc] autorelease];
    
    DAAppsViewController *recommendController = [[[DAAppsViewController alloc] init]autorelease];
    recommendController.title = NSLocalizedString(Tab_Title_RecommmendApps, @"");
    recommendController.tabBarItem.image = [UIImage imageNamed:kICN_recommend_tab];
    [recommendController loadAppsWithSearchTerm:kItunesSearchTerm completionBlock:nil];

    UIViewController* tmp = [[[SettingsViewController alloc]init]autorelease];
    UINavigationController* setting = [[[UINavigationController alloc]initWithRootViewController:tmp]autorelease];
    
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    if(singleDataFile)
    {
        self.tabBarController.viewControllers = @[dailyArticlesController,favoriteViewController,recommendController,setting];
    }
    else
    {
        RMHistoryViewController* historyViewController = [[[RMHistoryViewController alloc] initWithFrame:rc] autorelease];
        historyViewController.dbNameList = self.names;
        self.tabBarController.viewControllers = @[dailyArticlesController,historyViewController, favoriteViewController,recommendController,setting];
    }
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    //start ad
    [self startAdsConfigReceive];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifyClick_Ad:) name:MobiSageAdView_Click_AD object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMobisageRecommendSingleTap:) name:kClickRecommendViewEvent object:nil];
    //push ad
    [self registerPushAds:launchOptions];
    
    //weixin
    [WXApi registerApp:kWeixinAppId];
    
    //start flurry session
    [Flurry startSession:kFlurryID];
#ifndef __RELEASE__
    [Flurry setDebugLogEnabled:YES];
#endif
    [self setSharedURLCache:kMaxMemoryCapacity diskCapacity:kMaxDiskCapacity];
    return YES;
}
-(void)setSharedURLCache:(NSUInteger)memoryCapacity diskCapacity:(NSUInteger)diskCapacity 
{
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:memoryCapacity diskCapacity:diskCapacity diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    [sharedCache release];
    sharedCache = nil;
}
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    //   token deviceId  publicKey
#ifdef DPRAPR_PUSH
    [DMAPService registerDeviceToken:deviceToken];
    
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:deviceToken,kDeviceToken, nil];
    [Flurry logEvent:kDeviceToken withParameters:dict];
#endif
    
    NSMutableDictionary* statDict = [NSMutableDictionary dictionaryWithDictionary:[CommonHelper getAdPostReqParams]];
    [statDict setObject:[deviceToken description] forKey:kDeviceTokenForStat];
    
    [self beginPostRequest:kStatUrl withDictionary:statDict];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"error:%@", [error description]);
    
}

-(void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    // Required
#ifdef DPRAPR_PUSH
    [DMAPService handleRemoteNotification:userInfo];
    
    [Flurry logEvent:kDidReceiveRemoteNotification withParameters:userInfo];
#endif
    NSInteger badgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber;
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = (badgeNumber-1);
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
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];    
    if(singleDataFile)
    {
        return;
    }
    //tommorow's tip
    NSString* dbName = [self.names objectAtIndex:0];
#ifdef TodayinHistory
    NSString* tipMessage = [RMHistoryController getTomorrowSummary:dbName withKeyWord:dbName];
#else
    NSString* tipMessage = [ArticlesMultiPageViewController getTomorrowSummary:dbName withKeyWord:dbName];
#endif
    if(tipMessage && tipMessage.length>0)
    {
        [self scheduleLocalNotification:tipMessage];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //init launch task
    if([CommonHelper initLaunch])
    {
        [CommonHelper setGold:kDefaultGold];
        [CommonHelper setNotInitLaunch];
        
        //enable quit notification
        [self setQuitNotification:YES];
    }
    else
    {
        [self showCoinsEffect];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[CPIAPStoreManager shareManager] removeStoreObserver];
}
- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [super dealloc];
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
-(void)initLaunch:(NSDictionary *)launchOptions
{
    //iap
    [[CPIAPStoreManager shareManager] registerStoreObserver];
    
    //set umeng key
    [UMSocialData setAppKey:UMENG_APPKEY];
    
    [YouMiPointsManager enableManually];
    // 启动积分墙
    [YouMiWall enable];
    // 注册消息，得知积分的变化， 详情看头文件 YouMiPointsManager.h
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pointsGotted:) name:kYouMiPointsManagerRecivedPointsNotification object:nil];

}
-(void)importFormerData
{
    if (![RMAppDelegate dataImported])
    {
        [RMAppDelegate setDataImport:YES];
        
        NSMutableArray *dataMutableArray = [[NSUserDefaults standardUserDefaults]mutableArrayValueForKey:kAppIdOnAppstore];
        
        RMArticle* article = [[RMArticle alloc]init];
        article.favoriteNumber = kHideFavoriteFlag;
        if (dataMutableArray && dataMutableArray.count>0) {
            for (NSDictionary* item in dataMutableArray) {
                article.title = [item valueForKey:@"date"];
                article.content = [item valueForKey:@"text"];
                article.summary = article.content;
                article.url = article.summary;
                
                [RMFavoriteViewController addToFavorite:article];
            }
            [article release];
        }
    }
}
#pragma mark import flag
#define kDataImported @"kDataImported"
+(BOOL)dataImported
{
    NSUserDefaults* defaultSetting = [NSUserDefaults standardUserDefaults];
    return [defaultSetting boolForKey:kDataImported];
}
+(void)setDataImport:(BOOL)imported
{
    NSUserDefaults* defaultSetting = [NSUserDefaults standardUserDefaults];
    [defaultSetting setBool:imported forKey:kDataImported];
    [defaultSetting synchronize];
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

#pragma mark ad click event handler
/**
 banner ad clicked,increment gold
 */
-(void)notifyClick_Ad:(NSNotification*)notification
{
    [CommonHelper setGold:[CommonHelper gold]+kGoldByClickingBanner];
    NSDictionary* dict = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kGoldByClickingBanner] forKey:kClickBannerEvent];
    [Flurry logEvent:kClickBannerEvent withParameters:dict];
    
    NSLog(@"notify:%@,gold:%d",notification.name,[CommonHelper gold]);
}
-(void)handleMobisageRecommendSingleTap:(NSNotification*)notification
{
    if (notification && [notification.name isEqualToString:kClickRecommendViewEvent]) {
        [CommonHelper setGold:[CommonHelper gold]+kGoldByClickingRecommendView];
        [self showCoinsEffect];
        NSDictionary* dict = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kGoldByClickingRecommendView] forKey:kClickRecommendViewEvent];
        [Flurry logEvent:kClickRecommendViewEvent withParameters:dict];
    }
}
#pragma mark ads utils

-(void)getResult:(NSNotification*)notification
{
    if (notification && notification.object && ![notification.object isKindOfClass:[NSError class]]) {
        if (!notification.userInfo || notification.userInfo.count==0) {
            return;
        }
        
        //parse ads and send notification
        AdsConfiguration* adsConfig = [AdsConfiguration sharedInstance];
        if(![adsConfig initWithJson:[notification.userInfo objectForKey:kPostResponseData]])
        {
            return;
        }
        
        //youmi config
        [YouMiConfig setShouldGetLocation:NO];
        [YouMiConfig launchWithAppID:[[AdsConfiguration sharedInstance]youmiAppId] appSecret:[[AdsConfiguration sharedInstance]youmiSecret]];
        BOOL rewarded = YES;
        [YouMiSpot requestSpotADs:rewarded];
        
        //adsage
        [[AdSageManager getInstance]setAdSageKey:[[AdsConfiguration sharedInstance]mobisageId]];
        
        [self performSelectorInBackground:@selector(importFormerData) withObject:nil];
        //notify
        [[NSNotificationCenter defaultCenter]postNotificationName:kAdsConfigUpdated object:nil];
        
        [[NSNotificationCenter defaultCenter]removeObserver:self name:kPostNotification object:nil];
    }
    
}
- (void)startAdsConfigReceive
// Starts a connection to download the current URL.
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getResult:) name:kPostNotification object:nil];
    //new method to get ads
    [self beginPostRequest:kAdsJsonUrl withDictionary:[CommonHelper getAdPostReqParams]];
}
#pragma mark HTTP util methods
-(void)beginRequest:(FileModel *)fileInfo isBeginDown:(BOOL)isBeginDown setAllowResumeForFileDownloads:(BOOL)allow
{
    [[HTTPHelper sharedInstance]beginRequest:fileInfo isBeginDown:isBeginDown setAllowResumeForFileDownloads:allow];
}
-(void)beginRequest:(FileModel *)fileInfo isBeginDown:(BOOL)isBeginDown
{
    [[HTTPHelper sharedInstance]beginRequest:fileInfo isBeginDown:isBeginDown];
}

-(void)beginPostRequest:(NSString*)url withDictionary:(NSDictionary*)postData
{
    [[HTTPHelper sharedInstance]beginPostRequest:url withDictionary:postData];
}

#pragma mark push ads
-(void)registerPushAds:(NSDictionary *)launchOptions
{
#ifdef DPRAPR_PUSH
    // 开启开发者测试模式
#ifdef __PUSH_ON__TEST_MODE__
    [DMAPTools developerTestMode];
#endif//__PUSH_ON__TEST_MODE__
    
    // Required
    [DMAPService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    // Required
    [DMAPService setupWithOption:launchOptions];
#endif
}
+(void)showAlertView:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString*)cancelTitle
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelTitle otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(void)showCoinsEffectInner:(NSNumber*)number
{
    if (!number) {
        return;
    }
    coinview = [[coinView alloc]initWithFrame:[self.window bounds] withNum:number.integerValue];
    coinview.coindelegate = self;
    [self.window addSubview:coinview];
    
    [CommonHelper earnGold:0];//reset
}
-(void)showCoinsEffect
{
    if([[AdsConfiguration sharedInstance]getCount]>0)
    {
        NSInteger earnedGold =[CommonHelper latestGoldEarned];
        if (earnedGold>0) {
            //delay
            [self performSelector:@selector(showCoinsEffectInner:) withObject:[NSNumber numberWithInt:earnedGold] afterDelay:kCoinsEffectDelay];
        }
    }
}
- (void)pointsGotted:(NSNotification *)notification {
    NSDictionary *dict = [notification userInfo];
    NSNumber *freshPoints = [dict objectForKey:kYouMiPointsManagerFreshPointsKey];
    
    // 这里的积分不应该拿来使用, 只是用于告诉一下用户, 可以通过 [YouMiPointsManager spendPoints:]来使用积分
    [self showCoinsEffect];
    
    [CommonHelper setGold:[CommonHelper gold]+freshPoints.integerValue];
    
    dict = [NSDictionary dictionaryWithObject:freshPoints forKey:kClickYoumiWallEvent];
    [Flurry logEvent:kClickYoumiWallEvent withParameters:dict];
    
    // 如果使用手动积分管理可以通过下面这种方法获得每份积分的信息。
    //    NSArray *pointInfos = dict[kYouMiPointsManagerPointInfosKey];
    //    for (NSDictionary *aPointInfo in pointInfos) {
    //        // aPointInfo 是每份积分的信息，包括积分数，userID，下载的APP的名字
    //        NSLog(@"积分数：%@", aPointInfo[kYouMiPointsManagerPointAmountKey]);
    //        NSLog(@"userID：%@", aPointInfo[kYouMiPointsManagerPointUserIDKey]);
    //        NSLog(@"产品名字：%@", aPointInfo[kYouMiPointsManagerPointProductNameKey]);
    //
    //        // TODO 按需要处理
    //    }
}

-(void)coinAnimationFinished
{
    [coinview removeFromSuperview];
    coinview = nil;
}

#pragma weixin callback 
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    // 如果你要自己实现微信的回调，可以把相应的回调对象传入到上面的`wxApiDelegate`。如果你除了使用我们sdk之外还要处理另外的url，你可以把`handleOpenURL:wxApiDelegate:`的实现复制到你的代码里面，再添加你要处理的url。
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

@end
