//
//  RMSelectorObj.h
//  InfiniteTabProject
//
//  Created by Ramonqlee on 8/4/13.
//  Copyright (c) 2013 iDreems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMSelectorObj : NSObject
{
    id obj;
    SEL selector;
}
@property(nonatomic,retain)id obj;
@property(nonatomic,assign)SEL selector;
@end
