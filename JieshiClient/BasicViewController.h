//
//  BasicViewController.h
//  YDSHClient
//
//  Created by amy.fu on 15/3/25.
//  Copyright (c) 2015年 amy.fu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RESideMenu/RESideMenu.h>
#import "UIColor+ASColor.h"
#import "QDataModel.h"
#import "ASRequestHUD.h"
#import "ASUserDefaults.h"
#import "ASUtils.h"
#import "ASNavigationController.h"
#import "UIView+DEFrameAdditions.h"

@interface BasicViewController : UIViewController

- (NSString *)titleView;
- (void)onBack:(id)sender;

@end
