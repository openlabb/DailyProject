//
//  ArticlesMultiPageViewController.h
//  HappyLife
//
//  Created by Ramonqlee on 8/9/13.
//
//

#import "MultiPageViewController.h"
#import "ArticleListViewController.h"

@interface ArticlesMultiPageViewController : MultiPageViewController<ArticleListViewDelegate>
{
    NSDate *_viewDate;
}
@property(nonatomic,retain)NSArray* dbNameList;

-(id)initWithFrame:(CGRect)rc;
-(void)refreshData:(NSDate*)date;
+(NSArray*)dictItems:(NSArray*)dict;

//获取明天的内容简介
+(NSString*)getTomorrowSummary:(NSString*)dbName withKeyWord:(NSString*)keywords;
@end
