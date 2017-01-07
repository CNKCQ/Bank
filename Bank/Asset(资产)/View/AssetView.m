//
//  AssetView.m
//  Bank
//
//  Created by Jack on 16/1/6.
//  Copyright © 2016年 Jack. All rights reserved.
//

#import "AssetView.h"
@interface AssetView(){
    
}
@property (nonatomic, strong)UILabel *helloLabel;
@end

@implementation AssetView

+ (void)load{
    
}

+ (void)initialize{
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    _helloLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 200, 40)];
    _helloLabel.numberOfLines = 0;
    [self addSubview:self.helloLabel];
    _racButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 60, 100, 30)];
    _racButton.backgroundColor = [UIColor clearColor];
    [_racButton setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    [_racButton setTitle:@"RAC" forState:UIControlStateNormal];
    
    [self addSubview:_racButton];
    
    return self;
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    return self;
}

- (BOOL)canBecomeFocused{
    
    return YES;
}

//
//// Allows you to perform layout before the drawing cycle happens. -layoutIfNeeded forces layout early
- (void)setNeedsLayout{
    [super setNeedsLayout];
    [self reload];
}
- (void)layoutIfNeeded{
    [super layoutIfNeeded];
    
}
//
- (void)layoutSubviews{
    [super layoutSubviews];
    [self reload];

    
}
//- (void)layoutMarginsDidChange
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
}

- (void)setNeedsDisplay{
    [super setNeedsDisplay];
}
- (void)setNeedsDisplayInRect:(CGRect)rect{
    [super setNeedsDisplayInRect:rect];
}

- (void)reload{
    self.helloLabel.text = self.ttext;
    
}

@end
