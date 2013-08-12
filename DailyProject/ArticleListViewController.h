//
//  ArticleListViewController.h
//  HappyLife
//
//  Created by Ramonqlee on 8/8/13.
//
//

#import "BaseViewController.h"

@protocol ArticleListViewDelegate<NSObject>

- (NSArray*)loadData:(NSString*)dbName withKeyWord:(NSString*)keywords;

@end

@interface ArticleListViewController : BaseViewController
@property(nonatomic,retain)NSString* title;
@property(nonatomic,retain)id<ArticleListViewDelegate> dataDelegate;

-(void)refreshData;
@end
