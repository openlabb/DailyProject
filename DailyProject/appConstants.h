//
//  appConstants.h
//  DailyProject
//
//  Created by Ramonqlee on 8/11/13.
//  Copyright (c) 2013 iDreems. All rights reserved.
//

#ifndef DailyProject_appConstants_h
#define DailyProject_appConstants_h


//close log
#define __RELEASE__
#ifdef __RELEASE__
#define NSLog(...) {}
#endif


#define kTitleFontSize 17.0f
#define kContentFontSize 16.0f
#define kUIFont4Content [UIFont fontWithName:@"Times New Roman" size:kContentFontSize]
#define kUIFont4Title [UIFont boldSystemFontOfSize:kTitleFontSize]

#define kTabHeight 49.0f
#define kTopTabHeight 33.0f
#define kNavigationBarHeight 44.0f
#define kTabbarHeight kTabHeight

#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height
#define fLocalStringNotFormat(key) NSLocalizedString(key, nil)


//gold macros
#define kDefaultGold 10//default gold
#define kGoldByClickingBanner 15
#define kGoldByClickingRecommendView 40

#endif
