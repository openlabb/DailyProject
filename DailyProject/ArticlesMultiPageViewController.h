//
//  ArticlesMultiPageViewController.h
//  HappyLife
//
//  Created by Ramonqlee on 8/9/13.
//
//

#import "MultiPageViewController.h"

@interface ArticlesMultiPageViewController : MultiPageViewController
{
    NSDate *_viewDate;
}
@property(nonatomic,assign)NSDate *viewDate;

-(void)refreshData;
@end
