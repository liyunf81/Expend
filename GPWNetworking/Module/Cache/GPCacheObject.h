//
//  GPCacheObject.h
//  GPWNetworking
//
//  Created by Angle on 15/9/14.
//  Copyright © 2015年 Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPCacheObject : NSObject

@property (nonatomic, copy, readonly) NSData* content;                      //缓存数据
@property (nonatomic, assign, readonly) NSInteger requestID;
@property (nonatomic, copy, readonly) NSDate* lastUpdateTime;               //上次更新时间
@property (nonatomic, assign, readonly, getter=isOutDated) BOOL outDated;   //是否过期
@property (nonatomic, assign ,readonly, getter=isEmpty) BOOL empty;         //是否为空

/**
 *  初始化缓存对象
 *
 *  @param content 内容
 *
 *  @return 返回对象
 */
- (instancetype) initWithContent:(NSData *)content requestID:(NSInteger)requestId;

/**
 *  更新缓存对象
 *
 *  @param content 缓存内容
 */
- (void)updateContent:(NSData *)content requestId:(NSInteger)requestID;
@end
