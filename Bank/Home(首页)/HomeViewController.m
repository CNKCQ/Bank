//
//  HomeViewController.m
//  Bank
//
//  Created by Jack on 15/12/15.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import "HomeViewController.h"
#import "APGridLayoutScrollView.h"
#import "SDCycleScrollView.h"
#import "UIImage+ImageWithColor.h"
#import "MoreViewController.h"
#import "AppView.h"
#import "AppItemManager.h"



@interface HomeViewController()<APGridLayoutScrollViewDelegate,AppViewDelegate,SDCycleScrollViewDelegate>

@property (nonatomic, strong)APGridLayoutScrollView *gridView;
@property (nonatomic, copy)NSArray *apps;
@property (nonatomic, strong)NSMutableArray *showApps;
@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;

@end


@implementation HomeViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self loadUI];
}
- (void)loadUI{
    
    self.view.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:0.99];
  
    // 情景二：采用网络图片实现
    NSArray *imagesURLStrings = @[
                                  @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                  @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                                  ];

    // 情景三：图片配文字
    NSArray *titles = @[@"感谢您的支持，如果下载的",
                        @"如果代码在使用过程中出现问题",
                        @"您可以发邮件到gsdios@126.com",
                        @"感谢您的支持"
                        ];




    CGFloat w = self.view.bounds.size.width;


    // 网络加载 --- 创建带标题的图片轮播器
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, w, 160) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];

    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView.titlesGroup = titles;
    cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    self.cycleScrollView = cycleScrollView;
    [self.view addSubview:cycleScrollView];

    //         --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    });
    
    [self setupGridView];
    [self reloadGridView];
    
}
- (void)reloadGridView{
    [_gridView removeAllGridViews];
    [self.gridView beginUpdate];
    [self.showApps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AppItem *item = (AppItem *)obj;

        if (!item.selected && ![item.imageName isEqualToString:@"more"]) return;

        //        UIImage* image = [UIImage imageNamed:obj[@"icon"]];
        UIImage* image = [UIImage imageNamed:item.imageName];
        AppView* view = [[AppView alloc] initWithFrame:CGRectMake(0, 0, _gridView.gridWidth, _gridView.gridHeight) icon:image title:item.title];
        view.backgroundColor = [UIColor whiteColor];
        view.delegate = self;
        view.appId = item.imageName;
        [self.gridView addGridView:view];
        
    }];
    [self.gridView endUpdate];
}
- (void)setupGridView
{
    if (!_gridView)
    {
        NSUInteger columnCount = 4;
        CGSize size = [UIScreen mainScreen].bounds.size;
        CGFloat width = size.width / columnCount;
        
        _gridView = [[APGridLayoutScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cycleScrollView.frame), self.view.bounds.size.width, self.view.bounds.size.height-CGRectGetMaxY(self.cycleScrollView.frame)) style:APGridLayoutStyleDefault columnCount:columnCount gridWidth:width gridHeight:100];
        _gridView.alwaysBounceVertical = YES;
        _gridView.deleteButtonPosition = APGridLayoutDeleteButtonTopRight;
        _gridView.dataSource = self;
        _gridView.horizontalSplitImage = [UIImage imageWithColor:[UIColor colorWithWhite:0.8 alpha:1.0f] size:CGSizeMake(0.5, 100)];
        _gridView.verticalSplitImage = [UIImage imageWithColor:[UIColor colorWithWhite:0.8 alpha:1.0f] size:CGSizeMake(width, 0.5)];
        _gridView.contentInset = UIEdgeInsetsMake(0, 0, 20 + 44 + 50, 0);
        [self.view addSubview:_gridView];
    }
}
- (void)onTap:(AppView*)sender{
    
    [self.showApps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AppItem *item = (AppItem *)obj;
        if ([sender.appId isEqualToString:item.imageName]) {
            if ([item.title isEqualToString:@"更多"] ) {
                MoreViewController *moreController = [[MoreViewController alloc] init];
                moreController.title = @"更多";
                moreController.gridViewBlock = ^(NSString *string){
                    [self reloadGridView];
                };
                [self.navigationController pushViewController:moreController animated:NO];
            }
            *stop = YES;
        }
        
    }];
    
}

- (void)onSubviewDeleted:(APGridLayoutScrollView*)sender view:(UIView*)view{
    if ([view isKindOfClass:[AppView class]]) {
        AppView *appView = (AppView *)view;
        NSString *appTitle = NSString.new;
        for (AppItem *item in self.showApps) {
            if ([item.imageName isEqualToString:appView.appId]) {
                appTitle = item.title;
                for (UIView *subView in appView.subviews) {
                    if ([subView isKindOfClass: [APGridLayoutDeleteButton class]]) {
                        APGridLayoutDeleteButton *button = (APGridLayoutDeleteButton *)subView;
                        
                        item.selected = !button.SELECTED;
                        [[AppItemManager defaultManager] svaeToDisk];
                        [_gridView beginUpdate];
                        [_gridView endUpdate];
                        
                    }
                }
            }
        }
        
    }
}

- (NSArray *)apps{
    if (!_apps) {
        NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Apps" ofType:@"plist"]];
        self.apps = dict[@"Apps"];
    }
    return _apps;
}

- (NSMutableArray *)showApps{
//    if (!_showApps) {
//        NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ShowApps" ofType:@"plist"]];
//        self.showApps = dict[@"Apps"];
//    }
    NSArray *apps = [[AppItemManager defaultManager] appItems];
    self.showApps = [NSMutableArray arrayWithArray:apps];
    return _showApps;
}
#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    [self.navigationController pushViewController:[NSClassFromString(@"DemoVCWithXib") new] animated:YES];
}
- (UIRectEdge)edgesForExtendedLayout{
    return UIRectEdgeNone;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

@end

