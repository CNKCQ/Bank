//
//  LaunchView.m
//  Bank
//
//  Created by Jack on 16/1/2.
//  Copyright © 2016年 Jack. All rights reserved.
//

#import "LaunchView.h"

@implementation LaunchView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    frame.size = [UIImage imageNamed:@"example.gif"].size;
    // 读取gif图片数据
    NSData *gif = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"example" ofType:@"gif"]];
    // view生成
    UIWebView *webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    webView.userInteractionEnabled = NO;//用户不可交互

    [webView loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    webView.scalesPageToFit = YES;
    [self addSubview:webView];

    return self;
}



@end
