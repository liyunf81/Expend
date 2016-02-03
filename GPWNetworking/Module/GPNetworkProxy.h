//
//  GPNetworkProxy.h
//  GPWNetworking
//
//  Created by Angle on 15/9/15.
//  Copyright © 2015年 Feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPURLResponse.h"

typedef void(^GPNetworkCallBack)(GPURLResponse* response);

@interface GPNetworkProxy : NSObject

+ (instancetype)shareInstance;

/**
 *  调用Get网络请求
 *
 *  @param params     请求参数
 *  @param methodName 请求方法名
 *  @param success    成功后的回调，用于派发消息
 *  @param fial       失败的回调
 *
 *  @return 请求id
 */
- (NSInteger)invokingGETWithParams:(NSDictionary *)params
                        methodName:(NSString *)methodName
                       serviceName:(NSString *)serviceName
                            success:(GPNetworkCallBack)success
                              fail:(GPNetworkCallBack)fail;


/**
 *  调用post网络请求
 *
 *  @param params     参数
 *  @param methodName 方法名字
 *  @param success    成功的回调
 *  @param fail       失败的回调
 *
 */
- (NSInteger)invokingPOSTWithParams:(NSDictionary *)params
                         methodName:(NSString *)methodName
                        serviceName:(NSString *)serviceName
                            success:(GPNetworkCallBack)success
                               fail:(GPNetworkCallBack)fail;

- (NSInteger)invokingPOSTWithParams:(NSDictionary *)params
                         methodName:(NSString *)methodName
                        serviceName:(NSString *)serviceName
                           postData:(NSData *)postData
                       postDataName:(NSString *)postDataName
                            success:(GPNetworkCallBack)success
                               fail:(GPNetworkCallBack)fail;

- (NSInteger)invokingRestfulGETWithParams:(NSDictionary *)params
                               methodName:(NSString *)methodName
                                  success:(GPNetworkCallBack)success
                                     fail:(GPNetworkCallBack)fail;

- (NSInteger)invokingRestfulPOSTWithParams:(NSDictionary *)params
                                methodName:(NSString *)methodName
                                   success:(GPNetworkCallBack)success
                                      fail:(GPNetworkCallBack)fail;

/**
 *  取消请求
 *
 *  @param requestID 请求id
 */
- (void)cancelRequestWithRequestID:(NSInteger)requestID;

/**
 *  取消请求
 *
 *  @param requestIDList 请求id列表
 */
- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList;

@end
