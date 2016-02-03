//
//  GPWUDIDCreator.m
//  GPWNetworking
//
//  Created by Angle on 15/9/14.
//  Copyright © 2015年 Feng. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "GPUDIDCreator.h"
#import "GPNetworkingConfigure.h"
#import "GPKeyChainHelper.h"

@implementation GPUDIDCreator
#pragma mark -
#pragma mark 公共方法

+ (instancetype)shareInstance
{
    static dispatch_once_t pred;
    static GPUDIDCreator *shareInstance;
    dispatch_once(&pred, ^{
        shareInstance = [[GPUDIDCreator alloc] init];
    });
    return shareInstance;
}

- (NSString *)UDID
{
    NSData* udidData = [GPKeyChainHelper searchKeychainCopyMatching:kGPUDIDName];
    NSString* udid = nil;
    if (udidData) {
        NSString* temp = [[NSString alloc] initWithData:udidData encoding:NSUTF8StringEncoding];
        udid = temp;
    }
    if (udid.length == 0) {
        udid = [self readPasteBoradforIdentifier:kGPUDIDName];
    }
    return udid;
}

- (void)saveUDID:(NSString *)udid
{
    BOOL saveOk = NO;
    NSData* udidData = [GPKeyChainHelper searchKeychainCopyMatching:kGPUDIDName];
    if (!udidData) {
        saveOk = [GPKeyChainHelper createKeychainValue:udid forIdentity:kGPUDIDName];
    }else
    {
        saveOk = [GPKeyChainHelper updateKeychainValue:udid forIdentity:kGPUDIDName];
    }
    
    if (!saveOk) {
        [self createPasteBoradValue:udid forIdentifier:kGPUDIDName];
    }
}

///////////////////////////////////////////
#pragma mark -
#pragma mark 私有方法


- (void)createPasteBoradValue:(NSString *)value forIdentifier:(NSString *)identifier
{
    UIPasteboard* pb = [UIPasteboard pasteboardWithName:kGPKeyChainServiceName create:YES];
    NSDictionary* dic = @{value : identifier};
    NSData* dicData = [NSKeyedArchiver archivedDataWithRootObject:dic];
    [pb setData:dicData forPasteboardType:kGPPasteboardType];
}

- (NSString *)readPasteBoradforIdentifier:(NSString *)identifier
{
    UIPasteboard* pb = [UIPasteboard pasteboardWithName:kGPKeyChainServiceName create:YES];
    NSDictionary* dic = [NSKeyedUnarchiver unarchiveObjectWithData:[pb dataForPasteboardType:kGPPasteboardType]];
    return dic[identifier];
}




@end
