//
//  GPCityListManager.m
//  GPWNetworking
//
//  Created by Angle on 15/9/16.
//  Copyright © 2015年 Feng. All rights reserved.
//

#import "GPCityListManager.h"
#import "GPPlistManager.h"
#import "GPNetworking.h"
#import "GPLogger.h"

@interface GPCityListManager ()

@property (nonatomic, copy, readwrite) NSString* methodName;
@property (nonatomic, copy, readwrite) NSArray* cityData;
@property (nonatomic, strong,readwrite) GPPlistManager *plistManager;

@end

@implementation GPCityListManager
#pragma mark - 生命周期

- (instancetype)init
{
    self = [super init];
    if (self) {
        _methodName = @"cityManager";
        self.requestDelegate = self;
        self.paramSource = self;
        self.interceptor = self;
        self.plistManager = [[GPPlistManager alloc] init];
        [self loadCurrentCityDataFormPlist];
        [self loadCityListFormPlist];
    }
    return self;
}

#pragma mark - 公共方法

- (void)saveCityList
{
    [self.plistManager saveData:self.cityData withFileName:@"CityList"];
}

- (void)saveCityToPlistWithData:(NSDictionary *)citydata
{
    if (citydata) {
        [self.plistManager saveData:citydata withFileName:@"CurrentCity"];
    }
}

- (CLLocation *)cityLocationWithCityID:(NSString *)cityID
{
    for (NSDictionary *cityDic in self.cityData) {
        if ([cityDic[@"SysNo"] isEqualToString:cityID]) {
            NSArray *locationArray = cityDic[@"map_info"][@"center"];
            if (!locationArray) {
                return nil;
            }
            CLLocation *location = [[CLLocation alloc] initWithLatitude:[locationArray[1] doubleValue] longitude:[locationArray[0] doubleValue]];
            return location;
        }
    }
    return nil;
}

- (NSString *)cityNameWithCityID:(NSString *)cityID
{
    NSString* result = nil;
    for (NSDictionary* cityDic  in  self.cityData) {
        if ([cityDic[@"SysNo"]isEqualToString:cityID]) {
            result = [cityDic[@"AreaName"] copy];
            break;
        }
    }
    return result;
}

- (NSDictionary *)cityInfoWithCityID:(NSString *)cityId
{
    NSDictionary* result = nil;
    for (NSDictionary* city in self.cityData) {
        if ([city[@"SysNo" ] isEqualToString:cityId ]) {
            result = [city copy];
            break;
        }
    }
    return result;
}

- (NSDictionary *)cityInfoWithCityName:(NSString *)cityName
{
    NSDictionary* result = nil;
    for (NSDictionary* city in self.cityData) {
        if ([city[@"AreaName" ] isEqualToString:cityName ] || [cityName hasPrefix:city[@"AreaName"]]) {
            result = [city copy];
            break;
        }
    }
    return result;
}

- (NSString *)cityIDWithCityName:(NSString *)cityName
{
    NSString* reslutId = @"0";
    for (NSDictionary* city in self.cityData) {
        if ([city[@"AreaName" ] isEqualToString:cityName ] || [cityName hasPrefix:city[@"AreaName"]]) {
            reslutId = city[@"SysNo"];
            break;
        }
    }
    return reslutId;
}

- (NSDictionary *)loadCurrentCityDataFormPlist
{
    NSDictionary *plistData = [self.plistManager loadDataWithFileName:@"CurrentCity"];
    return plistData;
}

- (void)loadCityListFormPlist
{
    NSArray* plistData = [self.plistManager loadDataWithFileName:@"cityData.plist"];
    self.cityData = plistData;
}

@end
