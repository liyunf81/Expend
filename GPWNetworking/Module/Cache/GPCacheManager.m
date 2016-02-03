//
//  GPCacheManager.m
//  GPWNetworking
//
//  Created by Angle on 15/9/14.
//  Copyright © 2015年 Feng. All rights reserved.
//

#import "GPCacheManager.h"
#import "NSDictionary+GPNetworkingMethods.h"
#import "GPNetworkingConfigure.h"
#import "GPLogger.h"

@interface GPCacheManager ()

@property (nonatomic, copy) NSCache* cache;

@end

@implementation GPCacheManager
#pragma mark - 生命周期

+ (instancetype)shareInstance
{
    static dispatch_once_t bponce;
    static GPCacheManager* instance;
    dispatch_once(&bponce, ^{
        instance = [[GPCacheManager alloc] init];
    });
    return instance;
}

#pragma mark - 公共方法
- (NSString *)keyWithMethodName:(NSString *)methodName requestParams:(NSDictionary *)requestDic
{
    return [NSString stringWithFormat:@"%@%@",methodName,[requestDic GPUrlParamsString]];
}

- (GPCacheObject *)fetchCachedDataWithMethodName:(NSString *)methodName requestParams:(NSDictionary *)requestDic
{
    return [self fetchCachedDataWithKey:[self keyWithMethodName:methodName requestParams:requestDic]];
}

- (GPCacheObject *)fetchCachedDataWithKey:(NSString *)key
{
    GPCacheObject* cacheObj = [self.cache objectForKey:key];
    if (cacheObj.isOutDated || cacheObj.isEmpty) {
        return nil;
    }
    return cacheObj;
}

- (void)saveCacheWithData:(NSData *)cachedData methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams requestID:(NSInteger)requestID
{
    [self saveCacheWithData:cachedData key:[self keyWithMethodName:methodName requestParams:requestParams] requestID:requestID];
}

- (void)saveCacheWithData:(NSData *)cachedData key:(NSString *)key requestID:(NSInteger)requestID
{
    if (!cachedData) {
        [[GPLogger shareInstance]errorLog:[NSString stringWithFormat:@"<%s> cacheData不能为空",__FUNCTION__]];
        return;
    }
    GPCacheObject* cacheObj = [self.cache objectForKey:key];
    if (!cacheObj) {
        cacheObj = [[GPCacheObject alloc] init];
    }
    [cacheObj updateContent:cachedData requestId:requestID];
    [self.cache setObject:cacheObj forKey:key];
}

- (void)deleteCacheWithMethodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams
{
    [self deleteCacheWithKey:[self keyWithMethodName:methodName requestParams:requestParams]];
}

- (void)deleteCacheWithKey:(NSString *)key
{
    [self.cache removeObjectForKey:key];
}

- (void)clean
{
    [self.cache removeAllObjects];
}


#pragma mark - 获取，设置方法
- (NSCache *)cache
{
    if (!_cache) {
        _cache = [[NSCache alloc] init];
        _cache.countLimit = kGPCacheCountLimit;
    }
    return _cache;
}


@end
