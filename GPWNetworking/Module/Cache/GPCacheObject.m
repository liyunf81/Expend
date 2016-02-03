//
//  GPCacheObject.m
//  GPWNetworking
//
//  Created by Angle on 15/9/14.
//  Copyright © 2015年 Feng. All rights reserved.
//

#import "GPCacheObject.h"
#import "GPNetworkingConfigure.h"

@interface GPCacheObject ()

@property (nonatomic, copy, readwrite) NSData* content;
@property (nonatomic, copy, readwrite) NSDate* lastUpdateTime;
@property (nonatomic, assign, readwrite) NSInteger requestID;

@end

@implementation GPCacheObject

#pragma mark - life cycle
- (instancetype)initWithContent:(NSData *)content requestID:(NSInteger)requestId
{
    self = [super init];
    if (self) {
        self.content = content;
        self.requestID = requestId;
    }
    return self;
}

#pragma mark - 公共方法
- (void)updateContent:(NSData *)content requestId:(NSInteger)requestID
{
    self.content = content;
    self.requestID = requestID;
}

#pragma mark - 获取，设置方法
- (BOOL)isEmpty
{
    return self.content == nil;
}

- (BOOL) isOutDated
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastUpdateTime];
    return timeInterval > kGPCacheOutdateTimeSeconds;
}

- (void)setContent:(NSData *)content
{
    _content = [content copy];
    self.lastUpdateTime = [NSDate date];
}

@end
