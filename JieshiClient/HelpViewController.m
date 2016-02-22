//
//  HelpViewController.m
//  JieshiClient
//
//  Created by 杨建良 on 15/10/28.
//  Copyright © 2015年 dayu. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()
@property (nonatomic,strong) UIWebView *webView;

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:@"http://demo1.dayuteam.cn/jieshi/help.html"];//测试地址
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString *)titleView
{
    return @"使用帮助";
}
-(UIWebView *)webView
{
    if (!_webView) {
    
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.deFrameWidth, self.view.deFrameHeight-64)];
        _webView.scalesPageToFit = YES;
        [self.view addSubview:_webView];

    }

    return _webView;
}


@end
