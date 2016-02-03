//
//  GPCacheManager.h
//  GPWNetworking
//
//  Created by Angle on 15/9/14.
//  Copyright © 2015年 Feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPCacheObject.h"

@interface GPCacheManager : NSObject

+ (instancetype)shareInstance;

/**
 *  获取缓存key
 *
 *  @param methodName 请求方法名
 *  @param requestDic 请求参数
 *
 *  @return 返回key
 */
- (NSString *)keyWithMethodName:(NSString *)methodName
                  requestParams:(NSDictionary *)requestDic;


/**
 *  请求缓存数据
 *
 *  @param methodName 请求方法名
 *  @param requestDic 请求参数
 *
 *  @return 返回缓存数据
 */
- (GPCacheObject *)fetchCachedDataWithMethodName:(NSString *)methodName
                            requestParams:(NSDictionary *)requestDic;


/**
 *  获取缓存数据
 *
 *  @param key 请求方法名
 *
 *  @return 返回缓存数据
 */
- (GPCacheObject *)fetchCachedDataWithKey:(NSString *)key;

/**
 *  保存缓存数据
 *
 *  @param chchedData    需要缓存的数据
 *  @param methodName    方法名
 *  @param requestParams 方法参数
 */
- (void)saveCacheWithData:(NSData *)cachedData
               methodName:(NSString *)methodName
            requestParams:(NSDictionary *)requestParams
                requestID:(NSInteger)requestID;

/**
 *  保存缓存数据
 *
 *  @param cachedData 需要缓存的数据
 *  @param key        缓存数据对应的key
 */
- (void)saveCacheWithData:(NSData *)cachedData
                      key:(NSString *)key
                requestID:(NSInteger)requestID;


/**
 *  删除缓存数据
 *
 *  @param methodName    请求方法名
 *  @param requestParams 请求参数
 */
- (void)deleteCacheWithMethodName:(NSString *)methodName
                    requestParams:(NSDictionary *)requestParams;

/**
 *  删除缓存数据
 *
 *  @param key 缓存数据的key
 */
- (void)deleteCacheWithKey:(NSString *)key;

/**
 *  清空
 */
- (void)clean;
@end
