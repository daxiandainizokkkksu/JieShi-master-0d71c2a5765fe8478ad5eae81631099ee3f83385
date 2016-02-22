//
//  ViewController.m
//  JieshiClient
//
//  Created by amy.fu on 15/10/19.
//  Copyright (c) 2015年 dayu. All rights reserved.
//

#import "ViewController.h"
#import "JHttpManger.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *button = createNaviButton(nil, @"icon_navi_menu", nil, self, @selector(presentLeftMenuViewController:), 0);
    setNavigationButton(self.navigationItem, button, YES);
    
    self.view.backgroundColor = ColorBackground;

    UIButton * btn = [UIButton new];
    [btn setFrame:CGRectMake(20, 100, 300, 48)];
    btn.backgroundColor = [UIColor redColor];

    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"点我就崩溃" forState:UIControlStateNormal];
    
    [btn addTarget:nil action:@selector(testNSException) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [UIButton new];
    [btn setFrame:CGRectMake(20, 150, 300, 48)];
    btn.backgroundColor = [UIColor redColor];
    
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"测试场景1, 巡查人员登录" forState:UIControlStateNormal];
    
    [btn addTarget:nil action:@selector(test1Login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [UIButton new];
    [btn setFrame:CGRectMake(20, 200, 300, 48)];
    btn.backgroundColor = [UIColor redColor];
    
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"测试场景2, 巡查人员登录" forState:UIControlStateNormal];
    
    [btn addTarget:nil action:@selector(test2Login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [UIButton new];
    [btn setFrame:CGRectMake(20, 250, 300, 48)];
    btn.backgroundColor = [UIColor redColor];
    
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"用户名密码登录" forState:UIControlStateNormal];
    
    [btn addTarget:nil action:@selector(test3Login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
- (NSString*)titleView
{
    return @"测试页面";
}

#pragma mark - Test Action
- (void)testNSException
{
    NSLog(@"test nsexception");
    NSArray *arrTest = @[@"11",@"22"];
    NSLog(@"%@",arrTest[2]);
}

- (void)test1Login
{
    [[JHttpManger sharedHttpManager] GET:CheckDevice parameters:@{@"deviceId": @"11111111"} success:^(id responseObject) {
        if (responseObject)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"测试场景1, 巡查人员登录"
                                                                message:@"接口正确"
                                                               delegate:self
                                                      cancelButtonTitle:@"确认"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
    } fail:^(NSError *error){
        NSLog(@"test failed");
    }];
}

- (void)test2Login
{
    [[JHttpManger sharedHttpManager] GET:@"/jieshi/apiAuth/checkDevice" parameters:@{@"deviceId": @"11111110"} success:^(id responseObject) {
        if (responseObject)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"测试场景2, 巡查人员登录"
                                                                message:@"接口正确"
                                                               delegate:self
                                                      cancelButtonTitle:@"确认"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
    } fail:^(NSError *error){
        if (NSURLErrorBadServerResponse == error.code)
        {
            /*设备不存在*/
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"测试场景2, 巡查人员登录"
                                                                message:@"设备不存在"
                                                               delegate:self
                                                      cancelButtonTitle:@"确认"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
    }];
}

- (void)test3Login
{
    [[JHttpManger sharedHttpManager] POST:Login parameters:@{@"loginType" : @"username",
                                                             @"username" : @"13735516767",
                                                             @"password" : @"111111",
                                                             @"deviceId" : @"",
                                                             @"_rememberMe" : @""} success:^(id responseObject) {
        if (responseObject)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"测试场景2, 巡查人员登录"
                                                                message:@"用户名密码登陆成功"
                                                               delegate:self
                                                      cancelButtonTitle:@"确认"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
    } fail:^(NSError *error){
        NSLog(@"test failed , code %ld", error.code);
    }];
}

@end
