//
//  AboutViewController.m
//  JieshiClient
//
//  Created by 杨建良 on 15/10/28.
//  Copyright © 2015年 dayu. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()
@property(nonatomic,strong) UILabel *lbVersion;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lbVersion.text = [NSString stringWithFormat:@"版本 %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString*)titleView
{
    return @"关于碣石";
}
#pragma mark - Private
- (UILabel*)lbVersion
{
    if (!_lbVersion)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake((self.view.deFrameWidth - 60)/2, 40, 60, 60)];
        view.backgroundColor = [UIColor clearColor];
        [self.view addSubview:view];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:view.bounds];
        imageView.image = [UIImage imageNamed:@"icon_about_logo"];
        [view addSubview:imageView];
        
        _lbVersion = [[UILabel alloc] initWithFrame:CGRectMake(0, view.deFrameBottom + 10, self.view.deFrameWidth, 10)];
        _lbVersion.textAlignment = NSTextAlignmentCenter;
        _lbVersion.font = [UIFont systemFontOfSize:16];
        _lbVersion.textColor = ColorDarkText;
        [self.view addSubview:_lbVersion];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.deFrameHeight - 50, self.view.deFrameWidth, 50)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = ColorDarkText;
        label.text = @"©2015 浙江省水利水电勘测设计院";
        label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.view addSubview:label];
    }
    return _lbVersion;
}


@end
