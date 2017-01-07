//
//  HomeMenuCell.m
//  Bank
//
//  Created by jack on 15/6/30.
//  Copyright (c) 2015年 jack All rights reserved.
//

#import "HomeMenuCell.h"

@interface HomeMenuCell ()<UIScrollViewDelegate>
{
    UIPageControl *_pageControl;
}

@end

@implementation HomeMenuCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier menuArray:(NSMutableArray *)menuArray{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 180)];
        
        double cols = 4;
        double rows = 2;
        double itemCount = cols * rows;
        CGFloat itemHeight = (CGRectGetHeight(scrollView.frame)-20)/rows;
        int page = ceil(menuArray.count/itemCount);
        for (int i = 0; i < page; i++) {
            UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(WIDTH * i, 0, WIDTH, 160)];
            backView.backgroundColor = UIColor.whiteColor;
            backView.tag = 999+i;
            [scrollView addSubview:backView];
            for (int j = 0; j < rows; j++) {
                
                for (int n = 0; n < cols; n++) {
                    int index = i * itemCount + j * cols + n;
                    if (index < menuArray.count) {
                        CGRect frame = CGRectMake(n*WIDTH/(itemCount/rows), j * itemHeight, WIDTH/cols, itemHeight);
                        NSString *title = [menuArray[index] objectForKey:@"title"];
                        NSString *imageStr = [menuArray[index] objectForKey:@"image"];
                        JZMTBtnView *btnView = [[JZMTBtnView alloc] initWithFrame:frame title:title imageStr:imageStr];
                        btnView.clipsToBounds = YES;
                        btnView.tag = index;
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBtnView:)];
                        [btnView addGestureRecognizer:tap];
                        [backView addSubview:btnView];
                    }

                }
                

            }
            
            
        }
        scrollView.contentSize = CGSizeMake(page*WIDTH, 180);
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(WIDTH/2-20, 160, 0, 20)];
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = page;
        [self addSubview:_pageControl];
        [_pageControl setCurrentPageIndicatorTintColor:UIColor.greenColor];
        [_pageControl setPageIndicatorTintColor:[UIColor grayColor]];
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}


- (void)OnTapBtnView:(UITapGestureRecognizer *)sender{
       NSInteger index = sender.view.tag;
    if ([self.menuDelegate respondsToSelector:@selector(menueCell:didSelectItemAtIndex:)]) {
        [self.menuDelegate menueCell:self didSelectItemAtIndex:index];
        
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollViewW/2)/scrollViewW;
    _pageControl.currentPage = page;
}


@end
