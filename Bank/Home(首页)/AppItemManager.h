//
//  AppItemManager.h
//  Bank
//
//  Created by Jack on 16/1/13.
//  Copyright © 2016年 Jack. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface AppItem: NSObject <NSCopying, NSCoding>
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic,assign,getter=isSelected) BOOL selected;
@end
@interface AppItemManager : NSObject

@property (readonly, nonatomic) NSInteger numberOfSelectedAppItems;

/**缺省值*/
+ (instancetype)defaultManager;
/**微应用*/
- (NSArray *)appItems;
/**微应用排序*/
- (void)moveAppItemFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;
/**缓存应用数据*/
- (void)svaeToDisk;

@end
