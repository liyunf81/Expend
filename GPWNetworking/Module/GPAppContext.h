//
//  GPAppContext.h
//  GPWNetworking
//
//  Created by Angle on 15/9/14.
//  Copyright © 2015年 Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GPAppContext;
FOUNDATION_EXTERN_INLINE GPAppContext* AppContext();

@interface GPAppContext : NSObject

@property (nonatomic, copy) NSString* channelID;
@property (nonatomic, copy) NSString* appName;

@property (nonatomic, copy, readonly) NSString* cid;         //城市id
@property (nonatomic, copy, readonly) NSString* model;       //设备名称
@property (nonatomic, copy, readonly) NSString* os;          //系统名称
@property (nonatomic, copy, readonly) NSString* osVer;       //系统版本
@property (nonatomic, copy, readonly) NSString* currVer;     //当前app版本
@property (nonatomic, copy, readonly) NSString* from;        //请求来源
@property (nonatomic, copy, readonly) NSString* osType2;     //系统类型
@property (nonatomic, copy, readonly) NSString* requestTime; //请求时间
@property (nonatomic, copy, readonly) NSString* uuid;
@property (nonatomic, copy, readonly) NSString* udid;
@property (nonatomic, assign, readonly) BOOL isReachable;

//log 相关参数
@property (nonatomic, copy) NSString* logUid; //登陆用户token
@property (nonatomic, copy) NSString* logUName; //登陆用户名字
@property (nonatomic, copy) NSString* logCCid; //用户选择的城市id

@property (nonatomic, copy, readonly) NSString* logCid; //用户当前所在城市id
@property (nonatomic, copy, readonly) NSString* logGuid;
@property (nonatomic, copy, readonly) NSString* logNet;
@property (nonatomic, copy, readonly) NSString* logIP;
@property (nonatomic, copy, readonly) NSString* logGeo; //经纬度
@property (nonatomic, copy, readonly) NSString* logVer; //log的版本
@property (nonatomic, copy, readonly) NSString* logDivd;
@property (nonatomic, copy, readonly) NSString* logOs;
@property (nonatomic, copy, readonly) NSString* logApp;
@property (nonatomic, copy, readonly) NSString* logCh;
@property (nonatomic, copy, readonly) NSString* logCt;
@property (nonatomic, copy, readonly) NSString* logPModel;

+ (instancetype)shareInstance;
- (void)configWithAPPName:(NSString *)name channelID:(NSString *)channelID ccid:(NSString *)ccid;
- (NSDateComponents *)YMDComponents:(NSDate*)date;

@end
