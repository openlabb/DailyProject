//
//  appConstants.h
//  DailyProject
//
//  Created by Ramonqlee on 8/11/13.
//  Copyright (c) 2013 iDreems. All rights reserved.
//

#ifndef DailyProject_appConstants_h
#define DailyProject_appConstants_h

//#define __RELEASE__//发布时打开
//#define __PUSH_ON__TEST_MODE__//testmode

#ifdef __RELEASE__

#define DPRAPR_PUSH//push广告开关

#endif//__RELEASE__

//#define NSLog(...) {}

#define kDefaultEmailRecipients @"feedback4iosapp@gmail.com"
//single file
#define kDataFile @"data.sql"
#define singleDataFile [[NSFileManager defaultManager]fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle]resourcePath],kDataFile]]

//db design 
#define FAVORITE_DB_NAME    @"favorite.sqlite"
#define kDBTableName    @"Content"
#define kDBTitle         @"Title"
#define kDBSummary       @"Summary"
#define kDBContent       @"Content"
#define kDBPageUrl       @"PageUrl"
#define kDBFavoriteTime  @"FavTime"

#define kIPhoneFontSize  20//pt
#define kIPadFontSizeEx  28//pt
#define kItemPerSection 2
//#define kHuakangFontName @"DFPShaoNvW5"

#define kAdd2Favorite @"kAdd2Favorite"

//icon for tabbar
#define kIconHistory @"ICN_history"
#define kIconHomePage @"ICN_homepage"
#define kIconFavorite @"ICN_badge-favorite"
#define kIconSetting @"ICN_setting"
#define kICN_recommend_tab @"ICN_recommend_tab"

#define kPostNotification @"kPostNotification"//notification for post
#define kPostResponseData @"kPostResponseData"

#define kTitleFontSize 17.0f
#define kContentFontSize 16.0f
#define kUIFont4Content [UIFont fontWithName:@"Times New Roman" size:kContentFontSize]
#define kUIFont4Title [UIFont boldSystemFontOfSize:kTitleFontSize]

#define kTabHeight 44.0f
#define kTopTabHeight 44.0f//33.0f
#define kNavigationBarHeight 44.0f
#define kTabbarHeight kTabHeight

#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height
#define fLocalStringNotFormat(key) NSLocalizedString(key, nil)


//gold macros
#define kDefaultGold 10//default gold
#define kGoldByClickingBanner 15
#define kGoldByClickingRecommendView 40


#define UMENG_APPKEY @"5207827b56240b84d106f5ee"
#define kArtistId 463201091// @"iDreems",
#define kItunesSearchTerm @"idreems.com"
#define kFavoriteDBChangedEvent @"kFavoriteDBChangedEvent"
#define kHideFavoriteFlag -1
#define kDaysOfYear 365

#define kFlurryAppSavingKey @"kFlurryAppSavingKey"
#define kDefaultFlurryAppKey @"D5WYXYC4R9C6273W7M9Q"
#define kDefaultMobisageId @"e270159b22cc4c98a64e4402db48e96d"
#define kMobisageRecommendTableViewCount 14
#define kDefaultYoumiAppId @"6b875a1db75ff9e5"
#define kDefaultYouSecret @"e6983e250159ac64"

#define kAdDisplayCount 10//没启动软件多少次，显示闪屏广告

//#define HealthSecretsForGirls//美女保健小贴士
//#define MHealth
//#define Foods
//#define LosingWeight
//#define careerGuide//职场秘笈
//#define RaisingKids //育儿指南
//#define TodayinHistory//史上今日
//#define Makeup//美容秘笈
//#define MakeToast//场面话之祝酒词
//#define TraditionalChineseMedicine //中医小窍门
//#define SpouseTalks//夫妻密语
//#define Humer//搞笑集锦
//#define EnglishPrefix//英语前缀
//#define EnglishSuffix//英语词根


//#define kDefaultResouceUrl @"http://www.idreems.com/openapi/collect_api.php?type=image"//makeup

//#define kDefaultResouceUrl @"http://www.idreems.com/openapi/yulu.php?type=yulu"//maketoast

#define kAdsDelay 2

//in-app purchase
#ifndef kInAppPurchaseProductName
#define kInAppPurchaseProductName @"com.idreems.maketoast.inapp"
#endif

#define kAdsConfigUpdated @"kAdsConfigUpdated"

#define kNewContentScale 5
#define kMinNewContentCount 3

#define kWeiboMaxLength 140
#define kAdsSwitch @"AdsSwitch"
#define kPermanent @"Permanent"
#define kDateFormatter @"yyyy-MM-dd"

//for notification
#define kAdsUpdateDidFinishLoading @"AdsUpdateDidFinishLoading"
#define  kUpdateTableView @"UpdateTableView"

#define kOneDay (24*60*60)
#define kTrialDays  1

//flurry event
#define kFlurryRemoveTempConfirm @"kRemoveTempConfirm"
#define kFlurryRemoveTempCancel  @"kRemoveTempCancel"
#define kEnterMainViewList       @"kEnterMainViewList"
#define kFlurryOpenRemoveAdsList @"kOpenRemoveAdsList"

#define kFlurryDidSelectApp2RemoveAds @"kDidSelectApp2RemoveAds"
#define kFlurryRemoveAdsSuccessfully  @"kRemoveAdsSuccessfully"
#define kDidShowFeaturedAppNoCredit   @"kDidShowFeaturedAppNoCredit"
#define kFlurryNewChannel @"kNewChannel"

#define kShareByWeibo @"kShareByWeibo"
#define kShareByEmail @"kShareByEmail"

#define kEnterBylocalNotification @"kEnterBylocalNotification"
#define kDidShowFeaturedAppCredit @"kDidShowFeaturedAppCredit"

#define kFlurryDidSelectAppFromRecommend @"kFlurryDidSelectAppFromRecommend"
#define kFlurryDidSelectAppFromMainList  @"kFlurryDidSelectAppFromMainList"
#define kFlurryDidReviewContentFromMainList  @"kFlurryDidReviewContentFromMainList"
#define kLoadRecommendAdsWall @"kLoadRecommendAdsWall"
//favorite
#define kEnterNewFavorite @"kEnterNewFavorite"
#define kOpenExistFavorite @"kOpenExistFavorite"
#define kQiushiReviewed @"kQiushiReviewed"
#define kQiushiRefreshed @"kQiushiRefreshed"
#define kReviewCloseAdPlan @"kReviewCloseAdPlan"
#define kOpenYoumiWall @"openYoumiWall"
#define TrialPoints @"TrialPoints"
#define GetCoins @"GetCoins"

#define kGoldEvent @"kGoldEvent"
#define kClickRecommendViewEvent @"kClickingRecommendViewEvent"
#define kClickBannerEvent @"kClickingBannerEvent"
#define kClickArticle @"kClickArticle"
#define kPopGoldEarningUI @"kPopGoldEarningUI"

#define kDeviceToken @"kDeviceToken"
#define kDidReceiveRemoteNotification @"kDidReceiveRemoteNotification"


//weixin
#define kFlurryConfirmOpenWeixinInAppstore @"kConfirmOpenWeixinInAppstore"
#define kFlurryCancelOpenWeixinInAppstore @"kCancelOpenWeixinInAppstore"
#define kShareByWeixin @"kShareByWeixin"
#define kShareByShareKit @"kShareByShareKit"

#define kCountPerSection 3
#ifndef kMobiSageIDOther_iPhone
#define kMobiSageIDOther_iPhone kMobiSageID_iPhone
#endif

#endif

