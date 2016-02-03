//
//  GPNetworkBaseManager.h
//  GPWNetworking
//
//  Created by Angle on 15/9/15.
//  Copyright © 2015年 Feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPURLResponse.h"

typedef NS_ENUM(NSUInteger,GPNetworkErrorType)
{
    GPNetworkErrorTypeDefault,              //默认状态，无任何请求
    GPNetworkErrorTypeSuccess,              //请求成功，且返回数据验证正确
    GPNetworkErrorTypeNoContent,            //请求成功，但是返回数据不正确
    GPNetworkErrorTypeParamsError,          //参数错误，此状态不会请求网络
    GPNetworkErrorTypeTimeOut,              //请求超时
    GPNetworkErrorTypeNoNetWork,            //无网络，每次调用网络之前都会判断
};

typedef NS_ENUM(NSUInteger,GPNetworkRequestType)
{
    GPNetworkRequestTypeGet,
    GPNetworkRequestTypePost,
    GPNetworkRequestTypeRestfulGet,
    GPNetworkRequestTypeRestfulPost,
};

@class GPNetworkBaseManager;
/**
 *  此处我将会设置四个代理，用于检测网络请求各个部分.
 *  而类GPNetworkBaseManager是所有网络处理相关的基类，
 */

/***********************************************************************/
//          GPNetworkRequestCallBackDelegate
/***********************************************************************/

@protocol GPNetworkRequestCallBackDelegate <NSObject>

@required //必须实现
- (void)GPNetworkRequestDidSuccess:(GPNetworkBaseManager *)baseManager withResponse:(GPURLResponse *)respones;
- (void)GPNetworkRequestDidFailed:(GPNetworkBaseManager *)baseManager withResponse:(GPURLResponse *)respones;

@end

//此协议，主要用处就是根据不同的需求，将原数据转化成自己需要的数据格式，由于需要考虑的东西蛮多，所以此处
//直接返回id，当上层需要具体类型时，自己可以做处理
/***********************************************************************/
//          GPNetworkResponseDataRedefine
/***********************************************************************/
@protocol GPNetworkResponseDataRedefine <NSObject>

@required
- (id)manager:(GPNetworkBaseManager *)manager redefine:(NSDictionary *)data;

@end

//此协议主要用来验证网络请求的参数以及请求结果的正确性
/***********************************************************************/
//          GPNetworkValidator
/***********************************************************************/
@protocol GPNetworkValidator <NSObject>

@required
- (BOOL)manager:(GPNetworkBaseManager *)manager isCorrectWithResponseData:(NSDictionary *)data;
- (BOOL)manager:(GPNetworkBaseManager *)manager isCorrectWithRequestParams:(NSDictionary *)params;
@end

/***********************************************************************/
//          GPNetworkRequestParamsDataSource
/***********************************************************************/
@protocol  GPNetworkRequestParamsDataSource <NSObject>

@required
- (NSDictionary *)requestParamsForManager:(GPNetworkBaseManager *)manager;

@end

/***********************************************************************/
//          GPNetworkManager
/***********************************************************************/
//所有派生自BaseManager的子类都必须实现此协议
@protocol GPNetworkManager <NSObject>

@required
- (NSString *)methodName; //函数名字
- (GPNetworkRequestType)requestType; //请求类型
@optional
- (void)cleanData;
- (NSDictionary *)redefineParams:(NSDictionary *)params;
- (BOOL)shouldCache;
- (NSString *)serviceName; //服务名字，可能涉及到多个外部服务接口
@end

/***********************************************************************/
//          GPNetworkManagerInterceptor
/***********************************************************************/
//BaseManager的子类必须符合此协议，但是里面的方法可选
@protocol GPNetworkManagerInterceptor <NSObject>

@optional
- (void)manager:(GPNetworkBaseManager *)manager willPerformSuccessWithResponse:(GPURLResponse *)response;
- (void)manager:(GPNetworkBaseManager *)manager donePerformSuccessWithResponse:(GPURLResponse *)response;

- (void)manager:(GPNetworkBaseManager *)manager willPerformFailWithResponse:(GPURLResponse *)response;
- (void)manager:(GPNetworkBaseManager *)manager donePerformFailWithResponse:(GPURLResponse *)response;

- (BOOL)manager:(GPNetworkBaseManager *)manager shouldRequestWithParams:(NSDictionary *)params;
- (BOOL)manager:(GPNetworkBaseManager *)manager doneRequestWithParams:(NSDictionary *)params;
@end

/***********************************************************************/
//          GPNetworkBaseManager
/***********************************************************************/

@interface GPNetworkBaseManager : NSObject

@property (nonatomic, weak) id<GPNetworkRequestCallBackDelegate> requestDelegate;
@property (nonatomic, weak) id<GPNetworkRequestParamsDataSource> paramSource;
@property (nonatomic, weak) id<GPNetworkValidator> validator;
@property (nonatomic, weak) NSObject<GPNetworkManager>* child;
@property (nonatomic, weak) id<GPNetworkManagerInterceptor> interceptor;

@property (nonatomic, copy, readonly)NSString* errorMsg; //错误信息
@property (nonatomic, assign, readwrite)GPNetworkErrorType errorType;
@property (nonatomic, assign, readonly)BOOL isReachable;
@property (nonatomic, assign, readonly)BOOL isLoading;
@property (nonatomic, assign, readonly)NSInteger requestID;

- (id)fetchDataWithRedefine:(id<GPNetworkResponseDataRedefine>)redefine;

/**
 *  请求网络数据，请求参数通过paramsDataSource提供
 *
 *  @return 返回请求ID
 */
- (NSInteger)loadData;

- (NSInteger)loadDataWithParams:(NSDictionary *)params withMethodsName:(NSString *)methodName;

- (NSInteger)loadDataWithParams:(NSDictionary *)params withMethodsName:(NSString *)methodName postData:(NSData *)postData postDataName:(NSString *)postDataName;

/**
 *  取消所有请求
 */
- (void)cancelAllRequests;

/**
 *  取消对应请求ID的请求
 *
 *  @param requestID 请求ID
 */
- (void)cancelRequestWithRequestID:(NSInteger)requestID;

//网络请求流程的拦截器方法，子类重载这些方法后，需要先调用super
- (void)willPerformSuccessWithResponse:(GPURLResponse *)response;
- (void)donePerformSuccessWithResponse:(GPURLResponse *)response;

- (void)willPerformFailWithResponse:(GPURLResponse *)response;
- (void)donePerformFailWithResponse:(GPURLResponse *)response;

- (BOOL)shouldRequestWithParams:(NSDictionary *)params;
- (BOOL)doneRequestWithParams:(NSDictionary *)params;

- (void)cleanData;
- (NSDictionary *)redefineParams:(NSDictionary *)params;
- (NSString *)serviceName;
@end
