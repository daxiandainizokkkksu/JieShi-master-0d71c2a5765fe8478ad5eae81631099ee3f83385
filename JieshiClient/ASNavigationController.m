//
//  ASNavigationController.m
//  YDSHClient
//
//  Created by amy.fu on 15/3/25.
//  Copyright (c) 2015年 amy.fu. All rights reserved.
//

#import "ASNavigationController.h"

@interface ASNavigationController ()

@end

@implementation ASNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

#pragma mark - ASNavigationBar
UIButton *createNaviButton2(NSString *title, UIImage *bkImageN, UIImage *bkImageP, id target, SEL action)
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    UIFont *font = [UIFont systemFontOfSize:16];
    CGSize fontSize =[title sizeWithFont:font forWidth:1000 lineBreakMode:NSLineBreakByTruncatingTail];
    CGFloat buttonWidth = MAX(bkImageN.size.width, fontSize.width+10);
    button.frame = CGRectMake(0, 0, buttonWidth+10, 40);
    if (title)
    {
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        button.titleLabel.backgroundColor = [UIColor clearColor];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    
    if (bkImageN)
    {
        [button setImage:bkImageN forState:UIControlStateNormal];
    }
    if (bkImageP)
    {
        [button setImage:bkImageP forState:UIControlStateHighlighted];
    }
    button.contentMode = UIViewContentModeCenter;
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

UIButton *createNaviButton(NSString *name, NSString *bkImageN, NSString *bkImageP, id target, SEL action, int flag)
{
    NSString *title = nil;
    if(name != nil)
    {
        if(flag == 1)
        {
            title = name;
        }
        else if (flag == 2)
        {
            title = [NSString stringWithFormat:@" %@", name];
        }
        else if(flag == 3)
        {
            title = [NSString stringWithFormat:@"%@ ", name];
        }
        else
        {
            title = name;
        }
    }
    
    if (flag == 2)
        bkImageP = nil;
    else if (name != nil) {
        bkImageN = nil;
        bkImageP = nil;
    }
   	UIImage *imageN = nil;
    UIImage *imageP = nil;
    if (bkImageN)
    {
        imageN = [UIImage imageNamed:bkImageN];
    }
    if (bkImageP)
    {
        imageP = [UIImage imageNamed:bkImageP];
    }
    
    return createNaviButton2(title, imageN, imageP, target, action);
}

void setNavigationButton(UINavigationItem *navigationItem, UIButton *button, BOOL left)
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    if (left)
    {
        navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, item, nil];;
    }
    else
    {
        navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, item, nil];;
    }
}

UIView *createTitleView(NSString *name)
{
    if (name)
    {
        UIFont *font = [UIFont boldSystemFontOfSize:20];
        CGSize fontSize =[name sizeWithFont:font forWidth:1000 lineBreakMode:NSLineBreakByTruncatingTail];
        
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, fontSize.width, 40)];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = font;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.text = name;
        return nameLabel;
    }
    return nil;
}
