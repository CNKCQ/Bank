//
//  TabBarViewController.m
//  TradeBank
//
//  Created by Jack on 15/12/2.
//  Copyright © 2015年 Jack. All rights reserved.
//

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#import "TabBarViewController.h"
#import "NavigationViewController.h"
#import "LLTabBar.h"
#import "LLTabBarItem.h"
#import "HomeViewController.h"
#import "FinancingViewController.h"
#import "LifeViewController.h"
#import "AssetViewController.h"

//#import "RESideMenu.h"

@interface TabBarViewController ()<LLTabBarDelegate,UIActionSheetDelegate>

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutUI];
}
- (void)layoutUI{

    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    FinancingViewController *financingViewController = [[FinancingViewController alloc] init];
//      UIViewController *financingViewController = [[UIViewController alloc] init];
    LifeViewController *lifeViewController = [[LifeViewController alloc] init];
    AssetViewController *assetViewController = [[AssetViewController alloc] init];
    
    
    lifeViewController.view.backgroundColor = [UIColor redColor];
    assetViewController.view.backgroundColor = [UIColor blueColor];
    
    homeViewController.title = @"首页";
    financingViewController.title = @"理财";
    lifeViewController.title = @"生活";
    assetViewController.title = @"资产";


    
    NavigationViewController *homeNavi = [[NavigationViewController alloc] initWithRootViewController:homeViewController];
    NavigationViewController *financingNavi = [[NavigationViewController alloc] initWithRootViewController:financingViewController];
    NavigationViewController *lifeNavi = [[NavigationViewController alloc] initWithRootViewController:lifeViewController];
    NavigationViewController *assetNavi = [[NavigationViewController alloc] initWithRootViewController:assetViewController];


    self.viewControllers = @[homeNavi, financingNavi, lifeNavi, assetNavi];
    
    
    
    
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    LLTabBar *tabBar = [[LLTabBar alloc] initWithFrame:self.tabBar.bounds];
    
    CGFloat normalButtonWidth = (SCREEN_WIDTH * 3 / 4) / 4;
    CGFloat tabBarHeight = CGRectGetHeight(tabBar.frame);
    CGFloat publishItemWidth = (SCREEN_WIDTH / 4);
    
    LLTabBarItem *homeItem = [self tabBarItemWithFrame:CGRectMake(0, 0, normalButtonWidth, tabBarHeight)
                                                 title:@"首页"
                                       normalImageName:@"home_normal"
                                     selectedImageName:@"home_highlight" tabBarItemType:LLTabBarItemNormal];
    LLTabBarItem *sameCityItem = [self tabBarItemWithFrame:CGRectMake(normalButtonWidth, 0, normalButtonWidth, tabBarHeight)
                                                     title:@"理财"
                                           normalImageName:@"mycity_normal"
                                         selectedImageName:@"mycity_highlight" tabBarItemType:LLTabBarItemNormal];
    LLTabBarItem *publishItem = [self tabBarItemWithFrame:CGRectMake(normalButtonWidth * 2, 0, publishItemWidth, tabBarHeight)
                                                    title:@""
                                          normalImageName:@"post_normal"
                                        selectedImageName:@"post_normal" tabBarItemType:LLTabBarItemRise];
    LLTabBarItem *messageItem = [self tabBarItemWithFrame:CGRectMake(normalButtonWidth * 2 + publishItemWidth, 0, normalButtonWidth, tabBarHeight)
                                                    title:@"生活"
                                          normalImageName:@"message_normal"
                                        selectedImageName:@"message_highlight" tabBarItemType:LLTabBarItemNormal];
    LLTabBarItem *mineItem = [self tabBarItemWithFrame:CGRectMake(normalButtonWidth * 3 + publishItemWidth, 0, normalButtonWidth, tabBarHeight)
                                                 title:@"资产"
                                       normalImageName:@"account_normal"
                                     selectedImageName:@"account_highlight" tabBarItemType:LLTabBarItemNormal];
    
    tabBar.tabBarItems = @[homeItem, sameCityItem, publishItem, messageItem, mineItem];
    tabBar.delegate = self;
    
    [self.tabBar addSubview:tabBar];

}

- (LLTabBarItem *)tabBarItemWithFrame:(CGRect)frame title:(NSString *)title normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName tabBarItemType:(LLTabBarItemType)tabBarItemType {
    LLTabBarItem *item = [[LLTabBarItem alloc] initWithFrame:frame];
    [item setTitle:title forState:UIControlStateNormal];
    [item setTitle:title forState:UIControlStateSelected];
    item.titleLabel.font = [UIFont systemFontOfSize:8];
    UIImage *normalImage = [UIImage imageNamed:normalImageName];
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    [item setImage:normalImage forState:UIControlStateNormal];
    [item setImage:selectedImage forState:UIControlStateSelected];
    [item setImage:selectedImage forState:UIControlStateHighlighted];
    [item setTitleColor:[UIColor colorWithWhite:51 / 255.0 alpha:1] forState:UIControlStateNormal];
    [item setTitleColor:[UIColor colorWithWhite:51 / 255.0 alpha:1] forState:UIControlStateSelected];
    item.tabBarItemType = tabBarItemType;
    
    return item;
}

#pragma mark - LLTabBarDelegate

- (void)tabBarDidSelectedRiseButton {

    UIViewController *viewController = self.selectedViewController;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册选取", @"淘宝一键转卖", nil];
    [actionSheet showInView:viewController.view];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"buttonIndex = %ld", buttonIndex);
}
@end
