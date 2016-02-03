//
//  GPCommonParamsCreator.h
//  GPWNetworking
//
//  Created by Angle on 15/9/15.
//  Copyright © 2015年 Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPCommonParamsCreator : NSObject

/**
 *  生成公用的网络请求参数
 *
 *  @return 返回请求参数
 */
+ (NSDictionary *)commonParamsDictionary;
/**
 *  生成公用的log网络请求参数
 *
 *  @return 返回请求参数
 */
+ (NSDictionary *)commonParamsDictionaryForLog;

@end
