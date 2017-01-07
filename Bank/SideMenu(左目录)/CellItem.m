//
//  CellItem.m
//  Bank
//
//  Created by Jack on 15/12/15.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import "CellItem.h"

@implementation CellItem

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title
{
    CellItem *item = [[self alloc] init];
    
    item.icon = icon;
    item.title = title;
    
    return item;
}

@end
