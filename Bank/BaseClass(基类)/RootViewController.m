//
//  ViewController.m
//  Bank
//
//  Created by Jack on 15/12/3.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import "RootViewController.h"


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


@end
