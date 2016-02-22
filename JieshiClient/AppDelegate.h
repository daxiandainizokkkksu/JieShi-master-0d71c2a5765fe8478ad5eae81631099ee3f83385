//
//  AppDelegate.h
//  JieshiClient
//
//  Created by amy.fu on 15/10/19.
//  Copyright (c) 2015年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate*)appDelegate;
- (void)setSideMenuViewController;
- (void)logout;

@end

