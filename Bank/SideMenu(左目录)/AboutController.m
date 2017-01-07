//
//  AboutController.m
//  Bank
//
//  Created by Jack on 15/12/17.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import "AboutController.h"


@interface AboutController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *serverData;
@property (nonatomic, strong) NSMutableArray *identifiers;
@property (nonatomic, strong) DataSource *dataSource;

@end

@implementation AboutController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    [self setupTableView];
    
}

- (void)setupTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.dataSource = [[DataSource alloc] initWithServerData:self.serverData cellIdentifiers:self.identifiers];
    __weak __typeof(self) weakSelf = self;
    self.dataSource.selectBlock = ^(id obj){
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf didSelectCellWithObject:obj];
    };
    self.dataSource.scrollBlock = ^(CGFloat alpha){
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf changeNavigationBarApperenceWithAlpha:alpha];
    };
    
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self.dataSource;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.tableView];
    
    
    
}

- (void)didSelectCellWithObject:(id)object{
    
    NSLog(@"选中了--%@",object);
    
}
- (NSMutableArray *)serverData{
    if (!_serverData) {
        self.serverData = [NSMutableArray arrayWithArray:@[@"hell0",@"yeah",@"you",@"mmm",@"girl",@"yeah",@"you",@"mmm",@"girl",@"yeah",@"you",@"mmm",@"girl",@"yeah",@"you",@"mmm",@"girl",@"yeah",@"you",@"mmm",@"girl",@"yeah",@"you",@"mmm",@"girl",@"yeah",@"you",@"mmm",@"girl",@"yeah",@"you",@"mmm",@"girl"]];
    }
    return _serverData;
}

- (NSMutableArray *)identifiers{
    if (!_identifiers) {
        self.identifiers = [NSMutableArray array];
        [_identifiers addObject:NSStringFromClass([self class])];
    }
    return _identifiers;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"self.tableView.subviews---%@",self.tableView.subviews);
    

}
- (void)changeNavigationBarApperenceWithAlpha:(CGFloat)alpha{
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    navigationBar.alpha = alpha;
    NSLog(@"alpha --- %f",alpha);
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}



@end
