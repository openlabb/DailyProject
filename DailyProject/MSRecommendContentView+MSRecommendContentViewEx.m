//
//  MSRecommendContentView+MSRecommendContentViewEx.m
//  HappyLife
//
//  Created by Ramonqlee on 8/9/13.
//
//

#import "MSRecommendContentView+MSRecommendContentViewEx.h"
#import <UIKit/UIKit.h>
#import "AdsConfig.h"

@implementation MSRecommendContentView (MSRecommendContentViewEx)
-(void)hookTableView
{
    NSLog(@"hookTableView");
    for(UIView* view in [self subviews])
    {
        NSLog(@"%@",view);
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [view addGestureRecognizer:singleTap];
        singleTap.delegate = self;
        singleTap.cancelsTouchesInView = NO;
        [singleTap release];
    }
}
-(void)handleSingleTap:(UIView*)view
{
    [[NSNotificationCenter defaultCenter]postNotificationName:kClickRecommendViewEvent object:self];
    NSLog(@"handleSingleTap");
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
