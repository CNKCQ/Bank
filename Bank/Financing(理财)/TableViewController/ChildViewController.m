//
//  ChildViewController.m
//  YZDisplayViewControllerDemo
//
//  Created by yz on 15/12/5.
//  Copyright © 2015年 yz. All rights reserved.
//

#import "ChildViewController.h"
#import "NetworkPort.h"

@interface ChildViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *menuArray;
@property (nonatomic, strong) UITableView *tableView;


@end
@implementation ChildViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];

    // 设置额外滚动区域,如果全屏
    if (self.navigationController) {
        // 导航条上面高度
//        CGFloat navBarH = 64;
//        CGFloat navBarH = 0;

        
        // 查看自己标题滚动视图设置的高度，我这里设置为44
//        CGFloat titleScrollViewH = 44;
        
        self.tableView.showsVerticalScrollIndicator = NO;
        
//        self.tableView.contentInset = UIEdgeInsetsMake(navBarH + titleScrollViewH, 0, 0, 0);
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 180;
    }else{
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        static NSString *cellId = @"dellid";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.backgroundColor = [UIColor brownColor];
        return cell;
        
    }else{
        
        static NSString *ID = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ : %ld",self.title,indexPath.row];
        
        return cell;
    }
    
}

- (NSMutableArray *)menuArray{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"menuData" ofType:@"plist"];
    
    if (!_menuArray) {
        self.menuArray = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    }
    return _menuArray;
}

//- (UIRectEdge)edgesForExtendedLayout{
//    return UIRectEdgeNone;
//}

@end
