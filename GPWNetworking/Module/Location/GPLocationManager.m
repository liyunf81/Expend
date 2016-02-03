//
//  GPLocationManager.m
//  GPWNetworking
//
//  Created by Angle on 15/9/16.
//  Copyright © 2015年 Feng. All rights reserved.
//

#import "GPLocationManager.h"
#import "DXAlertView.h"
#import "GPAppContext.h"

NSString* const kGPLocationManagerDidSuccessedLocationNotification = @"kLocationManagerDidScuessedLocationNotification";
NSString* const kGPLocationManagerDidFailedLocationNotification = @"kLocationManagerDidFailedLocationNotification";
NSString* const kGPLocationManagerDidSwitchCityNotification = @"kLocationManagerDidSwitchCityLocationNotification";

@interface GPLocationManager()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) BMKMapManager* mapManager;
@property (nonatomic, strong) BMKLocationService* locationService;
@property (nonatomic, strong) BMKGeoCodeSearch* geoCoder;

@property (nonatomic, copy, readwrite) NSString* locatedCityID; //定位的城市ID
@property (nonatomic, copy, readwrite) NSString* locatedCityName; //定位的城市名字
@property (nonatomic, copy, readwrite) NSString* locatedAddress;
@property (nonatomic, strong, readwrite) CLLocation* locatedCityLocation; //定位的城市经纬度

@property (nonatomic, readwrite) GPLocationManagerLocationResult locationResult;
@property (nonatomic, readwrite) GPLocationManagerLocationServiceStatus locationStatus;

@property (nonatomic, readwrite) GPCityListManager* cityListManager;

@property (nonatomic, copy) decoderAddressFinish finish;
@end


@implementation GPLocationManager
#pragma mark - 生命周期

+ (instancetype)sharedInstance
{
    static dispatch_once_t dpOnce;
    static GPLocationManager* locaitonManager;
    dispatch_once(&dpOnce, ^{
        locaitonManager = [[GPLocationManager alloc] init];
    });
    return locaitonManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.locationResult = GPLocationManagerLocationResultDefault;
        self.locationStatus = GPLocationManagerLocationServiceStatusDefulat;
        
        self.isUsingLocatedData = NO;
        self.mapManager = [[BMKMapManager alloc] init];
        BOOL ret = [_mapManager start:@"GG7sWiNQIXhZUGfYvix5YGG0" generalDelegate:nil];
        if (!ret) {
            self.locationStatus = GPLocationManagerLocationServiceStatusUnknownErro;
            DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"错误!" contentText:@"启动地图服务器失败，请手动输入地址" leftButtonTitle:nil rightButtonTitle:@"确定"];
            [alert show];
            alert.dismissBlock = ^() {
                NSLog(@"Do something interesting after dismiss block");
            };
        }
        _locationService = [[BMKLocationService alloc] init];
        _locationService.delegate = self;
        
        _geoCoder = [[BMKGeoCodeSearch alloc] init];
        _geoCoder.delegate = self;
        
        [self loadCurrentCityDataFormPlist];
    }
    return self;
}

+ (void)load
{
    [super load];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self sharedInstance];
    });
}

#pragma mark - 共有方法
- (BOOL)isInLocatedCity
{
    return [self.currentCityID isEqualToString:self.locatedCityID];
}

- (BOOL)checkLocationAndShowAlert:(BOOL)showAlert noNotif:(BOOL)noNotfi
{
    BOOL result = NO;
    BOOL locaitonEnable = [self locationServiceEnabled];
    GPLocationManagerLocationServiceStatus locationStatus = [self locationServiceStatus];
    if (locationStatus == GPLocationManagerLocationServiceStatusOk && locaitonEnable) {
        result = YES;
    }else if(locationStatus == GPLocationManagerLocationServiceStatusNotDetermined)
    {
        result = YES;
    }else
    {
        result = NO;
    }
    
    if (locaitonEnable && result) {
        result = YES;
    }else
    {
        result = NO;
    }
    
    if (!result && !noNotfi) {
        [self failedLocatinWithResultType:GPLocationManagerLocationResultFail locationStatus:self.locationStatus];
    }
    if (!result && showAlert) {
        NSString *message = @"请到“设置->隐私->定位服务”中开启定位";
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"当前定位服务不可用" contentText:message leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        [alert show];
        
        alert.dismissBlock = ^() {
            [self failedLocatinWithResultType:GPLocationManagerLocationResultFail locationStatus:self.locationStatus];
        };
        
        alert.rightBlock = ^()
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
        };
    }
    return result;
}

