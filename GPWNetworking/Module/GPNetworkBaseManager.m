//
//  GPNetworkBaseManager.m
//  GPWNetworking
//
//  Created by Angle on 15/9/15.
//  Copyright © 2015年 Feng. All rights reserved.
//

#import "GPNetworkBaseManager.h"
#import "GPLogger.h"
#import "GPNetworking.h"
#import "GPCacheManager.h"
#import "GPCacheObject.h"

@interface GPNetworkBaseManager ()

@property (nonatomic, strong, readwrite) id fetchedRawData;
@property (nonatomic, strong, readwrite) id contentData;
@property (nonatomic, copy,   readwrite) NSString* errorMessage;
@property (nonatomic, strong, readwrite) NSMutableArray* requestIDList;
@property (nonatomic, strong, readwrite) GPCacheManager* cache;
@property (nonatomic, assign, readwrite) NSInteger requestID;

@end

@implementation GPNetworkBaseManager
#pragma mark - 生命周期

- (instancetype)init
{
    self = [super init];
    if (self) {
        _requestDelegate = nil;
        _paramSource = nil;
        _validator = nil;
        _interceptor = nil;
        _errorMessage = nil;
        _errorType = GPNetworkErrorTypeDefault;
//        
//        if ([self.child conformsToProtocol:@protocol(GPNetworkManager)]) {
//            self.child = (id<GPNetworkManager>)self;
//        }else
//        {
//            NSAssert(NO, @"所有NetworkBaseManager 的子类都必须遵循GPNetworkManager");
//        }
    }
    return self;
}

/**
 *  取消所有网络请求，防止网络请求无法着陆
 */
- (void)dealloc
{
    [self cancelAllRequests];
    self.requestIDList = nil;
    self.requestID = 0;
}

#pragma mark - 公共方法
- (void)cancelAllRequests
{
    [[GPNetworkProxy shareInstance] cancelRequestWithRequestIDList:self.requestIDList];
    [self.requestIDList removeAllObjects];
}

- (void)cancelRequestWithRequestID:(NSInteger)requestID
{
    [[GPNetworkProxy shareInstance]cancelRequestWithRequestID:requestID];
    [self removeRequestId:requestID];
}

- (id)fetchDataWithRedefine:(id<GPNetworkResponseDataRedefine>)redefine
{
    id resultData = nil;
    if ([redefine respondsToSelector:@selector(manager:redefine:)])
    {
        resultData = [redefine manager:self redefine:self.fetchedRawData];
    }else
    {
        self.contentData = [NSJSONSerialization JSONObjectWithData:self.fetchedRawData options:NSJSONReadingMutableContainers error:NULL];
        resultData = [self.contentData mutableCopy];
    }
    return resultData;
}

- (NSInteger)loadData
{
    NSDictionary* params  = [self.paramSource requestParamsForManager:self];
    NSInteger requestID  = [self loadDataWithParams:params methodName:nil postData:nil postDataName:nil];
    return requestID;
}

- (NSInteger)loadDataWithParams:(NSDictionary *)params withMethodsName:(NSString *)methodName
{
    return [self loadDataWithParams:params methodName:methodName postData:nil postDataName:nil];
}

- (NSInteger)loadDataWithParams:(NSDictionary *)params withMethodsName:(NSString *)methodName postData:(NSData *)postData postDataName:(NSString *)postDataName
{
     return [self loadDataWithParams:params methodName:methodName postData:postData postDataName:postDataName];
}



#pragma mark - 子类所用方法
- (void)cleanData
{
    self.fetchedRawData = nil;
    self.errorMessage = nil;
    self.errorType = GPNetworkErrorTypeDefault;
}

- (NSString *)serviceName
{
    return nil;
}

- (NSDictionary *)redefineParams:(NSDictionary *)params
{
    return params;
}

- (BOOL)shouldCache
{
    return kGPShouldCache;
}

#pragma mark - 私有方法
- (void)removeRequestId:(NSInteger)requestID
{
    NSNumber* willToRemoveID = nil;
    for (NSNumber * number in self.requestIDList) {
        if ([number integerValue] == requestID) {
            willToRemoveID = number;
            break;
        }
    }
    if (willToRemoveID) {
        [self.requestIDList removeObject:willToRemoveID];
    }
}

