//
//  GPKeyChainHelper.h
//  GPFruit
//
//  Created by Angle on 15/9/28.
//  Copyright © 2015年  果铺电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPKeyChainHelper : NSObject

/**
 *  创建新的keychina搜索条件
 *
 *  @param identity 标示
 *
 *  @return 搜索条件
 */
+ (NSMutableDictionary *)newSerachDictionary:(NSString *)identity;
/**
 *  根据标示查找keyching数据
 *
 *  @param identity 标示
 *
 *  @return 返回keyching数据
 */
+ (NSData *)searchKeychainCopyMatching:(NSString *)identity;
+ (BOOL)createKeychainValue:(NSString *)value forIdentity:(NSString *)identity;
+ (BOOL)updateKeychainValue:(NSString *)value forIdentity:(NSString *)identity;
+ (void)deleteKeychainValue:(NSString *)identity;

@end
