//
//  RMAppDelegate.h
//  DailyProject
//
//  Created by Ramonqlee on 8/11/13.
//  Copyright (c) 2013 iDreems. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SharedDelegate (RMAppDelegate*)[[UIApplication sharedApplication]delegate]

@interface RMAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

-(BOOL)scheduleNotificationWhenQuit;
-(void)setQuitNotification:(BOOL)enable;
@end
