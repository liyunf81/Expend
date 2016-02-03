//
//  GPAppContext.m
//  GPWNetworking
//
//  Created by Angle on 15/9/14.
//  Copyright © 2015年 Feng. All rights reserved.
//

#import <ifaddrs.h>
#import <arpa/inet.h>
#import <AFNetworking/AFNetworking.h>

#import "GPAppContext.h"
#import "UIDevice+GPAddition.h"

GPAppContext* AppContext()
{
    return [GPAppContext shareInstance];
}

@interface GPAppContext ()

@property (nonatomic, strong)UIDevice* device;
@property (nonatomic, copy, readwrite) NSString* model;
@property (nonatomic, copy, readwrite) NSString* os;
@property (nonatomic, copy, readwrite) NSString* osVer;
@property (nonatomic, copy, readwrite) NSString* currVer;
@property (nonatomic, copy, readwrite) NSString* uuid;
@property (nonatomic, copy, readwrite) NSString* udid;
@property (nonatomic, assign, readwrite) BOOL isReachable;

////////////////////////////////////////////////////////
//log 相关
@property (nonatomic, copy, readwrite) NSString* logGuid;
@property (nonatomic, copy, readwrite) NSString* logIP;

@end

@implementation GPAppContext

////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 公共方法
+ (instancetype)shareInstance
{
    static dispatch_once_t dpOnce;
    static GPAppContext* instance;
    dispatch_once(&dpOnce, ^{
        instance = [[GPAppContext alloc] init];
    });
    return instance;
}

- (void)configWithAPPName:(NSString *)name channelID:(NSString *)channelID ccid:(NSString *)ccid
{
    self.channelID = channelID;
    self.appName = name;
    self.logCCid = ccid;
}

////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 获取,设置方法
- (UIDevice *)device
{
    if (!_device) {
        _device = [UIDevice currentDevice];
    }
    
    return _device;
}

- (NSString *)model
{
    if (!_model) {
        _model = [self.device GP_macheineType];
    }
    return _model;
}

- (NSString *)os
{
    if (!_os) {
        _os = [self.device GP_osType];
    }
    return _os;
}

- (NSString *)osVer
{
    if (_osVer) {
        _osVer = [self.device systemVersion];
    }
    return _osVer;
}

- (NSString *)currVer
{
    if (!_currVer) {
        _currVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    }
    return _currVer;
}

- (NSString *)uuid
{
    if ( !_uuid ) {
        _uuid = [self.device GP_UUID];
    }
    return _uuid;
}

- (NSString *)from
{
    return @"mobile";
}

- (NSString *)udid
{
    if (!_udid) {
        _udid = [self.device GP_UDID];
    }
    return _udid;
}

- (NSString *)requestTime
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    return [formatter stringFromDate:[NSDate date]];
}

- (NSString *)cid
{
    return @"";
}

- (NSString *)channelID
{
    if (!_channelID) {
        _channelID = @"qudaoID";
    }
    return _channelID;
}

- (NSString *)appName
{
    if (!_appName) {
        _appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    }
    return _appName;
}

- (NSString *)logGuid
{
    if ( _logGuid == nil) {
        NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"GPGuid.string"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            _logGuid = [[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil] copy];
        }
        else {
            CFUUIDRef uuid = CFUUIDCreate(NULL);
            CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
            
            _logGuid = [[NSString alloc] initWithFormat:@"%@",uuidStr];
            
            CFRelease(uuidStr);
            CFRelease(uuid);
            
            [_logGuid writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
    }
    return _logGuid;
}

- (NSString *)logDivd
{
    return self.udid;
}

- (NSString *)logVer
{
    return @"v1.0";
}

- (NSString *)logNet
{
    NSString* net = @"";
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus ==
        AFNetworkReachabilityStatusReachableViaWWAN) {
        net = @"2G3G";
    }
    
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus ==
        AFNetworkReachabilityStatusReachableViaWiFi) {
        net = @"WiFi";
    }
    return net;
}

- (NSString *)logIP
{
    if (!_logIP) {
        _logIP = @"Error";
        struct ifaddrs *interfaces = NULL;
        struct ifaddrs *temp_addr = NULL;
        int success = 0;
        // retrieve the current interfaces - returns 0 on success
        success = getifaddrs(&interfaces);
        if (success == 0) {
            // Loop through linked list of interfaces
            temp_addr = interfaces;
            while(temp_addr != NULL) {
                if(temp_addr->ifa_addr->sa_family == AF_INET) {
                    // Check if interface is en0 which is the wifi connection on the iPhone
                    if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en1"] ||
                       [[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                        // Get NSString from C String
                        _logIP = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    }
                }
                temp_addr = temp_addr->ifa_next;
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return _logIP;
}

- (NSString *)logOs
{
    return self.osVer;
}

- (NSString *)logApp
{
    return self.appName;
}

- (NSString *)logCh
{
    return self.channelID;
}

- (NSString *)logCt
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    dateFormater.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    return [dateFormater stringFromDate:[NSDate date]];
}

- (NSString *)logPModel
{
    return self.model;
}

- (BOOL)isReachable
{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        return YES;
    } else {
        return [[AFNetworkReachabilityManager sharedManager] isReachable];
    }
}

- (NSDateComponents *)YMDComponents:(NSDate*)date
{
    return [[NSCalendar currentCalendar] components:
            NSCalendarUnitYear|
            NSCalendarUnitMonth|
            NSCalendarUnitDay|
            NSCalendarUnitWeekday
                                           fromDate:date];
}



@end
