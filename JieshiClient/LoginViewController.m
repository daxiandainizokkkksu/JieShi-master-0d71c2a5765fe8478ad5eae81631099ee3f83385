//
//  LoginViewController.m
//  YDSHClient
//
//  Created by amy.fu on 15/3/26.
//  Copyright (c) 2015年 amy.fu. All rights reserved.
//

#import <AdSupport/AdSupport.h>
#import "LoginViewController.h"
#import "ASUserDefaults.h"
#import "UIView+DEFrameAdditions.h"
#import "UIColor+ASColor.h"
#import "ASRequestHUD.h"
#import "ASUtils.h"
#import "JHttpManger.h"
#import "AppDelegate.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    UITextField *_userNameTextField;
    UITextField *_pwdTextField;
    UIButton *_btnRememberPwd;
    UIButton *_btnAutoLogin;
}

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UIView *loginView;

@end

@implementation LoginViewController

- (UIImageView*)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _bgImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_bgImageView];
    }
    return _bgImageView;
}

- (UIImageView*)logoView
{
    if (!_logoView) {
        _logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_login_logo"]];
        _logoView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.logoView.center = CGPointMake(self.view.center.x, self.view.center.y - 40);
        [self.view addSubview:_logoView];
    }
    
    return _logoView;
}

