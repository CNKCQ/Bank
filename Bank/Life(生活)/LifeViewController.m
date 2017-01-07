//
//  LifeViewController.m
//  Bank
//
//  Created by Jack on 15/12/15.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import "LifeViewController.h"
#import "HomeMenuCell.h"
#import <ShareSDK/ShareSDK.h>
#import "FinancingViewController.h"
#import "ChildViewController.h"
#import "LifeViewController+property.h"

@interface LifeViewController ()<UITableViewDelegate,UITableViewDataSource,HomeMenuCellDelegate>
@property (nonatomic,strong) NSMutableArray *menuArray;
@property (nonatomic, strong)UITableView *tableView;

@end

@implementation LifeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setNavigationBar];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
//    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = [UIColor purpleColor];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 400)];
    FinancingViewController *financingViewController = [[FinancingViewController alloc] init];
//       ChildViewController *financingViewController = [[ChildViewController alloc] init];

    [self addChildViewController:financingViewController];

    footerView.backgroundColor = [UIColor blueColor];

    // 模仿网络延迟，0.2秒后，才知道有多少标题

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIViewController *vc = obj;
            if (vc.view.superview) return;
//            if (vc.view.subviews) {
////                NSLog(@"hello%@",vc.view.subviews);
//                return;
//            }
            vc.view.frame = footerView.frame;
            [footerView addSubview:vc.view];
            self.tableView.tableFooterView = footerView;
        }];
        

    });


//    NSLog(@"self - %@",NSStringFromClass([self class]));
//    SEL sel = NSSelectorFromString(@"");
    
    [self.view addSubview:self.tableView];
    
}
- (void)setNavigationBar{
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(share:)]];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(refresh)]];
}

- (void)refresh{
    for (UIViewController *childViewController in self.childViewControllers) {
        if ([childViewController isKindOfClass:[FinancingViewController class]]) {
            FinancingViewController *childViewControlle = (FinancingViewController *)childViewController;
            [childViewControlle reloadData];
            
        }
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 1;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        static NSString *scellId = @"sdellid";
        HomeMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:scellId];
        if (!cell) {
            cell = [[HomeMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:scellId menuArray:self.menuArray];
            cell.menuDelegate = self;
        }
        return cell;
    }else{
        static NSString *cellId = @"dellid";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        return cell;
    }

    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0;
    }
    
    return 200;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)menueCell:(HomeMenuCell *)cell didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"item -- %@",[self.menuArray[index] objectForKey:@"title"]);
}

- (void)share:(UIBarButtonItem *)sender{
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK" ofType:@"png"];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:nil
                                       defaultContent:nil
                                                image:nil
                                                title:nil
                                                  url:nil
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    [publishContent addSMSUnitWithContent:@"hello it's me"];
    
//    [publishContent addWeixinSessionUnitWithType:[NSNumber numberWithInt:SSPublishContentMediaTypeNews] content:nil title:nil url:nil image:nil musicFileUrl:nil extInfo:nil fileData:nil emoticonData:nil];
//    
//    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInt:SSPublishContentMediaTypeNews] content:nil title:nil url:nil image:nil musicFileUrl:nil extInfo:nil fileData:nil emoticonData:nil];
//    
//    [publishContent addQQUnitWithType:[NSNumber numberWithInt:SSPublishContentMediaTypeNews] content:nil title:nil url:nil image:nil];
//    
//    [publishContent addQQSpaceUnitWithtitle:@"hello" url:nil description:nil image:nil type:[NSNumber numberWithInt:SSPublishContentMediaTypeNews]];
//    
    
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];

    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
}

- (NSMutableArray *)menuArray{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"menuData" ofType:@"plist"];
    
    if (!_menuArray) {
        self.menuArray = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    }
    return _menuArray;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    LifeViewController *lif = LifeViewController.new;
    lif.owner = @"me";
    NSLog(@"self.owner -- %@",lif.owner);
}

@end
