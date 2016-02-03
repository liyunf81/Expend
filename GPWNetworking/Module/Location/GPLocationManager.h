//
//  GPLocationManager.h
//  GPWNetworking
//
//  Created by Angle on 15/9/16.
//  Copyright © 2015年 Feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI/BMapKit.h>

#import "GPCityListManager.h"

extern NSString* const kGPLocationManagerDidSuccessedLocationNotification;
extern NSString* const kGPLocationManagerDidFailedLocationNotification;
extern NSString* const kGPLocationManagerDidSwitchCityNotification;

/**
 *  定位状态
 */
typedef NS_ENUM(NSUInteger,GPLocationManagerLocationResult)
{
    GPLocationManagerLocationResultDefault,             //默认状态
    GPLocationManagerLocationResultLocating,            //定位中
    GPLocationManagerLocationResultSuccess,             //成功
    GPLocationManagerLocationResultFail,                //失败
    GPLocationManagerLocationResultParamsError,         //调用api的参数错误
    GPLocationManagerLocationResultTimeOut,             //超时
    GPLocationManagerLocationResultNoNetwork,           //无网络
    GPLocationManagerLocationResultNoContent,           //数据错误
};


/**
 *  iPhone上的gps定位状态
 */
typedef NS_ENUM(NSUInteger,GPLocationManagerLocationServiceStatus)
{
    GPLocationManagerLocationServiceStatusDefulat,      //默认状态
    GPLocationManagerLocationServiceStatusOk,           //定位功能可用
    GPLocationManagerLocationServiceStatusUnknownErro,  //未知错误
    GPLocationManagerLocationServiceStatusUnAvailable,  //定位功能关闭
    GPLocationManagerLocationServiceStatusNoAuthorization,//定位功能开启了，但是用户禁止了程序的定位权限
    GPLocationManagerLocationServiceStatusNoNetwork,    //无网络
    GPLocationManagerLocationServiceStatusNotDetermined, //用户还没有决定是否开启定位权限，一般出现在程序第一次安装.
};

typedef void (^decoderAddressFinish) (CLLocation* location);

@interface GPLocationManager : NSObject

@property (nonatomic, copy, readwrite) NSString* selectedCityID; //选中的城市ID
@property (nonatomic, copy, readwrite) NSString* selectedCityName; //城市名字
@property (nonatomic, copy, readwrite) NSString* selectedAddress; //详细地址
@property (nonatomic, strong, readwrite) CLLocation* selectedCityLocation; //城市经纬度

@property (nonatomic, copy, readonly) NSString* locatedCityID; //定位的城市ID
@property (nonatomic, copy, readonly) NSString* locatedCityName; //定位的城市名字
@property (nonatomic, copy, readonly) NSString* locatedAddress; //定位的详细地址
@property (nonatomic, strong, readonly) CLLocation* locatedCityLocation; //定位的城市经纬度

@property (nonatomic, copy, readonly) NSString* currentCityID; //当前ID
@property (nonatomic, copy, readonly) NSString* currentAddress; //当前地址
@property (nonatomic, copy, readonly) NSString* currentCityName; //当前城市名字
@property (nonatomic, strong, readonly) CLLocation* currentCityLocation; //当前城市经纬度

@property (nonatomic, assign, readwrite) BOOL isUsingLocatedData;
@property (nonatomic, assign, readonly) GPLocationManagerLocationResult locationResult;
@property (nonatomic, assign, readonly) GPLocationManagerLocationServiceStatus locationStatus;

@property (nonatomic, readonly) GPCityListManager* cityListManager;

+ (instancetype)sharedInstance;

/**
 *  判断当前是否在定位的城市中
 *
 *  @return
 */
- (BOOL)isInLocatedCity;

/**
 *  检测定位服务是否可用
 *
 *  @param showAlert 是否显示弹出框
 *
 *  @return
 */
- (BOOL)checkLocationAndShowAlert:(BOOL)showAlert noNotif:(BOOL) noNotfi;

/**
 *  开始定位
 */
- (void)startLocation;

/**
 *  结束定位
 */
- (void)stopLocation;

/**
 *  重新定位
 */
- (void)restartLocation;

/**
 *  切换城市
 *
 *  @param cityID
 */
- (void)switchToCityWithCityID:(NSString *)cityID;

- (void)saveCurrentCityData;

/**
 *  获取当前城市数据
 */
- (void)loadCurrentCityDataFormPlist;

/**
 *  详细地址解析
 *
 *  @param address 详细地址
 *  @param finish  完成后回调
 */
- (void)decoderAddress:(NSString *)address finish:(decoderAddressFinish)finish;


@end
