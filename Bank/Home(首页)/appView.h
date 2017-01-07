//
//  appView.h
//  Bank
//
//  Created by Jack on 15/12/26.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>



@class AppView;

@protocol AppViewDelegate <NSObject>

@optional
- (void)onTap:(AppView*)sender;

@end
@protocol AppViewActionDelegate <NSObject>

@optional
- (void)appView:(AppView *)appView didLongPressing:(UILongPressGestureRecognizer *)longPress;

@end

@interface AppView : UIView
{
    UIImageView* _iconView;
    UILabel* _titleView;
    
    UIImageView* _backgroundView;
    UIImage* _normalImage;
    UIImage* _highlightedImage;
    UIView* _disableView;
    UIButton *_btn;
}

@property (nonatomic, weak) id<AppViewDelegate> delegate;
@property (nonatomic, weak) id<AppViewActionDelegate> pressDelegate;
@property (nonatomic, strong) NSString* appId;
- (id)initWithFrame:(CGRect)frame icon:(UIImage*)icon title:(NSString*)title;
@end