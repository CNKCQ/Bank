//
//  BaseViewController.m
//  Bank
//
//  Created by Jack on 16/1/2.
//  Copyright © 2016年 Jack. All rights reserved.
//

#import "BaseViewController.h"
#import "LaunchView.h"

@implementation BaseViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    for (UIView *sub in window.subviews) {
//        if ([sub isKindOfClass:[LaunchView class]]) {
//            [sub removeFromSuperview];
//        }
//    }
}
- (void)dealloc{
    NSLog(@"%@销毁了",self.title);
}

@end
