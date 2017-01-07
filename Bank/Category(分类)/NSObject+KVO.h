//
//  NSObject+KVO.h
//  Bank
//
//  Created by Jack on 16/1/22.
//  Copyright © 2016年 Jack. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ObservingBlock)(id observedObject, NSString *observedKey, id oldValue, id newValue);

@interface NSObject (KVO)

- (void)addObserver:(NSObject *)observer forKey:(NSString *)key withBlock:(ObservingBlock)block;

- (void)removeObserver:(NSObject *)observer forKey:(NSString *)key;

@end
