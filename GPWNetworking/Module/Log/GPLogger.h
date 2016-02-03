//
//  GPLogger.h
//  GPWNetworking
//
//  Created by Angle on 15/9/15.
//  Copyright © 2015年 Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GPURLResponse;
@interface GPLogger : NSObject

+ (instancetype)shareInstance;

//帮助函数，主要用来打印服务器一些信息，比如表头，body等
+ (void)logDebugInfoWithRequest:(NSURLRequest *)request
                        apiName:(NSString *)apiName
                  requestParams:(id)requestParams
                     httpMethod:(NSString *)httpMethod;
+ (void)logDebugInfoWithResponse:(NSHTTPURLResponse *)response
                  responseString:(NSString *)responseString
                         request:(NSURLRequest *)request
                           error:(NSError *)error;
+ (void)logDebugInfoWithCachedResponse:(GPURLResponse *)response
                            methodName:(NSString *)methodName;

- (void)waringLog:(NSString *)msg;
- (void)infoLog:(NSString *)msg;
- (void)errorLog:(NSString *)msg;
- (void)serverLog:(NSString *)msg;

@end