- (UIView*)loginView
{
    if (!_loginView) {
        
        CGFloat left = 40;
        CGFloat width = SCREEN_SIZE_WIDTH - 2*left;
        //初始坐标在底部
        _loginView = [[UIView alloc] initWithFrame:CGRectMake(left, self.view.deFrameBottom, width, 170)];
        _loginView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        [self.view addSubview:_loginView];
        
        UIImageView *leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_user"]];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 40)];
        [view addSubview:leftImageView];
        leftImageView.center = view.center;
        
        _userNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, width, 40)];
        _userNameTextField.delegate = self;
        _userNameTextField.textColor = [UIColor whiteColor];
        _userNameTextField.font = [UIFont systemFontOfSize:16];
        NSString *string = @"用户名";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleNone)}];
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor whiteColor]
                                 range:NSMakeRange(0, string.length)];
        _userNameTextField.attributedPlaceholder = attributedString;
        _userNameTextField.leftView = view;
        _userNameTextField.leftViewMode = UITextFieldViewModeAlways;
        _userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userNameTextField.backgroundColor = [UIColor clearColor];
        _userNameTextField.returnKeyType = UIReturnKeyNext;
        [_loginView addSubview:_userNameTextField];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _userNameTextField.deFrameBottom - .5f, _loginView.deFrameWidth, .5f)];
        lineView.backgroundColor = [UIColor whiteColor];
        [_loginView addSubview:lineView];
        
        leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_password"]];
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 40)];
        [view addSubview:leftImageView];
        leftImageView.center = view.center;
        
        _pwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_userNameTextField.frame), width, 40)];
        _pwdTextField.delegate = self;
        _pwdTextField.textColor = [UIColor whiteColor];
        _pwdTextField.font = [UIFont systemFontOfSize:16];
        string = @"密码";
        attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleNone)}];
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor whiteColor]
                                 range:NSMakeRange(0, string.length)];
        _pwdTextField.attributedPlaceholder = attributedString;
        _pwdTextField.leftView = view;
        _pwdTextField.leftViewMode = UITextFieldViewModeAlways;
        _pwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _pwdTextField.backgroundColor = [UIColor clearColor];
        _pwdTextField.returnKeyType = UIReturnKeyJoin;
        _pwdTextField.secureTextEntry = YES;
        [_loginView addSubview:_pwdTextField];
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _pwdTextField.deFrameBottom - .5f, _loginView.deFrameWidth, .5f)];
        lineView.backgroundColor = [UIColor whiteColor];
        [_loginView addSubview:lineView];
        
        _btnRememberPwd= [[UIButton alloc] initWithFrame:CGRectMake(0, _pwdTextField.deFrameBottom + 5, 80, 40)];
        [_btnRememberPwd setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateSelected];
        [_btnRememberPwd setImage:[UIImage imageNamed:@"icon_unselected"] forState:UIControlStateNormal];
        [_btnRememberPwd setTitle:@" 记住密码" forState:UIControlStateNormal];
        [_btnRememberPwd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnRememberPwd.titleLabel.font = [UIFont systemFontOfSize:13];
        _btnRememberPwd.backgroundColor = [UIColor clearColor];
        [_btnRememberPwd addTarget:self action:@selector(onRememberPwd:) forControlEvents:UIControlEventTouchUpInside];
        [_loginView addSubview:_btnRememberPwd];
        
        _btnAutoLogin = [[UIButton alloc] initWithFrame:CGRectMake(0, _pwdTextField.deFrameBottom + 5, 80, 40)];
        [_btnAutoLogin setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateSelected];
        [_btnAutoLogin setImage:[UIImage imageNamed:@"icon_unselected"] forState:UIControlStateNormal];
        [_btnAutoLogin setTitle:@" 自动登录" forState:UIControlStateNormal];
        [_btnAutoLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnAutoLogin.titleLabel.font = [UIFont systemFontOfSize:13];
        _btnAutoLogin.backgroundColor = [UIColor clearColor];
        [_btnAutoLogin addTarget:self action:@selector(onAutoLogin:) forControlEvents:UIControlEventTouchUpInside];
        [_loginView addSubview:_btnAutoLogin];
        _btnAutoLogin.deFrameRight = _loginView.deFrameWidth;

        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_loginView.frame) - 35, width, 35)];
        button.layer.cornerRadius = 3.5f;
        button.layer.masksToBounds = YES;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [button setTitle:@"登 录" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[ASUtils createImageWithColor:[UIColor colorWithRed:0x81/255.0 green:0xbc/255.0 blue:0x4e/255.0 alpha:1]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onLoginButton:) forControlEvents:UIControlEventTouchUpInside];
        [_loginView addSubview:button];
    }
    return _loginView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //背景
    self.bgImageView.image = [UIImage imageNamed:@"bg_pic"];
    //Logo
    self.logoView.backgroundColor = [UIColor clearColor];
    
    //Login
    self.loginView.backgroundColor = [UIColor clearColor];
    //版本上一次启动,要求记住密码
    NSNumber *isRemember = [ASUserDefaults objectForKey:LoginIsRememberPwd];
    if (!isRemember || [isRemember boolValue]) //默认为选中状态
    {
        _userNameTextField.text = [ASUserDefaults objectForKey:LoginUserName];
        _pwdTextField.text = [ASUserDefaults objectForKey:LoginUserPassword];
        _btnRememberPwd.selected = YES;
    }
    NSNumber *isAuto = [ASUserDefaults objectForKey:LoginIsAuto];
    if ([isAuto boolValue])//默认为选中状态
    {
        _btnAutoLogin.selected = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self onCheckDevice];
    
    //初始化app基本配置
    /*
    NSString *location = [ASUserDefaults objectForKey:AppCurrentLocation];
    if (![[YDSHSettingManger sharedInstance] updateAppSetting:location])
    {
        //未选择地区or地区已无效, 显示地区选择页面
        [self performSelectorOnMainThread:@selector(showPickerRegionViewController)withObject:nil waitUntilDone:NO];
        return ;
    }
    */
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)showAnimation:(NSTimeInterval)duration
{
    
    if (self.loginView.deFrameBottom == floorf((SCREEN_SIZE_HEIGHT * 4) / 5)
        && self.logoView.deFrameTop == floorf((SCREEN_SIZE_HEIGHT * 1) / 6)) {
        return; //已经处于目的位置
    }
    //动画
    [UIView animateWithDuration:duration animations:^{
        
        self.loginView.deFrameBottom = floorf((SCREEN_SIZE_HEIGHT * 4) / 5);
        self.logoView.deFrameTop = floorf((SCREEN_SIZE_HEIGHT * 1) / 6);
    }];
}

#pragma mark - Action

- (void)onRememberPwd:(id)sender
{
    UIButton *button = (UIButton*)sender;
    button.selected = !button.selected;
    
    [ASUserDefaults setObject:[NSNumber numberWithBool:button.selected] forKey:LoginIsRememberPwd];
}

