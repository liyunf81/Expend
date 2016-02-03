//
//  GPNetworkBaseViewModel.h
//  GPFruitShop
//
//  Created by feng on 16/1/9.
//  Copyright © 2016年 Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSubject;
@class GPNetworkBaseModel;
@interface GPNetworkBaseViewModel : NSObject

/**
 *  请求失败
 */
@property (nonatomic, strong, readonly) RACSubject* requestFaild;

/**
 *  请求成功
 */
@property (nonatomic, strong, readonly) RACSubject* requestSuccess;

/**
 *  基本的网络信息
 */
@property (nonatomic, strong, readwrite) GPNetworkBaseModel* baseModel;
/**
 *  发送数据
 *
 *  @param value 数据
 */
- (BOOL)sendData:(id)value;

@end
