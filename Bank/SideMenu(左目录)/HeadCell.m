//
//  HeadCell.m
//  Bank
//
//  Created by Jack on 16/1/26.
//  Copyright © 2016年 Jack. All rights reserved.
//

#import "HeadCell.h"

@implementation HeadCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI{
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, WIDTH, 200)];
    headView.backgroundColor = [UIColor blueColor];
    [self addSubview:headView];
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}



@end
