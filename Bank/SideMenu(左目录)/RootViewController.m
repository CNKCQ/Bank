//
//  ViewController.m
//  Bank
//
//  Created by Jack on 15/12/3.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import "RootViewController.h"
#import "TabBarViewController.h"
#import "SideMenuTableViewController.h"


@interface RootViewController ()

@end

@implementation RootViewController

- (void)awakeFromNib
{
    self.parallaxEnabled = NO;
//    self.scaleContentView = YES;
    self.scaleContentView = NO;
    self.contentViewScaleValue = 0.95;
    self.scaleMenuView = NO;
    self.contentViewShadowEnabled = YES;
    self.contentViewShadowRadius = 4.5;
//    self.contentViewInPortraitOffsetCenterX = 100;

 
    
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];
    self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenuViewController"];
}
- (instancetype)init{
    self = [super init];
    self.parallaxEnabled = NO;
    //    self.scaleContentView = YES;
    self.scaleContentView = NO;
    self.contentViewScaleValue = 0.95;
    self.scaleMenuView = NO;
    self.contentViewShadowEnabled = YES;
    self.contentViewShadowRadius = 4.5;
    
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
    
    self.contentViewController = TabBarViewController.new;
    self.leftMenuViewController = SideMenuTableViewController.new;
    
    return self;
}




@end
