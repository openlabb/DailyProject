#ifndef DailyProject_appConstants_h
#define DailyProject_appConstants_h

#warning 发布时打开，并且确认drappr为非测试模式,并更新info中的weixin appid
//#define __RELEASE__
#ifdef __RELEASE__
#define DPRAPR_PUSH//push广告开关
//#define __PUSH_ON__TEST_MODE__//testmode
#define NSLog(...) {}
#endif//__RELEASE__

#warning 发布记得修改为相应的id
//#define Makeup//美容秘笈
//#define HealthSecretsForGirls//美女保健小贴士
//#define MHealth
//#define Foods
//#define LosingWeight
//#define careerGuide//职场秘笈
//#define RaisingKids //育儿指南
//#define TodayinHistory//史上今日
#define MakeToast//场面话之祝酒词
//#define TraditionalChineseMedicine //中医小窍门
//#define SpouseTalks//夫妻密语
//#define Humer//搞笑集锦
//#define EnglishPrefix//英语前缀
//#define EnglishSuffix//英语词根

#ifdef LosingWeight //ads to be replaced
#define kFlurryID @"255WD5F3T3WD385YSH5C"
#elif defined careerGuide
#define kFlurryID @"SPP44Z2HJXGR4ZXWNRYF"

#elif defined RaisingKids
#define kFlurryID @"KN8WBCH24R3V3PFVSSY2"

#elif defined TodayinHistory
//flurry
#define kFlurryID @"VD57WGD28683BPMSQ9X9"
#define UMENG_APPKEY @"52192ce856240b74bb051e0d"

#elif defined Makeup
//flurry
#define kFlurryID @"ZVSNS9NXX922ZMYBV436"
#define UMENG_APPKEY @"4fa7d6b85270157298000020"
#define kWeixinAppId @"wx1732ccc0f4c8954d"

#elif defined MakeToast
#define kFlurryID @"D5WYXYC4R9C6273W7M9Q"
#define UMENG_APPKEY @"5217eb1356240b5ad302a785"
#define kWeixinAppId @"wx906a8a63865c9a7f"

#elif defined TraditionalChineseMedicine

#define kFlurryID @"C82CN6MQ328XV3BHX5TN"
#define UMENG_APPKEY @"52192c6256240b81bf00bf51"
#define kWeixinAppId @"wx4dd2eafc51284cd5"

#elif defined SpouseTalks

#define kFlurryID @"S32DNZTRR5WVPV8F2KM6"
#define UMENG_APPKEY @"5207827b56240b84d106f5ee"
#elif defined Humer
//flurry
#define kFlurryID @"TDGR5K49JJPSX4G7HZJ8"

#elif defined EnglishSuffix
//flurry
#define kFlurryID @"ZYPQPYTD683PDWZH47SS"

#elif defined EnglishPrefix
//flurry
#define kFlurryID @"RSJY3SX8QV95QQM5GJ5Y"
//#else//other cases,from today in history
////flurry
//#define kFlurryID @"VD57WGD28683BPMSQ9X9"

#endif



#define kDefaultEmailRecipients @"feedback4iosapp@gmail.com"
//single file
#define kDataFile @"data.sql"
#define singleDataFile [[NSFileManager defaultManager]fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle]resourcePath],kDataFile]]

//db design 
#define FAVORITE_DB_NAME    @"favorite.sqlite"
#define kDBTableName    @"Content"
#define kDBTitle         @"Title"
#define kDBLowercaseTitle         @"title"
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
#define kEarnGoldTipBySNSShare 5


#define kArtistId 463201091// @"iDreems",
#define kItunesSearchTerm @"idreems.com"
#define kFavoriteDBChangedEvent @"kFavoriteDBChangedEvent"
#define kHideFavoriteFlag -1
#define kDaysOfYear 365

#define kDefaultMobisageId @"e270159b22cc4c98a64e4402db48e96d"
#define kMobisageRecommendTableViewCount 14
#define kDefaultYoumiAppId @"6b875a1db75ff9e5"
#define kDefaultYouSecret @"e6983e250159ac64"

#define kAdDisplayCount 10//没启动软件多少次，显示闪屏广告


//#define kDefaultResouceUrl @"http://www.idreems.com/openapi/collect_api.php?type=image"//makeup

//#define kDefaultResouceUrl @"http://www.idreems.com/openapi/yulu.php?type=yulu"//maketoast

#define kAdsDelay 2
#define kTodayinHistory @"史上今日"

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

#define kFlurrySharedChannel @"kFlurrySharedChannel"
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
#define kDecrementGoldEvent @"kDecrementGoldEvent"
#define kClickRecommendViewEvent @"kClickingRecommendViewEvent"
#define kClickYoumiWallEvent @"kClickYoumiWallEvent"
#define kClickBannerEvent @"kClickingBannerEvent"
#define kClickArticle @"kClickArticle"
#define kPopGoldEarningUI @"kPopGoldEarningUI"
#define kGoldAmount @"kGoldAmount"
#define kEarnGoldAmount @"kEarnGoldAmount"


#define kSocialEvent @"kSocialEvent"
#define kOpenCommentEvent @"kOpenCommentEvent"
#define kOpenLikeEvent @"kOpenLikeEvent"
#define kOpenFavoriteEvent @"kOpenFavoriteEvent"

#define kOpenFeedbackEvent @"kOpenFeedbackEvent"
#define kSetQuitNotificationEvent @"kSetQuitNotificationEvent"
#define kOpenRecommendAppListEvent @"kOpenRecommendAppListEvent"
#define kOpenEarnGoldListInSettingEvent @"kOpenEarnGoldListInSettingEvent"
#define kOpenRateInSettingEvent @"kOpenRateInSettingEvent"

#define kDeviceTokenForStat @"token"
#define kDeviceToken @"kDeviceToken"
#define kDidReceiveRemoteNotification @"kDidReceiveRemoteNotification"


//weixin
#define kFlurryConfirmOpenWeixinInAppstore @"kConfirmOpenWeixinInAppstore"
#define kFlurryCancelOpenWeixinInAppstore @"kCancelOpenWeixinInAppstore"
#define kShareByWeixin @"kShareByWeixin"
#define kShareByShareKit @"kShareByShareKit"
#define kSharePlatform @"kSharePlatform"

#define kCountPerSection 3
#ifndef kMobiSageIDOther_iPhone
#define kMobiSageIDOther_iPhone kMobiSageID_iPhone
#endif

#define kCoinsEffectDelay 11.0//6s

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define kHistoryTipKey @"kHistoryTipKey"

#define kOneMillionBytes 1024*1024
#define  kMaxMemoryCapacity 4*kOneMillionBytes
#define  kMaxDiskCapacity 32*kMaxMemoryCapacity

//hosted on developer@baidu
#define kStatUrl @"http://1.checknewversion.duapp.com/stat.php"
#define kAdsJsonUrl @"http://1.checknewversion.duapp.com/getadsconfig.php"//@"http://www.idreems.com/adsconfig/getadsconfig.php"
#endif

