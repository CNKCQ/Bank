//
//  Foundation+Extension.m
//  05-runtime
//
//  Created by apple on 14-8-21.
//  Copyright (c) 2014年 jack. All rights reserved.
//

#import <objc/runtime.h>
#import <Foundation/Foundation.h>

@implementation NSObject(Extension)
#ifdef DEBUG_MODULUS

#else
/**交换类方法*/
+ (void)swizzleClassMethod:(Class)class originSelector:(SEL)originSelector otherSelector:(SEL)otherSelector
{
    Method otherMehtod = class_getClassMethod(class, otherSelector);
    Method originMehtod = class_getClassMethod(class, originSelector);
    // 交换2个方法的实现
    method_exchangeImplementations(otherMehtod, originMehtod);
}
/**交换实例方法*/
+ (void)swizzleInstanceMethod:(Class)class originSelector:(SEL)originSelector otherSelector:(SEL)otherSelector
{
    Method otherMehtod = class_getInstanceMethod(class, otherSelector);
    Method originMehtod = class_getInstanceMethod(class, originSelector);
    // 交换2个方法的实现
    method_exchangeImplementations(otherMehtod, originMehtod);
}
@end

@implementation NSArray(Extension)
+ (void)load
{
    [self swizzleInstanceMethod:NSClassFromString(@"__NSArrayI") originSelector:@selector(objectAtIndex:) otherSelector:@selector(hook_objectAtIndex:)];
}

- (id)hook_objectAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        return [self hook_objectAtIndex:index];
    } else {
        return nil;
    }
}

@end

@implementation NSMutableArray(Extension)
+ (void)load
{
    [self swizzleInstanceMethod:NSClassFromString(@"__NSArrayM") originSelector:@selector(addObject:) otherSelector:@selector(hook_addObject:)];
    [self swizzleInstanceMethod:NSClassFromString(@"__NSArrayM") originSelector:@selector(objectAtIndex:) otherSelector:@selector(hook_objectAtIndex:)];
}

- (void)hook_addObject:(id)object
{
    if (object != nil) {
        [self hook_addObject:object];
    }
}

- (id)hook_objectAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        return [self hook_objectAtIndex:index];
    } else {
        return nil;
    }
}

#endif
@end