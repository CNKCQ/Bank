//
//  AssetView.h
//  Bank
//
//  Created by Jack on 16/1/6.
//  Copyright © 2016年 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetView : UIView

@property (nonatomic, copy)NSString *ttext;
@property (nonatomic, strong)UIButton *racButton;

- (void)reload;
@end
