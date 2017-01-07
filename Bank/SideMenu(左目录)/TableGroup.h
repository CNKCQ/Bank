//
//  TableGroup.h
//  Bank
//
//  Created by Jack on 15/12/15.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableGroup : NSObject

@property (nonatomic, copy) NSString *header;

@property (nonatomic, strong) NSArray *items;

@property (nonatomic, copy) NSString *footer;

@end
