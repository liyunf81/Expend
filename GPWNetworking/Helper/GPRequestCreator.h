//
//  GPRequestCreator.h
//  GPWNetworking
//
//  Created by Angle on 15/9/15.
//  Copyright © 2015年 Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPRequestCreator : NSObject

/**
 *  创建Get请求体
 *
 *  @param requestParams 请求参数
 *  @param methodName    方法
 *
 *  @return 返回请求体
 */
- (NSURLRequest *)generateGETRequestWithRequestParams:(NSDictionary *)requestParams
                                          methodName:(NSString *)methodName
                                          serviceName:(NSString *)serviceName;
/**
 *  创建post请求体
 *
 *  @param requestParams 请求参数
 *  @param methodName    请求方法名
 *
 *  @return 返回请求体
 */

- (NSURLRequest *)generatePOSTRequestWithRequestParams:(NSDictionary *)requestParams
                                            methodName:(NSString *)methodName
                                           serviceName:(NSString *)serviceName;

- (NSURLRequest *)generatePOSTRequestWithRequestParams:(NSDictionary *)requestParams
                                            methodName:(NSString *)methodName
                                           serviceName:(NSString *)serviceName
                                               postData:(NSData *)postData
                                          postDataName:(NSString*)postDataName;

- (NSURLRequest *)generateRestfulGETRequestWithRequestParams:(NSDictionary *)requestParams
                                                  methodName:(NSString *)methodName;

- (NSURLRequest *)generateRestfulPOSTRequestWithRequestParams:(NSDictionary *)requestParams
                                                   methodName:(NSString *)methodName;
@end
