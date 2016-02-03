//
//  UIDevice+GPWAddition.h
//  GPWNetworking
//
//  Created by Angle on 15/9/14.
//  Copyright © 2015年 Feng. All rights reserved.
//

/**
 *  此分类主要用来扩展UIDevice。使其可以获取一个相对独立的UDID，
 */
#import <UIKit/UIKit.h>

@interface UIDevice (GPAddition)

- (NSString *) GP_UUID;   //uuid
- (NSString *) GP_UDID;   //udid
- (NSString *) GP_macheineType; //设备类型
- (NSString *) GP_osType;  //系统类型
- (NSString *) GP_createUUID; //ios7 后系统的UDID不能使用，此是替代品


@end
