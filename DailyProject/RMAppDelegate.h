//
//  RMAppDelegate.h
//  DailyProject
//
//  Created by Ramonqlee on 8/11/13.
//  Copyright (c) 2013 iDreems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "coinView.h"

#define SharedDelegate (RMAppDelegate*)[[UIApplication sharedApplication]delegate]

@interface RMAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate,coinViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) coinView *coinview;

-(BOOL)scheduleNotificationWhenQuit;
-(void)setQuitNotification:(BOOL)enable;
@end
