//
//  AppDelegate.m
//  JieshiClient
//
//  Created by amy.fu on 15/10/19.
//  Copyright (c) 2015年 dayu. All rights reserved.
//

#import "AppDelegate.h"
#import <Bugly/CrashReporter.h>
#import <UMengAnalytics/MobClick.h>
#import "LoginViewController.h"
#import "DBInterface.h"
#import "ASNavigationController.h"
#import "MenuViewController.h"
#import "ViewController.h"
#import <UMFeedback.h>
#import <UMessage.h>

#define IOS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IOS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
@interface AppDelegate () <RESideMenuDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*bugly 初始化*/
#if DEBUG == 1
    [[CrashReporter sharedInstance] enableLog:YES];
#endif
    [[CrashReporter sharedInstance] setUserId:@"ronnie"];
    [[CrashReporter sharedInstance] installWithAppId:@"900010237"];
    /*友盟初始化*/
#if DEBUG == 1
    [MobClick setLogEnabled:YES];
#endif
    [MobClick startWithAppkey:@"562887b567e58e2b2d000ea6"];
    [UMFeedback setAppkey:@"562887b567e58e2b2d000ea6"];

    
    
    LoginViewController *viewController = [[LoginViewController alloc] init];
    viewController.isAnimated = YES;
    self.window.rootViewController = viewController;
    
    int dbRet = [[DBInterface sharedInstance] initDB];
    if (dbRet < 0) NSLog(@"!!!!!     initDB Error, code:%d", dbRet);
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage didReceiveRemoteNotification:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Methods

+ (AppDelegate*)appDelegate
{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

- (void)setSideMenuViewController
{
    ASNavigationController *navigationController = [[ASNavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    navigationController.navigationBar.barTintColor = ColorThemeBule;
    navigationController.navigationBar.translucent = NO;
    
    MenuViewController *leftMenuViewController = [[MenuViewController alloc] init];
    
    
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:navigationController
                                                                    leftMenuViewController:leftMenuViewController
                                                                   rightMenuViewController:nil];
    sideMenuViewController.backgroundImage = [UIImage imageNamed:@"bg_pic"];
    sideMenuViewController.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    sideMenuViewController.delegate = self;
    sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
    sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    sideMenuViewController.contentViewShadowOpacity = 0.6;
    sideMenuViewController.contentViewShadowRadius = 12;
    sideMenuViewController.contentViewShadowEnabled = YES;
    self.window.rootViewController = sideMenuViewController;
}

- (void)logout
{
    [self exitApplication];
}

- (void)exitApplication
{
    
    [UIView beginAnimations:@"exitApplication" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.window cache:NO];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    
    [UIView commitAnimations];
    
}

- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID compare:@"exitApplication"] == 0) {
        
        exit(0);
        
    }
}

@end
