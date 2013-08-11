//
//  MultiPageViewController.h
//  HappyLife
//
//  Created by Ramonqlee on 8/8/13.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class DAPagesContainer;
@interface MultiPageViewController : BaseViewController

@property (assign, nonatomic) DAPagesContainer *pagesContainer;
@property(nonatomic,assign)CGRect rect;

-(id)initWithFrame:(CGRect)rc;

@end
