//
//  UITableViewCell+config.m
//  Bank
//
//  Created by Jack on 16/1/25.
//  Copyright © 2016年 Jack. All rights reserved.
//

#import "UITableViewCell+config.h"

@implementation UITableViewCell (config)
- (void)configWithModel:(id)model{
    self.textLabel.text = model;
}
@end