- (void)startLocation
{
    if ([self checkLocationAndShowAlert:NO noNotif:NO]) {
        self.locationResult = GPLocationManagerLocationResultLocating;
        [self.locationService startUserLocationService];
        self.isUsingLocatedData = YES;
    }
}

- (void)stopLocation
{
    [self.locationService stopUserLocationService];
}

- (void)restartLocation
{
    [self stopLocation];
    [self startLocation];
}

- (void)switchToCityWithCityID:(NSString *)cityID
{
    
    if ([self.locatedCityID isEqualToString:cityID]) {
        self.isUsingLocatedData = YES;
    }else
    {
        self.selectedCityID = cityID;
        self.selectedCityName = [self.cityListManager cityNameWithCityID:cityID];
        self.selectedCityLocation = [self.cityListManager cityLocationWithCityID:cityID];
        self.isUsingLocatedData = NO;
    }
    
    NSDictionary *cityInfo = @{@"cityId":self.currentCityID, @"cityName":self.currentCityName};
    [self.cityListManager saveCityToPlistWithData:cityInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:kGPLocationManagerDidSwitchCityNotification object:nil userInfo:nil];
}

- (void)saveCurrentCityData
{
    NSLog(@"经纬度 %@",self.currentCityLocation);
    NSLog(@"城市id%@",self.currentCityID);
    NSLog(@"名字%@",self.currentCityName);
    NSLog(@"地址%@",self.currentAddress);
    if (self.currentCityLocation && self.currentCityID  && self.currentAddress) {
        NSDictionary* cityLocation = @{@"latitude":@(self.currentCityLocation.coordinate.latitude),
                                       @"longitude":@(self.currentCityLocation.coordinate.longitude)};
        NSDictionary* cityInfo = @{@"cityId":self.currentCityID,
                                   @"cityName":self.currentCityName ? self.currentCityName : @"",
                                   @"cityAddress":self.currentAddress,
                                   @"postion":cityLocation};
        
        [self.cityListManager saveCityToPlistWithData:cityInfo];
    }
}

- (void)loadCurrentCityDataFormPlist
{
    NSDictionary *cityInfo = [self.cityListManager loadCurrentCityDataFormPlist];
    self.isUsingLocatedData = NO;
    self.selectedCityName = cityInfo[@"cityName"];
    self.selectedAddress = cityInfo[@"cityAddress"];
    self.selectedCityLocation = [[CLLocation alloc] initWithLatitude:[cityInfo[@"postion"][@"latitude"] doubleValue] longitude:[cityInfo[@"postion"][@"longitude"] doubleValue]];
    if (!self.selectedCityID || !self.selectedCityName) {
        self.isUsingLocatedData = YES;
    }
}

- (void)decoderAddress:(NSString *)address finish:(decoderAddressFinish)finish
{
    if (!address) {
        if (finish) {
            finish(nil);
        }
        return;
    }
    
    self.finish = finish;
    BMKGeoCodeSearchOption* geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc] init];
    geoCodeSearchOption.address = address;
    geoCodeSearchOption.city = @"成都";
    BOOL flag = [self.geoCoder geoCode:geoCodeSearchOption];
    if(flag)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送成功");
    }
}

#pragma mark - BMKLocationServiceDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if (userLocation.location.coordinate.longitude == self.selectedCityLocation.coordinate.longitude && userLocation.location.coordinate.latitude == self.selectedCityLocation.coordinate.latitude) {
        return;
    }
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    BOOL flag = [self.geoCoder reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    if (self.locationStatus == GPLocationManagerLocationServiceStatusUnAvailable) {
        return;
    }
    self.locatedCityID = @"-1";
    self.isUsingLocatedData = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:kGPLocationManagerDidFailedLocationNotification object:nil userInfo:nil];
    [self stopLocation];
}

#pragma mark - BMKGeoCodeSearchDelegate
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    CLLocation* location = nil;
    if (BMK_SEARCH_NO_ERROR == error)
    {
        location = [[CLLocation alloc] initWithLatitude:result.location.latitude longitude:result.location.longitude];
    }
    
    if (self.finish) {
        self.finish(location);
    }
    self.finish = nil;
}


