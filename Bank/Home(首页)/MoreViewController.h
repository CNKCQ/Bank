//
//  MoreViewController.h
//  Bank
//
//  Created by Jack on 15/12/26.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreViewController : UIViewController

@property (nonatomic, strong)NSMutableArray *moreApps;

@property (nonatomic, copy) void (^gridViewBlock)(NSString *string);

- (void)reloadGridView;
@end