- (NSInteger)loadDataWithParams:(NSDictionary *)params methodName:(NSString *)methodName postData:(NSData *)postData postDataName:(NSString *)postDataName
{
    NSInteger requestID = 0;
    NSDictionary* requestParams = [self redefineParams:params];
    //让拦截器判断是否进行网络请求
    if (![self shouldRequestWithParams:requestParams]) {
        return requestID;
    }
    
    //判断请求参数是否正确
    if ([self.validator respondsToSelector:@selector(manager:isCorrectWithRequestParams:)] &&
        ![self.validator manager:self isCorrectWithRequestParams:params]) {
        [self requestFailedCallBack:nil withErrorType:GPNetworkErrorTypeParamsError];
        return requestID;
    }
    
    //检查是否有缓存 ,暂时未用
//    requestID = [self hasCacheWithParams:params methodName:methodName];
//    if ([self.child respondsToSelector:@selector(shouldCache)]) {
//        if ([self.child shouldCache] && requestID != 0) {
//            return requestID;
//        }
//    }else if ([self shouldCache] && requestID != 0) {
//        return requestID;
//    }
    
    //监测网络是否可用
    if ([self isReachable]) {
        requestID = [self requestType:self.child.requestType params:requestParams methodName:methodName postData:postData postDataName:postDataName];
        
        NSMutableDictionary* params = [requestParams mutableCopy];
        params[kGPNetworkingRequestID] = @(requestID);
        [self doneRequestWithParams:params];
        self.requestID = requestID;
        return requestID;
    }else
    {
        [self requestFailedCallBack:nil withErrorType:GPNetworkErrorTypeNoNetWork];
        return requestID;
    }
  
    return requestID;
}

/**
 *  检测是否有缓存的请求
 *
 *  @param params 请求参数
 *
 *  @return 是否有缓存请求
 */
- (NSInteger)hasCacheWithParams:(NSDictionary *)params methodName:(NSString *)aMethodName
{
    NSString* methodName = aMethodName;
    GPCacheObject* result = [self.cache fetchCachedDataWithMethodName:methodName requestParams:params];
    if (!result) {
        return 0;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        GPURLResponse* response = [[GPURLResponse alloc] initWIthData:result.content];
        response.requestParams = params;
        response.requestID = result.requestID;
        [GPLogger logDebugInfoWithCachedResponse:response methodName:methodName];
        [self requestSucessedCallBack:response methodName:methodName];
    });
    return result.requestID;
}

- (void)requestSucessedCallBack:(GPURLResponse *)response methodName:(NSString *)methodName
{
//    if (response.content) {
//        self.fetchedRawData = [response.content copy];
//    }else
//    {
//        self.fetchedRawData = [response.responseData copy];
//    }
    
    self.fetchedRawData = [response.responseData copy];
    [self removeRequestId:response.requestID];
    //检测数据是否正确
    
    if ([self.validator respondsToSelector:@selector(manager:isCorrectWithResponseData:)] && ![self.validator manager:self isCorrectWithResponseData:self.fetchedRawData]) {
        [self requestFailedCallBack:response withErrorType:GPNetworkErrorTypeNoContent];
        return;
    }
    
    //判断是否应该缓存，
    if (kGPShouldCache && !response.isCache) {
        [self.cache saveCacheWithData:self.fetchedRawData
                           methodName:methodName
                        requestParams:response.requestParams
                            requestID:response.requestID];
    }
    [self willPerformSuccessWithResponse:response];
    if ([self.requestDelegate respondsToSelector:@selector(GPNetworkRequestDidSuccess:withResponse:)]) {
        [self.requestDelegate GPNetworkRequestDidSuccess:self withResponse:response];
    }
    [self donePerformSuccessWithResponse:response];
    
}

- (void)requestFailedCallBack:(GPURLResponse *)response withErrorType:(GPNetworkErrorType)errorType
{
    self.errorType = errorType;
    [self removeRequestId:response.requestID];
    [self willPerformFailWithResponse:response];
    if ([self.requestDelegate respondsToSelector:@selector(GPNetworkRequestDidFailed:withResponse:)]) {
        [self.requestDelegate GPNetworkRequestDidFailed:self withResponse:response];
    }
    [self donePerformFailWithResponse:response];
}

