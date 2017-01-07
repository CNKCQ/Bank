//
//  appView.m
//  Bank
//
//  Created by Jack on 15/12/26.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import "AppView.h"
#import "UIImage+ImageWithColor.h"


@implementation AppView


- (id)initWithFrame:(CGRect)frame icon:(UIImage*)icon title:(NSString*)title
{
    if (self = [super initWithFrame:frame])
    {
        _normalImage = [UIImage imageWithColor1x1:[UIColor whiteColor]];
        _highlightedImage = [UIImage imageWithColor1x1:[UIColor colorWithWhite:0.8 alpha:1.0]];
        
        _backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundView.image = _normalImage;
        [self addSubview:_backgroundView];
        
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - 32) / 2, 20, 32, 32)];
        _iconView.image = icon;
        [self addSubview:_iconView];
        
        _titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, _iconView.frame.size.height + 20, frame.size.width, 40)];
        _titleView.text = title;
        _titleView.backgroundColor = [UIColor clearColor];
        _titleView.textAlignment = NSTextAlignmentCenter;
        _titleView.font = [UIFont systemFontOfSize:14];
        [self addSubview:_titleView];
        
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = self.bounds;
        _btn.backgroundColor = [UIColor clearColor];
        [_btn addTarget:self action:@selector(didButtonDown:) forControlEvents:UIControlEventTouchDown];
        [_btn addTarget:self action:@selector(didButtonUp:) forControlEvents:UIControlEventTouchUpInside];
        [_btn addTarget:self action:@selector(didButtonDragCancel:) forControlEvents:UIControlEventTouchUpOutside];
        [_btn addTarget:self action:@selector(didButtonDragCancel:) forControlEvents:UIControlEventTouchCancel];
        UILongPressGestureRecognizer* _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(beginEdit:)];
        [_btn addGestureRecognizer:_longPressGesture];
        [self addSubview:_btn];
    }
    return self;
}

- (void)beginEdit:(UILongPressGestureRecognizer *)sender{
    if (_pressDelegate && [_pressDelegate respondsToSelector:@selector(appView:didLongPressing:)]) {
        [_pressDelegate appView:self didLongPressing:sender];
    }
}

- (void)didButtonDragCancel:(id)sender
{
    [_backgroundView setImage:_normalImage];
}

- (void)didButtonDown:(id)sender
{
    [_backgroundView setImage:_highlightedImage];
}

- (void)didButtonUp:(id)sender
{
    [_backgroundView setImage:_normalImage];
    if (_delegate && [_delegate respondsToSelector:@selector(onTap:)])
    {
        [_delegate onTap:self];
    }
}

- (void)setNormalImage:(UIImage *)normalImage
{
    _normalImage = normalImage;
    [_backgroundView setImage:normalImage];
}

@end

