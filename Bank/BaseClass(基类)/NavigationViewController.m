//
//  NavigationViewController.m
//  TradeBank
//
//  Created by Jack on 15/12/2.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import "NavigationViewController.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self.navigationBar setBarTintColor:[UIColor greenColor]];
    self.navigationController.navigationBar.translucent = NO;
}

@end
