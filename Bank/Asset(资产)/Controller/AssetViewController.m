//
//  AssetViewController.m
//  Bank
//
//  Created by Jack on 15/12/15.
//  Copyright © 2015年 Jack. All rights reserved.
//
#define color(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#import "AssetViewController.h"
#import "AssetView.h"
#import "NSObject+KVO.h"
#import "ReactiveCocoa.h"

@interface AssetViewController (){
    BOOL _hasPlay;
}
@property (strong, nonatomic) NSMutableArray *viewArray;
@property (strong, nonatomic) AssetView *assetView;
@end

@implementation AssetViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.assetView = [[AssetView alloc] initWithFrame:CGRectMake(100, 120, 200, 400)];
    self.assetView.ttext = @"你好 好家伙，又见到你了，希望你一切都还没有改变";
    
    
    __weak __typeof(self)weakSelf = self;
    
//    [self.assetView addObserver:self forKey:@"ttext" withBlock:^(id observedObject, NSString *observedKey, id oldValue, id newValue) {
    
    [self.assetView addObserver:self forKey:NSStringFromSelector(@selector(ttext)) withBlock:^(id observedObject, NSString *observedKey, id oldValue, id newValue) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSLog(@"%@.%@is now:%@",observedObject,observedKey,newValue);
        strongSelf.title = strongSelf.assetView.ttext;
    }];
    [[self.assetView.racButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        NSLog(@"assetView.racButton ---- ");
        
    }];
    

    
    _assetView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_assetView];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.assetView.ttext = @"hello da sa";
    [self.assetView reload];
    BaseViewController *v = [[BaseViewController alloc] init];
    [self.navigationController pushViewController:v animated:YES];
}
- (void)dealloc{
    [self.assetView removeObserver:self forKey:NSStringFromSelector(@selector(ttext))];
}
@end
