//
//  DataSource.h
//  Bank
//
//  Created by Jack on 16/1/25.
//  Copyright © 2016年 Jack. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^CellSelectedBlock)(id obj);
typedef void (^TableViewScrollBlock)(CGFloat obj);

@interface DataSource : NSObject <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) NSArray *cellIdentifiers;
@property (nonatomic, copy) NSArray *serverData;
@property (nonatomic, copy) CellSelectedBlock selectBlock;
@property (nonatomic, copy) TableViewScrollBlock scrollBlock;

- (instancetype)initWithServerData:(NSArray *)serverData cellIdentifiers:(NSArray *)cellIdentifiers;

@end
