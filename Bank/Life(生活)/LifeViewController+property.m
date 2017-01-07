//
//  LifeViewController+property.m
//  Bank
//
//  Created by Jack on 16/1/28.
//  Copyright © 2016年 Jack. All rights reserved.
//

#import "LifeViewController+property.h"
#import <objc/runtime.h>

@implementation LifeViewController (property)

static char strAddKey = 'y';

- (void)setOwner:(NSString *)owner{
    objc_setAssociatedObject(self, &strAddKey, owner, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)owner{
    return objc_getAssociatedObject(self, &strAddKey);
}

@end
