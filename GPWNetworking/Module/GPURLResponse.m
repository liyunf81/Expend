//
//  GPURLResponse.m
//  GPWNetworking
//
//  Created by Angle on 15/9/15.
//  Copyright © 2015年 Feng. All rights reserved.
//

#import "GPURLResponse.h"
#import "NSURLRequest+GPNetworkingMethods.h"

@interface GPURLResponse ()

@property (nonatomic, assign, readwrite) GPURLResponseStatus status; //请求状态
@property (nonatomic, copy,   readwrite) NSString* contentString; //内容字符串
@property (nonatomic, copy,   readwrite) id content; //因为不知道具体内容是什么，所以用id
@property (nonatomic, copy,   readwrite) NSURLRequest* request; //请求
@property (nonatomic, copy,   readwrite) NSData* responseData; //响应元数据
@property (nonatomic, assign, readwrite) BOOL isCache; //是否缓存了

@end

@implementation GPURLResponse
#pragma mark - 生命周期

- (instancetype)initWithResponseString:(NSString *)responseString requestID:(NSNumber *)requestID request:(NSURLRequest *)request responseData:(NSData *)responseData status:(GPURLResponseStatus)status
{
    self = [super init];
    if (self) {
        self.contentString = responseString;
        if (responseData) {
            self.content = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
        }

        self.status  = status;
        self.requestID = [requestID integerValue];
        self.request = request;
        self.responseData = responseData;
        self.requestParams = request.requestParams;
        self.isCache = NO;
    }
    return self;
}

- (instancetype)initWithResponseString:(NSString *)responseString requestID:(NSNumber *)requestID request:(NSURLRequest *)request responseData:(NSData *)responseData error:(NSError *)error
{
    return [self initWithResponseString:responseString
                              requestID:requestID
                                request:request
                           responseData:responseData
                                 status:[self responseStatusWithError:error]];
}

- (instancetype)initWIthData:(NSData *)data
{
    self = [self initWithResponseString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]
                              requestID:@0
                                request:nil
                           responseData:data
                                 status:[self responseStatusWithError:nil]];
    if (self) {
        self.isCache = YES;
    }
    return self;
}

#pragma mark - 私有方法
- (GPURLResponseStatus)responseStatusWithError:(NSError *)error
{
    GPURLResponseStatus status = GPURLResponseStatusSucess; //默认成功
    if (error) {
        status = GPURLResponseStatusErrorNoNetWork;
        if (error.code == NSURLErrorTimedOut) {
            status = GPURLResponseStatusErrorTimeOut;
        }
    }
    return status;
}


@end
