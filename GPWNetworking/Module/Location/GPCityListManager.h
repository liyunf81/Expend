//
//  GPCityListManager.h
//  GPWNetworking
//
//  Created by Angle on 15/9/16.
//  Copyright © 2015年 Feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "GPNetworkBaseManager.h"

@interface GPCityListManager : GPNetworkBaseManager<GPNetworkManager,GPNetworkRequestCallBackDelegate,GPNetworkManagerInterceptor,GPNetworkRequestParamsDataSource>

/**
 *  根据城市id获取城市信息
 *
 *  @param cityId 城市id
 *
 *  @return 城市信息
 */
- (NSDictionary *)cityInfoWithCityID:(NSString *)cityId;
/**
 *  根据城市名字获取城市信息
 *
 *  @param cityName 城市名字
 *
 *  @return 城市信息
 */
- (NSDictionary *)cityInfoWithCityName:(NSString *)cityName;
- (NSString *)cityIDWithCityName:(NSString *)cityName;

- (NSArray *)cities;
- (CLLocation *)cityLocationWithCityID:(NSString *)cityID;
- (NSString *)cityNameWithCityID:(NSString *)cityID;


/**
 *  判断地理信息是否在城市id所在诚实
 *
 *  @param location 经纬度
 *  @param cityID   城市id
 *
 *  @return 是否在城市范围内
 */
- (BOOL)isLocation:(CLLocation *)location inCityID:(NSString *)cityID;

/**
 *  当程序进入后台时，会将当前城市信息保存早磁盘，以备下次启动显示
 *
 *  @param citydata 城市数据
 */
- (void)saveCityToPlistWithData:(NSDictionary *)citydata;
- (NSDictionary *)loadCurrentCityDataFormPlist;

- (void)saveCityList;
@end
