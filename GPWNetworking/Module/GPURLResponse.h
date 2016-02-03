//
//  GPURLResponse.h
//  GPWNetworking
//
//  Created by Angle on 15/9/15.
//  Copyright © 2015年 Feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPNetworkingConfigure.h"

/**
 *  请求相应对象，包含一些原始数据以及请求参数
 */
@interface GPURLResponse : NSObject

@property (nonatomic, assign, readonly) GPURLResponseStatus status; //请求状态
@property (nonatomic, copy,   readonly) NSString* contentString; //内容字符串
@property (nonatomic, copy,   readonly) id content; //因为不知道具体内容是什么，所以用id
@property (nonatomic, assign, readwrite) NSInteger requestID; //每个请求的一个ID方便查找以及缓存，取消
@property (nonatomic, copy,   readonly) NSURLRequest* request; //请求
@property (nonatomic, copy,   readonly) NSData* responseData; //响应元数据
@property (nonatomic, copy,   readwrite) NSDictionary* requestParams; //请求参数
@property (nonatomic, assign, readonly) BOOL isCache; //是否缓存了

/**
 *  初始化Response对象
 *
 *  @param responseString 响应的字符串
 *  @param requestID      请求id
 *  @param request        请求体
 *  @param responseData   相应原数据
 *  @param status         状态
 *
 *  @return 返回当前对象
 */
- (instancetype)initWithResponseString:(NSString *)responseString
                             requestID:(NSNumber *)requestID
                               request:(NSURLRequest *)request
                          responseData:(NSData *)responseData
                                status:(GPURLResponseStatus) status;

/**
 *  初始化response对象
 *
 *  @param responseString 响应字符串
 *  @param requestID      请求id
 *  @param request        请求体
 *  @param responseData   相应数据
 *  @param error          失败
 *
 *  @return 返回对象
 */
- (instancetype)initWithResponseString:(NSString *)responseString
                             requestID:(NSNumber *)requestID
                               request:(NSURLRequest *)request
                          responseData:(NSData *)responseData
                                 error:(NSError *)error;

/**
 *  初始化responese
 *
 *  @param data 响应原数据
 *
 *  @return 对象
 */
- (instancetype)initWIthData:(NSData *)data;

@end
