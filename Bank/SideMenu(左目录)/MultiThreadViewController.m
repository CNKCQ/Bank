//
//  MultiThreadViewController.m
//  Bank
//
//  Created by Jack on 16/2/23.
//  Copyright © 2016年 Jack. All rights reserved.
//

#import "MultiThreadViewController.h"


@implementation MultiThreadViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //获取图片的url
    NSURL *url = [NSURL URLWithString:@""];
    
    dispatch_queue_t queueConcurrent = dispatch_queue_create("queue1", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_queue_t queueSerial = dispatch_queue_create("queueSerial", DISPATCH_QUEUE_SERIAL);
    
    dispatch_queue_t queueMain = dispatch_get_main_queue();
    
    
    
    dispatch_sync(queueSerial, ^{
        for (NSInteger i = 0; i < 10; i ++) {
            NSLog(@"~~~~%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queueConcurrent, ^{
        for (NSInteger i = 0; i < 10; i ++) {
            NSLog(@"~~~~%@",[NSThread currentThread]);
        }

    });
    dispatch_async(queueSerial, ^{
        for (NSInteger i = 0; i < 10; i ++) {
            NSLog(@"asy~~~~%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queueConcurrent, ^{
        for (NSInteger i = 0; i < 10; i ++) {
            NSLog(@"asy~~~~%@",[NSThread currentThread]);
        }
        
    });

    
}

@end
