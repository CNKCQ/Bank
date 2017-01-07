//
//  DataManager.m
//  Bank
//
//  Created by Jack on 16/1/25.
//  Copyright © 2016年 Jack. All rights reserved.
//

#import "DataManager.h"
#import "FMDB.h"


static FMDatabase *_db;

@implementation DataManager
+ (void)initialize{
    // 1.打开数据库
    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"object.sqlite"];
    _db = [FMDatabase databaseWithPath:file];
    if (![_db open]) return;
    //2.创建表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_collect_object(id integer PRIMARY KEY, deal blob NOT NULL, deal_id text NOT NULL);"];
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_recent_object(id integer PRIMARY KEY, deal blob NOT NULL, deal_id text NOT NULL);"];
    
}
/*
*  返回第page页的中的数据:page从1开始
*/
+ (NSArray *)objectDeals:(int)page{
    int size = 20;
    int pos = (page - 1) * size;
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM t_collect_object ORDER BY id DESC LIMIT %d,%d",pos,size];
    while (set.next) {
//        NSKeyValueObservingOptionInitial
        
    }
    
    
    return [NSArray array];
}

+ (int)objectCount{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_collect_deal;"];
    [set next];
    return [set intForColumn:@"deal_count"];
}
/**
 *  添加
 */
+ (void)addObject:(NSObject *)obj{
    
}
/**
 *  删除
 */
+ (void)removeObject:(NSObject *)obj{
    
}
/**
 *  是否选中
 */
+ (BOOL)isSelected:(NSObject *)obj{
    return YES;
}
@end
