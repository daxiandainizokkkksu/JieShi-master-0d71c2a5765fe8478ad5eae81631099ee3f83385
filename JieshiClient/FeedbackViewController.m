//
//  FeedbackViewController.m
//  JieshiClient
//
//  Created by 杨建良 on 15/10/29.
//  Copyright © 2015年 dayu. All rights reserved.
//

#import "FeedbackViewController.h"
#import <UMFeedback.h>
#import "UIPlaceholderTextView.h"
@interface FeedbackViewController ()<UITextViewDelegate,UMFeedbackDataDelegate,UIAlertViewDelegate>
@property(nonatomic,strong) UIPlaceholderTextView *textView;
@property(nonatomic,strong) UILabel *countLable;//字数显示
@property(nonatomic,strong) UIBarButtonItem *rightBtn;
@property(nonatomic) NSInteger alertTag;//1pop出去 0 留在原来界面
@end

@implementation FeedbackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.textView.placeholder = @"请描述你的问题";
    self.countLable.text = @"128";
    self.navigationItem.rightBarButtonItem = self.rightBtn;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

-(UITextView *)textView
{
    if (!_textView) {
        _textView = [UIPlaceholderTextView new];
        _textView.delegate = self;
        _textView.frame = CGRectMake(0, 0, self.view.deFrameWidth, 80.f);
        [self.view addSubview:_textView];
    }
    return _textView;
}

-(UILabel *)countLable
{
    if (!_countLable) {
        _countLable = [UILabel new];
        _countLable.frame = CGRectMake(self.view.deFrameWidth - 30, _textView.deFrameHeight + 5, 30, 20);
        _countLable.textColor = ColorLightText;
        _countLable.font = [UIFont systemFontOfSize:13];
        [self.view addSubview:_countLable];
        
    }
    return _countLable;
}

-(UIBarButtonItem *)rightBtn
{
    if(!_rightBtn)
    {
        UIButton *btn = [UIButton new];
        btn.frame = CGRectMake(0, 0, 40, 30);
        [btn setTitle:@"提交" forState:UIControlStateNormal];
        [btn setTitleColor:ColorDarkText forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn addTarget:self action:@selector(feedbcak) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    }
    return _rightBtn;

}

-(NSString *)titleView
{
    return @"意见反馈";
}

#pragma mark - Methods
-(void)feedbcak
{
    UMFeedback *feedback = [UMFeedback new];
    NSString *feedBackStr = [NSString stringWithFormat:@"%@",self.textView.text];
    NSDictionary *feedBackDic = @{@"content":feedBackStr};
    
    [feedback post:feedBackDic completion:^(NSError *error)
    {
        if (error == nil)
        {
            self.alertTag = 1;
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提交成功"
                                                               message:@"感谢您的反馈"
                                                              delegate:self
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil];
            [alertView show];
        }
        else
        {
            
            if (self.textView.text.length == 0)
            {
                self.alertTag = 0;
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提交失败"
                                                                   message:@"请输入您的反馈信息后再次点击提交!"
                                                                  delegate:self
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil];
                [alertView show];
                
            }
            else
            {
                self.alertTag = 1;
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提交失败"
                                                                   message:@"请检查你您的网络"
                                                                  delegate:self
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil];
                [alertView show];
            }
        }
        
    }];
}

#pragma mark - UITextViewDelegate

-(void)textViewDidChange:(UITextView *)textView
{
    NSInteger num = self.textView.text.length;
    /*textview 字数限制*/
    if (num > 128)
    {
        self.textView.text = [self.textView.text substringToIndex:128];
    }else
    {
        self.countLable.text = [NSString stringWithFormat:@"%d",128-num];
    }
    
}
//键盘隐藏
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
    
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (self.alertTag == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }

}

@end
