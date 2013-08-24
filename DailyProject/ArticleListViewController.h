//
//  ArticleListViewController.h
//  HappyLife
//
//  Created by Ramonqlee on 8/8/13.
//
//

#import "BaseViewController.h"
#import "RMArticlesView.h"

@protocol ArticleListViewDelegate<NSObject>

- (NSArray*)loadData:(NSString*)dbName withKeyWord:(NSString*)keywords withDate:(NSDate*)date;

@end

@interface ArticleListViewController : BaseViewController
@property(nonatomic,retain)NSDate* date;
@property(nonatomic,retain)NSString* title;
@property(nonatomic,retain)id<ArticleListViewDelegate> dataDelegate;
@property(nonatomic,retain)id<TableViewRefreshLoadMoreDelegate> tableViewRefreshLoadMoreDelegate;
@property(nonatomic,retain)id<TableViewClickDelegate> tableViewClickDelegate;

-(id)initWithRect:(CGRect)rc;
-(void)refreshData:(NSDate*)time;

-(void)setData:(NSArray*)data;
-(NSArray*)getData;
@end