- (void)onCheckDevice
{
    NSString *UUID = [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString;
    debug_NSLog(@"%@", UUID);

    __weak __typeof(self)weakSelf = self;
    NSString *name = _userNameTextField.text;
    NSString *pwd = _pwdTextField.text;
    [[JHttpManger sharedHttpManager] GET:CheckDevice parameters:@{@"deviceId": UUID} success:^(id responseObject) {
        if (responseObject)
        {
            /*设备标识已经记录在后台*/
            BOOL isLogin = [[responseObject objectForKey:@"isLogin"] boolValue];
            if (isLogin)
            {
                /*后台标记为自动登录,不用再输用户名密码*/
                [[AppDelegate appDelegate] setSideMenuViewController];
            }
            else
            {
                /*需要客户端重新输入用户名密码*/
                debug_NSLog(@"Check device success, need input username&password");
                if ([[ASUserDefaults objectForKey:LoginIsAuto] boolValue]
                    && ![name isEqualToString:@""]
                    && ![pwd isEqualToString:@""])
                {
                    [weakSelf performSelectorOnMainThread:@selector(onLoginButton:) withObject:nil waitUntilDone:NO];
                }
                else
                {
                    [weakSelf showAnimation:_isAnimated ? 1.f : 0.f];
                }
            }
        }
    } fail:^(NSError *error){
        if (NSURLErrorBadServerResponse == error.code)
        {
            /*设备不存在*/
            /*需要客户端重新输入用户名密码*/
            debug_NSLog(@"Check device failed");
            
            if ([[ASUserDefaults objectForKey:LoginIsAuto] boolValue]
                && ![name isEqualToString:@""]
                && ![pwd isEqualToString:@""])
            {
                [weakSelf performSelectorOnMainThread:@selector(onLoginButton:) withObject:nil waitUntilDone:NO];
            }
            else
            {
                [weakSelf showAnimation:_isAnimated ? 1.f : 0.f];
            }
        }
        else
        {
            debug_NSLog(@"check device, unknow error");
        }
    }];
}

- (void)onAutoLogin:(id)sender
{
    UIButton *button = (UIButton*)sender;
    button.selected = !button.selected;
    
    [ASUserDefaults setObject:[NSNumber numberWithBool:button.selected] forKey:LoginIsAuto];
}

- (void)onLoginButton:(id)sender
{
    if ([_userNameTextField isFirstResponder]) [_userNameTextField resignFirstResponder];
    if ([_pwdTextField isFirstResponder]) [_pwdTextField resignFirstResponder];
    
    NSString *name = [_userNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (!name || [name isEqualToString:@""])
    {
        [ASRequestHUD showErrorWithStatus:@"请输入用户名"];
        return ;
    }
    
    NSString *pwd = [_pwdTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (!pwd|| [pwd isEqualToString:@""])
    {
        [ASRequestHUD showErrorWithStatus:@"请输入密码"];
        return ;
    }
    
    [[JHttpManger sharedHttpManager] POST:Login parameters:@{@"loginType" : @"username",
                                                             @"username" : name,
                                                             @"password" : pwd,
                                                             @"deviceId" : [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString,
                                                             @"deviceType": [UIDevice currentDevice].model,
                                                             @"_rememberMe" : @""} success:^(id responseObject) {
                                                                 if (responseObject)
                                                                 {
                                                                     if ([[responseObject safeObjectForKey:@"isLogin"] boolValue])
                                                                     {
                                                                         /*登录成功*/
                                                                         [[AppDelegate appDelegate] setSideMenuViewController];
                                                                         
                                                                         /*记住用户名密码*/
                                                                         [ASUserDefaults setObject:name forKey:LoginUserName];
                                                                         NSNumber *isRememberPwd = [ASUserDefaults objectForKey:LoginIsRememberPwd];
                                                                         if (!isRememberPwd || [isRememberPwd boolValue])
                                                                             [ASUserDefaults setObject:pwd forKey:LoginUserPassword];
                                                                         else
                                                                             [ASUserDefaults setObject:nil forKey:LoginUserPassword];
                                                                     }
                                                                     else
                                                                     {
                                                                         /*账号信息错误*/
                                                                         [ASRequestHUD showErrorWithStatus:[responseObject safeObjectForKey:@"message"]];
                                                                     }
                                                                 }
                                                             } fail:^(NSError *error){
                                                                 
                                                             }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _userNameTextField) {
        [_pwdTextField becomeFirstResponder];
    }
    else if (textField == _pwdTextField) {
        [self onLoginButton:nil];
    }
    return YES;
}

@end
