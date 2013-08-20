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
@property(nonatomic,assign)NSDate *viewDate;
@property(nonatomic,retain)NSArray* dbNameList;

-(id)initWithFrame:(CGRect)rc;
-(void)refreshData;
-(NSArray*)dictItems:(NSArray*)dict;
@end
