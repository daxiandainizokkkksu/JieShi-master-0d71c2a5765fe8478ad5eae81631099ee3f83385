//
//  SettingViewController.m
//  YDSHClient
//
//  Created by amy.fu on 15/3/25.
//  Copyright (c) 2015年 amy.fu. All rights reserved.
//

#import "SettingViewController.h"
#import "AboutViewController.h"
#import "HelpViewController.h"
#import "FeedbackViewController.h"
#import <UMFeedback.h>
@interface SettingViewController () <UITableViewDataSource,
                                        UITableViewDelegate>
{
    NSArray *_items;
    NSArray *_images;
  
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *button = createNaviButton(nil, @"icon_navi_menu", nil, self, @selector(presentLeftMenuViewController:), 0);
    setNavigationButton(self.navigationItem, button, YES);
    
    self.view.backgroundColor = ColorBackground;
    
//    _items = @[@"修改密码",@"意见反馈",@"使用帮助",@"检查版本",@"关于碣石"];
    _items = @[@[@"修改密码"],
                @[@"意见反馈"],
                @[@"使用帮助",@"检查版本",@"关于碣石"]];
  
    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private
- (NSString*)titleView
{
    return @"设置";
}

- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - UITableDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = _items[section];
    NSLog(@"%d",array.count);
    return array.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = ColorDarkText;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(tableView.frame) - 2*10, .5f)];
        lineView.backgroundColor = ColorLine;
        lineView.tag = 22;
        [cell.contentView addSubview:lineView];
    }
  
    NSArray *titles = _items[indexPath.section];
    cell.textLabel.text = titles[indexPath.row];
    //cell显示版本信息
    if (2 == indexPath.section && 1 == indexPath.row)
    {
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = ColorLightText;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"当前版本 %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    }
    
    UIView *lineView = [cell.contentView viewWithTag:22];
    lineView.deFrameBottom = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    lineView.hidden = (titles.count == (indexPath.row + 1)) ? YES : NO;

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = ColorBackground;

}
#pragma mark - UITableDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
        {
            /*修改密码*/
            NSLog(@"修改密码");
        }
            break;
        case 1:
        {
            /*意见反馈*/
//            [self presentModalViewController:[UMFeedback feedbackModalViewController]
//                                    animated:YES];
            FeedbackViewController *vc = [FeedbackViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];

            
            NSLog(@"意见反馈");
        }
            break;
        case 2:
        {
            /*使用帮助 检查版本 关于碣石*/
            switch (indexPath.row) {
                case 0:
                {
                    /*使用帮助*/
                    HelpViewController *vc = [HelpViewController new];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    NSLog(@"使用帮助");
                }
                    break;
                case 1:
                {
                    /*版本检查*/
                    NSLog(@"检查版本");
                }
                    break;
                case 2:
                {
                    /*关于碣石*/
                    AboutViewController *vc = [AboutViewController new];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    NSLog(@"关于碣石");
                }
                    break;
                default:
                    break;
            }
        }
        default:
            break;
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
