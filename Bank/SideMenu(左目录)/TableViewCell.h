//
//  TableViewCell.h
//  Bank
//
//  Created by Jack on 15/12/15.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CellItem;

@interface TableViewCell : UITableViewCell
@property (nonatomic, strong)CellItem *item;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
