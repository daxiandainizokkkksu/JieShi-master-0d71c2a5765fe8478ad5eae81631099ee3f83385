//
//  ASNavigationController.h
//  YDSHClient
//
//  Created by amy.fu on 15/3/25.
//  Copyright (c) 2015年 amy.fu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASNavigationController : UINavigationController

@end

UIButton *createNaviButton(NSString *name, NSString *bkImageN, NSString *bkImageP, id target, SEL action, int flag);
void setNavigationButton(UINavigationItem *navigationItem, UIButton *button, BOOL left);
UIView *createTitleView(NSString *name);