//
//  GPKeyChainHelper.m
//  GPFruit
//
//  Created by Angle on 15/9/28.
//  Copyright © 2015年  果铺电子商务有限公司. All rights reserved.
//

#import "GPKeyChainHelper.h"
#import "GPNetworkingConfigure.h"

@implementation GPKeyChainHelper

#pragma mark - 共有方法

+ (NSMutableDictionary *)newSerachDictionary:(NSString *)identity
{
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    searchDic[((__bridge id)kSecClass)] = (__bridge id)kSecClassGenericPassword;
    
    NSData* encodeIdentifier = [identity dataUsingEncoding:NSUTF8StringEncoding];
    searchDic[((__bridge id)kSecAttrGeneric)] = encodeIdentifier;
    searchDic[((__bridge id)kSecAttrAccount)] = encodeIdentifier;
    searchDic[((__bridge id)kSecAttrService)] = kGPKeyChainServiceName;
    return searchDic;
}


+ (NSData *)searchKeychainCopyMatching:(NSString *)identity
{
    NSMutableDictionary* searchDictionary = [self newSerachDictionary:identity];
    searchDictionary[((__bridge id)kSecMatchLimit)] = (__bridge id)kSecMatchLimitOne;
    searchDictionary[((__bridge id)kSecReturnData)] = (id)kCFBooleanTrue;
    
    CFDataRef result = nil;
    SecItemCopyMatching((__bridge CFDictionaryRef)searchDictionary,(CFTypeRef *)&result);
    
    return (__bridge NSData *)result;
}

+ (BOOL)createKeychainValue:(NSString *)value forIdentity:(NSString *)identity
{
    BOOL retValue = NO;
    NSMutableDictionary* dic = [self newSerachDictionary:identity];
    NSData* passwordData = [value dataUsingEncoding:NSUTF8StringEncoding];
    dic[((__bridge id)kSecValueData)] = passwordData;
    
    OSStatus status = SecItemAdd(((__bridge CFDictionaryRef)dic), NULL);
    if (status == errSecSuccess) {
        retValue = YES;
    }
    return retValue;
}

+ (BOOL)updateKeychainValue:(NSString *)value forIdentity:(NSString *)identity
{
    NSMutableDictionary* searchDic = [self newSerachDictionary:identity];
    NSMutableDictionary* updateDic = [[NSMutableDictionary alloc] init];
    NSData* passwordData = [value dataUsingEncoding:NSUTF8StringEncoding];
    updateDic[((__bridge id)kSecValueData)] = passwordData;
    
    OSStatus status = SecItemUpdate(((__bridge CFDictionaryRef)searchDic),
                                    ((__bridge CFDictionaryRef)updateDic));
    return status == errSecSuccess;
}

+ (void)deleteKeychainValue:(NSString *)identity
{
    NSMutableDictionary* searchDic = [self newSerachDictionary:identity];
    SecItemDelete((__bridge CFDictionaryRef)searchDic);
}


@end