- (NSUInteger)requestType:(GPNetworkRequestType)type params:(NSDictionary *)params methodName:(NSString *)methodName postData:(NSData*)postData postDataName:(NSString *)postDataName
{
    NSUInteger requestId = 0;
    if (!methodName ) {
        methodName = self.child.methodName;
    }
    switch (self.child.requestType) {
        case GPNetworkRequestTypeGet:
        {
            requestId = [[GPNetworkProxy shareInstance] invokingGETWithParams:params
                                                                   methodName:methodName
                                                                  serviceName:[self serviceName]
                                                                      success:^(GPURLResponse *response) {
                                                                          [self requestSucessedCallBack:response methodName:methodName];
                                                                      } fail:^(GPURLResponse *response) {
                                                                           GPNetworkErrorType errType =GPNetworkErrorTypeDefault;
                                                                          if (response.status == GPURLResponseStatusErrorNoNetWork) {
                                                                              errType = GPNetworkErrorTypeNoNetWork;
                                                                          }
                                                                          if (response.status == GPURLResponseStatusErrorTimeOut) {
                                                                              errType = GPNetworkErrorTypeTimeOut;
                                                                          }
                                                                         
                                                                          [self requestFailedCallBack:response withErrorType:errType];
                  
                                                                      }];
        }
            break;
        case GPNetworkRequestTypePost:
        {
            if (postDataName && postData) {
                requestId = [[GPNetworkProxy shareInstance] invokingPOSTWithParams:params
                                                                        methodName:methodName
                                                                       serviceName:[self serviceName]
                                                                          postData:postData postDataName:postDataName
                                                                           success:^(GPURLResponse *response) {
                                                                               [self requestSucessedCallBack:response methodName:methodName];
                                                                           } fail:^(GPURLResponse *response) {
                                                                               GPNetworkErrorType errType =GPNetworkErrorTypeDefault;
                                                                               if (response.status == GPURLResponseStatusErrorNoNetWork) {
                                                                                   errType = GPNetworkErrorTypeNoNetWork;
                                                                               }
                                                                               if (response.status == GPURLResponseStatusErrorTimeOut) {
                                                                                   errType = GPNetworkErrorTypeTimeOut;
                                                                               }
                                                                               [self requestFailedCallBack:response withErrorType:errType];
                                                                           }];
            }else
            {
                requestId = [[GPNetworkProxy shareInstance] invokingPOSTWithParams:params
                                                                        methodName:methodName
                                                                       serviceName:[self serviceName]
                                                                           success:^(GPURLResponse *response) {
                                                                               [self requestSucessedCallBack:response methodName:methodName];
                                                                           } fail:^(GPURLResponse *response) {
                                                                               GPNetworkErrorType errType =GPNetworkErrorTypeDefault;
                                                                               if (response.status == GPURLResponseStatusErrorNoNetWork) {
                                                                                   errType = GPNetworkErrorTypeNoNetWork;
                                                                               }
                                                                               if (response.status == GPURLResponseStatusErrorTimeOut) {
                                                                                   errType = GPNetworkErrorTypeTimeOut;
                                                                               }
                                                                               [self requestFailedCallBack:response withErrorType:errType];
                                                                           }];
            }
            
        }
            break;
        case GPNetworkRequestTypeRestfulGet:
        {
            requestId = [[GPNetworkProxy shareInstance] invokingRestfulGETWithParams:params
                                                                    methodName:methodName
                                                                       success:^(GPURLResponse *response) {
                                                                           [self requestSucessedCallBack:response methodName:methodName];
                                                                       } fail:^(GPURLResponse *response) {
                                                                           [self requestFailedCallBack:response withErrorType:GPNetworkErrorTypeDefault];
                                                                       }];
        }
            break;
        case GPNetworkRequestTypeRestfulPost:
        {
            requestId = [[GPNetworkProxy shareInstance] invokingRestfulPOSTWithParams:params
                                                                          methodName:self.child.methodName
                                                                             success:^(GPURLResponse *response) {
                                                                                 [self requestSucessedCallBack:response methodName:methodName];
                                                                             } fail:^(GPURLResponse *response) {
                                                                                 [self requestFailedCallBack:response withErrorType:GPNetworkErrorTypeDefault];
                                                                             }];
        }
            break;
        default:
            break;
    }
    return requestId;
}

#pragma mark - 拦截器方法
- (void)willPerformSuccessWithResponse:(GPURLResponse *)response
{
    self.errorType = GPNetworkErrorTypeSuccess;
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:willPerformSuccessWithResponse:)]) {
        [self.interceptor manager:self willPerformSuccessWithResponse:response];
    }
}

- (void)donePerformSuccessWithResponse:(GPURLResponse *)response
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:donePerformSuccessWithResponse:)]) {
        [self.interceptor manager:self donePerformSuccessWithResponse:response];
    }
}

- (void)willPerformFailWithResponse:(GPURLResponse *)response
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:willPerformFailWithResponse:)]) {
        [self.interceptor manager:self willPerformFailWithResponse:response];
    }
}

- (void)donePerformFailWithResponse:(GPURLResponse *)response
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:donePerformFailWithResponse:)]) {
        [self.interceptor manager:self donePerformFailWithResponse:response];
    }
}

- (BOOL)shouldRequestWithParams:(NSDictionary *)params
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:shouldRequestWithParams:)]) {
        return [self.interceptor manager:self shouldRequestWithParams:params];
    }
    return YES;
}

- (BOOL)doneRequestWithParams:(NSDictionary *)params
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:doneRequestWithParams:)]) {
        return [self.interceptor manager:self doneRequestWithParams:params];
    }
    
    return YES;
}

#pragma mark - 设置，获取方法
- (GPCacheManager *)cache
{
    if (!_cache) {
        _cache = [GPCacheManager shareInstance];
    }
    return _cache;
}

- (NSMutableArray *)requestIDList
{
    if (!_requestIDList) {
        _requestIDList = [[NSMutableArray alloc] init];
    }
    return _requestIDList;
}

- (BOOL)isReachable
{
    BOOL isReachablility = [GPAppContext shareInstance].isReachable;
    if (!isReachablility) {
        self.errorType = GPNetworkErrorTypeNoNetWork;
    }
    return isReachablility;
}

- (BOOL)isLoading
{
    return self.requestIDList.count > 0;
}

@end

