//
//  GPRequestCreator.m
//  GPWNetworking
//
//  Created by Angle on 15/9/15.
//  Copyright © 2015年 Feng. All rights reserved.
//

#import "GPRequestCreator.h"
#import "GPCommonParamsCreator.h"
#import "NSDictionary+GPNetworkingMethods.h"
#import "GPNetworkingConfigure.h"
#import "GPLogger.h"
#import "NSURLRequest+GPNetworkingMethods.h"
#import <AFNetworking/AFNetworking.h>
#import "GPServiceBase.h"
#import "GPServiceFactor.h"


@interface GPRequestCreator ()

@property (nonatomic, strong) AFHTTPRequestSerializer* httpRequestSerializer;

@end

@implementation GPRequestCreator

#pragma mark - 公共方法

- (NSURLRequest *)generateGETRequestWithRequestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName serviceName:(NSString *)serviceName
{
    NSMutableDictionary* allParams = [NSMutableDictionary dictionaryWithDictionary:[GPCommonParamsCreator commonParamsDictionary]];
    [allParams addEntriesFromDictionary:requestParams];
    GPServiceBase* service = [GPServiceFactor createService:serviceName];
    NSString *urlString = [NSString stringWithFormat:@"%@/%@?%@",[service baseUrl],methodName,[allParams GPUrlParamsString]];
    
    NSMutableURLRequest* request = [self.httpRequestSerializer requestWithMethod:@"GET" URLString:urlString parameters:nil error:nil];
    request.timeoutInterval = kGPNetworkingTimeoutSeconds;
    request.requestParams = requestParams;
    [GPLogger logDebugInfoWithRequest:request apiName:methodName requestParams:requestParams httpMethod:@"GET"];
    return request;
}

- (NSURLRequest *)generatePOSTRequestWithRequestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName serviceName:(NSString *)serviceName
{
    GPServiceBase* service = [GPServiceFactor createService:serviceName];
    NSString* urlString = [NSString stringWithFormat:@"%@/%@/%@",[service baseUrl],methodName,[[GPCommonParamsCreator commonParamsDictionary] GPUrlParamsString]];
    NSURLRequest* request = [self.httpRequestSerializer requestWithMethod:@"POST"
                                                                URLString:urlString
                                                               parameters:requestParams
                                                                    error:NULL
                             ];
    request.requestParams = requestParams;
    [GPLogger logDebugInfoWithRequest:request apiName:methodName requestParams:requestParams httpMethod:@"POST"];
    return request;
}

- (NSURLRequest *)generatePOSTRequestWithRequestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName serviceName:(NSString *)serviceName postData:(NSData *)postData postDataName:(NSString *)postDataName
{
    GPServiceBase* service = [GPServiceFactor createService:serviceName];
    NSString* urlString = [NSString stringWithFormat:@"%@/%@/%@",[service baseUrl],methodName,[[GPCommonParamsCreator commonParamsDictionary] GPUrlParamsString]];
    NSURLRequest* request = nil;
    if (postData && postDataName) {
        request = [self.httpRequestSerializer multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:requestParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFormData:postData name:postDataName];

        } error:nil];
    }else
    {
        request = [self.httpRequestSerializer requestWithMethod:@"POST"
                                                      URLString:urlString
                                                     parameters:requestParams
                                                          error:NULL
                   ];
    }
    request.requestParams = requestParams;
    [GPLogger logDebugInfoWithRequest:request apiName:methodName requestParams:requestParams httpMethod:@"POST"];
    return request;
}

#pragma mark - 设置，获取方法
- (AFHTTPRequestSerializer *)httpRequestSerializer
{
    if (!_httpRequestSerializer) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        _httpRequestSerializer.timeoutInterval = kGPNetworkingTimeoutSeconds;
        _httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _httpRequestSerializer;
}

@end
