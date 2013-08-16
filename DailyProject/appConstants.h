//
//  appConstants.h
//  DailyProject
//
//  Created by Ramonqlee on 8/11/13.
//  Copyright (c) 2013 iDreems. All rights reserved.
//

#ifndef DailyProject_appConstants_h
#define DailyProject_appConstants_h


#define __RELEASE__//发布时打开
//#define __PUSH_ON__TEST_MODE__//testmode

#ifdef __RELEASE__
#define NSLog(...) {}
#define DPRAPR_PUSH//push广告开关

#endif//__RELEASE__


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


#define kDefaultMobisageId @"e270159b22cc4c98a64e4402db48e96d"
#define kMobisageRecommendTableViewCount 14

#define kAdDisplayCount 10//没启动软件多少次，显示闪屏广告
#endif
