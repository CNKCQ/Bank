//
//  CellItem.h
//  Bank
//
//  Created by Jack on 15/12/15.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^CellItemOption)();

@interface CellItem : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *subTitle;

// 保存一段功能，在恰当的时候调用
@property (nonatomic, copy) CellItemOption option;


+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title;
@end
