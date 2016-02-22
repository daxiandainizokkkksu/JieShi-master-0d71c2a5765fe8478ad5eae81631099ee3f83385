//
//  BasicViewController.m
//  YDSHClient
//
//  Created by amy.fu on 15/3/25.
//  Copyright (c) 2015年 amy.fu. All rights reserved.
//

#import "BasicViewController.h"

@interface BasicViewController ()

@end

@implementation BasicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *titleView = createTitleView([self titleView]);
    self.navigationItem.titleView = titleView;
    
    if (self.navigationController.viewControllers.count > 1)
    {
        UIButton *backButton = createNaviButton(nil, @"btn_back", nil, self, @selector(onBack:), 2);
        setNavigationButton(self.navigationItem, backButton, YES);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)titleView
{
    return nil;
}

#pragma mark - Action
- (void)onBack:(id)sender
{
    if ([[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:NSClassFromString(@"MenuViewController")]
        && self.navigationController.viewControllers.count < 3) {
        [self.navigationController popViewControllerAnimated:NO];
    }
    else
        [self.navigationController popViewControllerAnimated:YES];
}


@end
