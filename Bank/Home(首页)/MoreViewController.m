//
//  MoreViewController.m
//  Bank
//
//  Created by Jack on 15/12/26.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import "MoreViewController.h"
#import "AppView.h"
#import "APGridLayoutScrollView.h"
#import "UIImage+ImageWithColor.h"
#import "AppItemManager.h"
@interface MoreViewController()<AppViewDelegate,APGridLayoutScrollViewDelegate>
@property (nonatomic, strong)APGridLayoutScrollView *gridView;
@end

@implementation MoreViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setNavigationBar];
    [self loadUI];
}
- (void)loadUI{
    
    self.view.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:0.99];
    self.view.backgroundColor = [UIColor orangeColor];
    
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
    [self reloadGridView];
    
}
- (void)reloadGridView{

    _moreApps = nil;
    _gridView = nil;
    [self setupGridView];

    [self.gridView beginUpdate];
    [self.moreApps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AppItem *appItem = (AppItem *)obj;
        if (appItem.selected) return;
        UIImage* image = [UIImage imageNamed:appItem.imageName];
        AppView* view = [[AppView alloc] initWithFrame:CGRectMake(0, 0, _gridView.gridWidth, _gridView.gridHeight) icon:image title:appItem.title];
        
        //        UIImage* image = [UIImage imageNamed:obj[@"icon"]];
        //        AppView* view = [[AppView alloc] initWithFrame:CGRectMake(0, 0, _gridView.gridWidth, _gridView.gridHeight) icon:image title:obj[@"name"]];
        
        view.backgroundColor = [UIColor whiteColor];
        view.delegate = self;
        //        view.appId = obj[@"icon"];
        view.appId = appItem.imageName;
        [self.gridView addGridView:view];
        
    }];
        [self.gridView endUpdate];
}
- (void)setupGridView
{
    
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    if (!_gridView)
    {
        NSUInteger columnCount = 4;
        CGSize size = [UIScreen mainScreen].bounds.size;
        CGFloat width = size.width / columnCount;
        self.gridView = [[APGridLayoutScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, HEIGHT) style:APGridLayoutStyleDefault columnCount:columnCount gridWidth:width gridHeight:100];
        _gridView.alwaysBounceVertical = YES;
        _gridView.deleteButtonPosition = APGridLayoutDeleteButtonTopRight;
        _gridView.buttonImage = APGridLayoutSelectButtonImg;
        _gridView.dataSource = self;
        _gridView.horizontalSplitImage = [UIImage imageWithColor:[UIColor colorWithWhite:0.8 alpha:1.0f] size:CGSizeMake(0.5, 100)];
        _gridView.verticalSplitImage = [UIImage imageWithColor:[UIColor colorWithWhite:0.8 alpha:1.0f] size:CGSizeMake(width, 0.5)];
        _gridView.contentInset = UIEdgeInsetsMake(0, 0, 20 + 44 + 50, 0);
        _gridView.animatable = NO;
        [self.view addSubview:_gridView];
    }
}
- (void)onTap:(AppView*)sender{
    
    [self.moreApps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AppItem *item = (AppItem *)obj;
        if ([sender.appId isEqualToString:item.imageName]) {
            NSLog(@"item.imageName----%@",item.title);
            
            *stop = YES;
        }
        
    }];
    
}

- (void)onSubviewDeleted:(APGridLayoutScrollView*)sender view:(UIView*)view{
    if ([view isKindOfClass:[AppView class]]) {
        AppView *appView = (AppView *)view;
        NSString *appTitle = NSString.new;
        for (AppItem *item in self.moreApps) {
            if ([item.imageName isEqualToString:appView.appId]) {
                appTitle = item.title;
                for (UIView *subView in appView.subviews) {
                    if ([subView isKindOfClass: [APGridLayoutDeleteButton class]]) {
                        APGridLayoutDeleteButton *button = (APGridLayoutDeleteButton *)subView;
                            
                            item.selected = button.SELECTED;
                            [_gridView beginUpdate];

                    }
                }
            }
        }

    }
}
- (void)onSubviewDragEnd:(APGridLayoutScrollView*)sender view:(UIView*)view deleted:(BOOL)deleted from:(int)from to:(int)to{
    
    [[AppItemManager defaultManager] moveAppItemFromIndex:from toIndex:to];
    [[AppItemManager defaultManager] svaeToDisk];
    
}

- (void)editAction:(UIBarButtonItem *)sender{
    if (_gridView.editing) {
        self.navigationItem.rightBarButtonItem.title = @"管理";
        [_gridView endEdit];
        
    }else{
        [_gridView beginEdit];
        self.navigationItem.rightBarButtonItem.title = @"保存";
    }
    if (![sender.title  isEqual: @"保存"]) {
        [[AppItemManager defaultManager] svaeToDisk];
        if (self.gridViewBlock) {
            self.gridViewBlock(@"");
        }
        [self reloadGridView];
    }
    
}
- (void)setNavigationBar{
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"管理" style:UIBarButtonItemStylePlain target:self action:@selector(editAction:)]];
}

- (NSMutableArray *)moreApps{
        NSArray *apps = [[AppItemManager defaultManager] appItems];
        NSMutableArray *mApps = [NSMutableArray new];
        [apps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [mApps addObject:obj];
        }];
    self.moreApps = mApps;
    return _moreApps;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self reloadGridView];
    
}


- (UIRectEdge)edgesForExtendedLayout{
    return UIRectEdgeNone;
}

@end
