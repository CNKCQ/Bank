//
//  UIImage+ImageWithColor.h
//  Demo

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (ImageWithColor)

+ (UIImage *)imageWithColor1x1:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end
