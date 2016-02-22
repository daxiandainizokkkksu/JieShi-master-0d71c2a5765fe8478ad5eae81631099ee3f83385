//
//  MenuViewController.m
//  YDSHClient
//
//  Created by amy.fu on 15/3/25.
//  Copyright (c) 2015年 amy.fu. All rights reserved.
//

#import <RESideMenu/RESideMenu.h>
#import "MenuViewController.h"
#import "AppDelegate.h"

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSString *_identifierCell;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *menuItems;

@end

@implementation MenuViewController

- (UITableView*)tableView
{
    if (!_tableView) {
        
        CGFloat height = 40 * self.menuItems.count;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.deFrameHeight - height) / 2.0f, self.view.deFrameWidth, height)
                                                  style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.opaque = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = nil;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = NO;
        _tableView.scrollsToTop = NO;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray*)menuItems
{
    if (!_menuItems) {
        _menuItems = [[NSMutableArray alloc] initWithObjects:
                      [[NSDictionary alloc] initWithObjectsAndKeys:@"设置", @"title", @"icon_shezhi", @"icon", @"SettingViewController", @"class", nil],
                      nil];
        [_menuItems addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"退出", @"title", @"icon_tuichu", @"icon", @"LogoutViewController", @"class", nil]];
    }
    return _menuItems;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    if (self.menuItems.count <= indexPath.row)
        return cell;
    
    NSDictionary *itemDict = [self.menuItems objectAtIndex:indexPath.row];
    cell.textLabel.text = [itemDict objectForKey:@"title"];
    cell.imageView.image = [UIImage imageNamed:[itemDict objectForKey:@"icon"]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.menuItems.count > indexPath.row)
    {
        NSDictionary *itemDict = [self.menuItems objectAtIndex:indexPath.row];
        NSString *class = [itemDict objectForKey:@"class"];
        
       
        if ([class isEqualToString:@"LogoutViewController"])
        {
            [ASUserDefaults setObject:[NSNumber numberWithBool:NO] forKey:LoginIsAuto];
            [[AppDelegate appDelegate] logout];
        }
        else
        {
            //
            ASNavigationController *currentContentController = (ASNavigationController*)self.sideMenuViewController.contentViewController;
            id vc = [currentContentController.viewControllers objectAtIndex:0];
            if (![vc isKindOfClass:NSClassFromString(class)])
            {
                ASNavigationController *navigationController = [[ASNavigationController alloc] initWithRootViewController:[[NSClassFromString(class) alloc] init]];
                navigationController.navigationBar.barTintColor = ColorThemeBule;
                navigationController.navigationBar.translucent = NO;
                [self.sideMenuViewController setContentViewController:navigationController animated:YES];
            }
            [self.sideMenuViewController hideMenuViewController];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
