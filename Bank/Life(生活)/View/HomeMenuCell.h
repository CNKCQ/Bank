//
//  HomeMenuCell.m
//  Bank
//
//  Created by jack on 15/6/30.
//  Copyright (c) 2015年 jack All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZMTBtnView.h"
@class HomeMenuCell;
@protocol HomeMenuCellDelegate <NSObject>

@optional

- (void)menueCell:(HomeMenuCell *)cell didSelectItemAtIndex:(NSInteger)index;

@end

@interface HomeMenuCell : UITableViewCell

@property (nonatomic, assign)id<HomeMenuCellDelegate> menuDelegate;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier menuArray:(NSMutableArray *)menuArray;

@end
