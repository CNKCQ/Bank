//
//  UIViewController+Swizzling.m
//  Bank
//
//  Created by Jack on 16/1/22.
//  Copyright © 2016年 Jack. All rights reserved.
//

#import "UIViewController+Swizzling.h"
#import <objc/runtime.h>

@implementation UIViewController (Swizzling)
+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = [self class];
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzleSelector = @selector(swizzle_viewWillAppear:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzleMethod = class_getInstanceMethod(class, swizzleSelector);
        
        
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class, swizzleSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
            
        }else{
            method_exchangeImplementations(originalMethod, swizzleMethod);
            
        }
        
        
    });
}

- (void)swizzle_viewWillAppear:(BOOL)animated {
    [self swizzle_viewWillAppear:animated];
//    NSLog(@"viewWillAppear: %@", NSStringFromClass([self class]));
//    if ([NSStringFromClass([self class]) containsString:@"UI"] ) return;
// 
//    
//    NSLog(@"第次点击 %@ %@",NSStringFromClass([self class]),self.title);

}



@end
