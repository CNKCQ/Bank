//
//  NetworkPort.h
//  MVPlayer
//
//  Created by Jack on 15/10/3.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sigleton.h"

@interface NetworkPort : NSObject


DEF_SIGLETON(NetworkPort)

/**
 *  GET网络请求
 *
 *  @param url              请求路径
 *  @param params           请求参数
 *  @param successOperation 请求成功
 *  @param failureOperation 请求失败
 */
- (void)GETRequestWithURL:(NSString *)url parameters:(NSMutableDictionary *)params success:(void(^)(id data))successOperation failure:(void(^)(NSError *error))failureOperation;
/**
 *  POST网络请求
 *
 *  @param url              请求路径
 *  @param params           请求参数
 *  @param successOperation 请求成功
 *  @param failureOperation 请求失败
 */
- (void)POSTRequestWithURL:(NSString *)url parameters:(NSMutableDictionary *)params success:(void(^)(id data))successOperation failure:(void(^)(NSError *error))failureOperation;

/**
 *  下载图片缓存到本地
 *
 *  @param folder      文件夹路径
 *  @param requestUrl    请求路径
 *  @param imageName     下载对象
 *  @param successHandle 请求成功
 *  @param failureHandle 请求失败
 */
- (void)downloadPictures:(NSString *)folder withRequestUrl:(NSString *)requestUrl  imageName:(NSString *)imageName  success:(void (^)(id data))successOperation failure:(void (^)(NSError * error))failureOperation;
/**
 *  检测网络连接
 *
 *  @return 返回网络连接状态
 */
- (BOOL)isInternetConnectionAvailable;

@end
