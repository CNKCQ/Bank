//
//  FinancingViewController.m
//  Bank
//
//  Created by Jack on 15/12/15.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import "FinancingViewController.h"
#import "ChildViewController.h"

@interface FinancingViewController ()
@property (nonatomic, strong)NSArray *navDatas;
@end

@implementation FinancingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    // 模仿网络延迟，0.2秒后，才知道有多少标题
    self.isfullScreen = YES;
    [self reloadData];
    // 标题渐变
    self.isShowTitleGradient = YES;
    
    // 标题填充模式
    self.titleColorGradientStyle = YZTitleColorGradientStyleFill;
}
- (void)setUpAllViewController{
    
    [self.navDatas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ChildViewController *ctr = ChildViewController.new;
        ctr.title = [obj objectForKey:@"title"];
        [self addChildViewController:ctr];
    }];
    
}

- (NSArray *)navDatas{
    if (!_navDatas) {
        NSData *navData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"News" ofType:@"json"]];
        self.navDatas = [NSJSONSerialization JSONObjectWithData:navData options:NSJSONReadingAllowFragments error:nil];
    }
    return _navDatas;
}

- (void)reloadData{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 移除之前所有子控制器
        [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
        // 把对应标题保存到控制器中，并且成为子控制器，才能刷新
        // 添加所有新的子控制器
        [self setUpAllViewController];
        
        // 注意：必须先确定子控制器
        [self refreshDisplay];
        
    });
}


@end
