//
//  SideMenuTableViewController.m
//  Bank
//
//  Created by Jack on 15/12/3.
//  Copyright © 2015年 Jack. All rights reserved.
//

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#import "SideMenuTableViewController.h"
#import "UIViewController+RESideMenu.h"
#import "RESideMenu.h"
#import "MineViewController.h"


@interface SideMenuTableViewController ()

@property (nonatomic, copy)NSArray *cellDataSources;
@property (nonatomic, copy)NSArray *controllers;

@end

@implementation SideMenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.navigationBarHidden = YES;
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
   
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.3)];
    headerView.backgroundColor = [UIColor grayColor];
    UIImageView *avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 96, 96)];
    avatarView.layer.borderWidth = 2;
    avatarView.layer.borderColor = UIColor.whiteColor.CGColor;
    avatarView.layer.cornerRadius = avatarView.frame.size.height/2;

    avatarView.clipsToBounds = YES;
    avatarView.userInteractionEnabled = YES;
    avatarView.backgroundColor = UIColor.greenColor;
    avatarView.x = 40;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [avatarView addGestureRecognizer:tap];

    [headerView addSubview:avatarView];
    self.tableView.tableHeaderView = headerView;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
    
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.cellDataSources.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
        cell.textLabel.text = self.cellDataSources[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *controllerName = self.controllers[indexPath.row];
    
    Class class = NSClassFromString(controllerName);
    if (class) {
        UIViewController *ctr = class.new;
        ctr.title = self.cellDataSources[indexPath.row];
        [self setContentViewController:ctr];
    }
    
    

}

- (void)setContentViewController:(UIViewController *)viewController
{
    viewController.hidesBottomBarWhenPushed = YES;
    UINavigationController *nav = (UINavigationController *)((UITabBarController *)self.sideMenuViewController.contentViewController).selectedViewController;
  
    [nav pushViewController:viewController animated:NO];
    
    [self.sideMenuViewController hideMenuViewController];
}

- (void)tapAction:(UITapGestureRecognizer *)sender{
    MineViewController *profile = MineViewController.new;
    profile.title = @"个人主页";
    
    [self setContentViewController:profile];
}

- (NSArray *)cellDataSources{
    if (!_cellDataSources) {
        self.cellDataSources = @[@"消息中心",@"安全中心",@"在线客服",@"关于我们",@"Weibo",@"Twitter",@"多线程实例"];
    }
    return _cellDataSources;
}
- (NSArray *)controllers{
    if (!_controllers) {
        self.controllers = @[@"InfoCenterController",@"SafeCenterController",@"OnlineServiceController",@"AboutController",@"WeiboController",@"TwitterController",@"MultiThreadViewController"];
    }
    return _controllers;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
