//
//  DataManager.h
//  Bank
//
//  Created by Jack on 16/1/25.
//  Copyright © 2016年 Jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject
/**
 *  返回第page页的中的数据:page从1开始
 */
+ (NSArray *)objectDeals:(int)page;

+ (int)objectCount;
/**
 *  添加
 */
+ (void)addObject:(NSObject *)obj;
/**
 *  删除
 */
+ (void)removeObject:(NSObject *)obj;
/**
 *  是否选中
 */
+ (BOOL)isSelected:(NSObject *)obj;

@end
