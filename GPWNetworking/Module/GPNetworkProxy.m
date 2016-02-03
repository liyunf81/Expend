//
//  GPNetworkProxy.m
//  GPWNetworking
//
//  Created by Angle on 15/9/15.
//  Copyright © 2015年 Feng. All rights reserved.
//
#import <AFNetworking/AFNetworking.h>

#import "GPNetworkProxy.h"
#import "GPRequestCreator.h"
#import "GPLogger.h"
#import "NSURLRequest+GPNetworkingMethods.h"

@interface GPNetworkProxy ()

@property (nonatomic, strong) NSMutableDictionary* dispatchDic;
@property (nonatomic, strong) NSNumber* recordedRequestID;
@property (nonatomic, strong) GPRequestCreator* requestCreator;

@property (nonatomic, strong) AFHTTPRequestOperationManager* httpOperationManager;
@end

@implementation GPNetworkProxy
#pragma mark - 生命周期
+ (instancetype)shareInstance
{
    static dispatch_once_t dpOnce;
    static GPNetworkProxy* instance;
    dispatch_once(&dpOnce, ^{
        instance = [[GPNetworkProxy alloc] init];
    });
    return instance;
}

#pragma mark - 公共方法
- (NSInteger)invokingGETWithParams:(NSDictionary *)params methodName:(NSString *)methodName serviceName:(NSString *)serviceName success:(GPNetworkCallBack)success fail:(GPNetworkCallBack)fail
{
    NSURLRequest* request = [self.requestCreator generateGETRequestWithRequestParams:params methodName:methodName serviceName:serviceName ];
    NSNumber* requestID = [self invokingApiWithRequest:request success:success fail:fail];
    return [requestID integerValue];
}


- (NSInteger)invokingPOSTWithParams:(NSDictionary *)params methodName:(NSString *)methodName serviceName:(NSString *)serviceName success:(GPNetworkCallBack)success fail:(GPNetworkCallBack)fail
{
    NSURLRequest* request = [self.requestCreator generatePOSTRequestWithRequestParams:params methodName:methodName serviceName:serviceName];
    NSNumber* requestID = [self invokingApiWithRequest:request success:success fail:fail];
    return [requestID integerValue];
}

- (NSInteger)invokingPOSTWithParams:(NSDictionary *)params methodName:(NSString *)methodName serviceName:(NSString *)serviceName postData:(NSData *)postData postDataName:(NSString *)postDataName success:(GPNetworkCallBack)success fail:(GPNetworkCallBack)fail
{
    NSURLRequest* request = [self.requestCreator generatePOSTRequestWithRequestParams:params methodName:methodName serviceName:serviceName postData:postData postDataName:postDataName];
    NSNumber* requestID = [self invokingApiWithRequest:request success:success fail:fail];
    return [requestID integerValue];
}

- (void)cancelRequestWithRequestID:(NSInteger)requestID
{
    NSOperation* requestOperation = self.dispatchDic[@(requestID)];
    [requestOperation cancel];
    [self.dispatchDic removeObjectForKey:requestOperation];
}

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList
{
    for (NSNumber *requestID  in  requestIDList) {
        [self cancelRequestWithRequestID:[requestID integerValue]];
    }
}


#pragma mark -私有方法
/**
 *  调用网络请求,此处的意义在于，对AFNetworking进行了一次封装，防止以后修改库
 *
 *  @param request 请求体
 *  @param success 请求成功后的调用
 *  @param fail    失败的调用
 *
 *  @return 返回请求号
 */
- (NSNumber *)invokingApiWithRequest:(NSURLRequest *)request success:(GPNetworkCallBack)success fail:(GPNetworkCallBack)fail
{
    NSNumber* requestID = [self generateRequestID];
    AFHTTPRequestOperation* httpRequestOperation = [self.httpOperationManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        AFHTTPRequestOperation *storedOperation = self.dispatchDic[requestID];
        if (!storedOperation) {
            /**
             *  这里表示请求操作已经被cancel了。那就不需要继续处理了
             */
            return;
        }else
        {
            [self.dispatchDic removeObjectForKey:requestID];
        }
        
        [GPLogger logDebugInfoWithResponse:operation.response
                            responseString:operation.responseString
                                   request:operation.request
                                     error:NULL];
        GPURLResponse* response = [[GPURLResponse alloc] initWithResponseString:operation.responseString
                                                                      requestID:requestID
                                                                        request:operation.request
                                                                   responseData:operation.responseData status:GPURLResponseStatusSucess];
        if (success) {
            success(response);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        AFHTTPRequestOperation* storedOperation = self.dispatchDic[requestID];
        if (!storedOperation) {
            return ;
        }else
        {
            [self.dispatchDic removeObjectForKey:requestID];
        }
        
        [GPLogger logDebugInfoWithResponse:operation.response
                            responseString:operation.responseString
                                   request:operation.request
                                     error:error];
        GPURLResponse* response = [[GPURLResponse alloc] initWithResponseString:operation.responseString
                                                                      requestID:requestID
                                                                        request:operation.request
                                                                   responseData:operation.responseData
                                                                          error:error];
        if (fail) {
            fail(response);
        }
    }];
    
    self.dispatchDic[requestID] = httpRequestOperation;
    [[self.httpOperationManager operationQueue] addOperation:httpRequestOperation];
    return requestID;
}

- (NSNumber *)generateRequestID
{
    if (!_recordedRequestID) {
        _recordedRequestID = @1;
    }else
    {
        if ([_recordedRequestID integerValue] >= NSIntegerMax) {
            _recordedRequestID = @1;
        }else
        {
            _recordedRequestID = @([_recordedRequestID integerValue] + 1);
        }
    }
    return _recordedRequestID;
}

#pragma mark - 设置，获取方法
- (NSMutableDictionary *)dispatchDic
{
    if (!_dispatchDic) {
        _dispatchDic = [[NSMutableDictionary alloc] init];
    }
    return _dispatchDic;
}

- (AFHTTPRequestOperationManager *)httpOperationManager
{
    if (!_httpOperationManager) {
        _httpOperationManager = [[AFHTTPRequestOperationManager alloc] init];
        _httpOperationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _httpOperationManager;
}

- (GPRequestCreator *)requestCreator
{
    if (!_requestCreator) {
        _requestCreator = [[GPRequestCreator alloc] init];
    }
    return _requestCreator;
}

@end
