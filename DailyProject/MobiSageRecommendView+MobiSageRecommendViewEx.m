//
//  MobiSageRecommendView+MobiSageRecommendViewEx.m
//  HappyLife
//
//  Created by Ramonqlee on 8/9/13.
//
//

#import "MobiSageRecommendView+MobiSageRecommendViewEx.h"

@implementation MobiSageRecommendView (MobiSageRecommendViewEx)
-(void)hookTableView
{
    NSLog(@"hookTableView");
    
//    UITapGestureRecognizer *tap=[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)]autorelease];
//    tap.numberOfTapsRequired=1;
//    tap.numberOfTouchesRequired=1;
//    [self addGestureRecognizer:tap];
}

-(void)handleSingleTap
{
    [[NSNotificationCenter defaultCenter]postNotificationName:kSingleTapRecommendPopupViewNotification object:self];
    NSLog(@"handleSingleTap");
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
