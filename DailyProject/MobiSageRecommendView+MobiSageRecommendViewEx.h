//
//  MobiSageRecommendView+MobiSageRecommendViewEx.h
//  HappyLife
//
//  Created by Ramonqlee on 8/9/13.
//
//

#import "MobiSageSDK.h"
#define kSingleTapRecommendPopupViewNotification @"kSingleTapRecommendPopupViewNotification"

@interface MobiSageRecommendView (MobiSageRecommendViewEx)
-(void)hookTableView;
@end
