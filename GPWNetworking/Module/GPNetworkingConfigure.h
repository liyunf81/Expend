//
//  GPWNetworkingConfigure.h
//  GPWNetworking
//
//  Created by Angle on 15/9/13.
//  Copyright © 2015年 Feng. All rights reserved.
//


/**
 *  此头文件主要用于网络模块方面的配置几乎所有网络方面的配置都可以在这里面找到.
 *  如果有需要添加新的配置，也请往此文件中添加
 */
#ifndef GPWNetworkingConfigure_h
#define GPWNetworkingConfigure_h


typedef NS_ENUM(NSUInteger,GPURLResponseStatus)
{
    GPURLResponseStatusSucess, //只用于判断是否成功收到服务器反馈
    GPURLResponseStatusErrorTimeOut, //请求超时
    GPURLResponseStatusErrorNoNetWork,//将请求失败的错误规整为除超时之外的错误.
};

//请求超时时间
static const NSTimeInterval kGPNetworkingTimeoutSeconds = 5;

static NSString* const kGPKeyChainServiceName = @"com.guopuwang";//keychain
static NSString* const kGPUDIDName = @"guopuwangapps"; //udid 模仿
static NSString* const kGPPasteboardType = @"";    //粘贴板
static NSString* const kGPPasswordName = @"com.guopu.password";
static NSString* const kGPUserName = @"com.guopu.username";
static NSString* const kGPLoginTime = @"com.guopu.loginTime";

static BOOL kGPShouldCache = YES; //默认开启缓存
static const NSTimeInterval kGPCacheOutdateTimeSeconds = 600;//10分钟
static const NSUInteger kGPCacheCountLimit = 1000; //每次最多缓存1000条

static NSString* const kGPNetworkingPublicKey = @"key";
static NSString* const kGPNetworkingPrivateKey = @"privateKey";

static NSString* const KGPNetworkingLogFileName = @"xxxxxx.log";

static NSString* const kGPNetworkingRequestID = @"gpnetworkingRequestID";


//static NSString* const kGPNetworkBaseURL = @"http://192.168.3.53:9526";
static NSString* const kGPNetworkBaseURL = @"http://192.168.2.125:8081"; //外网



#endif /* GPWNetworkingConfigure_h */