-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (BMK_SEARCH_NO_ERROR == error)
    {
        self.locatedCityLocation = [[CLLocation alloc] initWithLatitude:result.location.latitude longitude:result.location.longitude];
        self.locatedCityName = result.addressDetail.city;
        self.locatedAddress = result.address;
        NSDictionary* cityInfo = [self.cityListManager cityInfoWithCityName:self.locatedCityName];
        self.locatedCityID = cityInfo[@"SysNo"];
        
        if (self.locatedCityName == nil || self.locatedCityID == nil) {
            [self failedLocatinWithResultType:GPLocationManagerLocationResultFail locationStatus:self.locationStatus];
            return;
        }else
        {
            [self stopLocation];
        }
        self.locationResult = GPLocationManagerLocationResultSuccess;
         [[NSNotificationCenter defaultCenter] postNotificationName:kGPLocationManagerDidSuccessedLocationNotification object:self userInfo:nil];
    }
}


#pragma mark - 私有方法
- (BOOL)locationServiceEnabled
{
    if ([CLLocationManager locationServicesEnabled] && self.locationStatus != GPLocationManagerLocationServiceStatusUnknownErro) {
        self.locationStatus = GPLocationManagerLocationServiceStatusOk;
        return YES;
    }else
    {
        self.locationStatus = GPLocationManagerLocationServiceStatusUnknownErro;
        return NO;
    }
}

- (GPLocationManagerLocationServiceStatus)locationServiceStatus
{
    self.locationStatus = GPLocationManagerLocationServiceStatusUnknownErro;
    BOOL serviceEnable = [CLLocationManager locationServicesEnabled];
    if (serviceEnable) {
        CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
        switch (authorizationStatus) {
            case kCLAuthorizationStatusNotDetermined:
                self.locationStatus = GPLocationManagerLocationServiceStatusNotDetermined;
                break;
            case kCLAuthorizationStatusAuthorizedAlways:
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                self.locationStatus = GPLocationManagerLocationServiceStatusOk;
                break;
            case kCLAuthorizationStatusDenied:
            case kCLAuthorizationStatusRestricted:
                self.locationStatus = GPLocationManagerLocationServiceStatusNoAuthorization;
            default:
                if (![GPAppContext shareInstance].isReachable ) {
                    self.locationStatus = GPLocationManagerLocationServiceStatusNoNetwork;
                }
                break;
        }
    }else
    {
        self.locationStatus = GPLocationManagerLocationServiceStatusUnAvailable;
    }
    return self.locationStatus;
}

- (void)failedLocatinWithResultType:(GPLocationManagerLocationResult)result locationStatus:(GPLocationManagerLocationServiceStatus)status
{
    self.locationStatus = status;
    self.locationResult = result;
    [self didFailToLocateUserWithError:nil];
}

#pragma mark - 设置，获取方法
- (GPCityListManager *)cityListManager
{
    if (!_cityListManager) {
        _cityListManager = [[GPCityListManager alloc] init];
    }
    return _cityListManager;
}

- (NSString *)locatedCityID
{
    if (!_locatedCityID) {
        _locatedCityID = @"1003";
    }
    return _locatedCityID;
}

- (NSString *)selectedCityID
{
    if (!_selectedCityID) {
        _selectedCityID = @"1003";
    }
    return _selectedCityID;
}

- (NSString *)currentCityID
{
    if (self.isUsingLocatedData) {
        return self.locatedCityID;
    }
    return self.selectedCityID;
}

- (NSString *)currentCityName
{
    if (self.isUsingLocatedData) {
        return self.locatedCityName;
    }
    return self.selectedCityName;
}

- (NSString *)currentAddress
{
    if (self.isUsingLocatedData) {
        return self.locatedAddress;
    }
    return self.selectedAddress;
}

- (CLLocation *)currentCityLocation
{
    if (self.isUsingLocatedData) {
        return self.locatedCityLocation;
    }
    return self.selectedCityLocation;
}

- (void)setSelectedCityName:(NSString *)selectedCityName
{
    _selectedCityName = selectedCityName;
    _selectedCityID = [self.cityListManager cityIDWithCityName:selectedCityName];
}
@end
