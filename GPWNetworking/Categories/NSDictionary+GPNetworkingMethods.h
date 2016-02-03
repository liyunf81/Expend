//
//  NSDictionary+GPNetworkingMethods.h
//  GPWNetworking
//
//  Created by Angle on 15/9/14.
//  Copyright © 2015年 Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (GPNetworkingMethods)

//将参数转换会请求链接
- (NSString *)GPUrlParamsString;
//转换成json
- (NSString *)GPJsonString;
//将参数dic转换为编码了的链接
- (NSArray  *)GPTransformedUrlParamsArray;


@end
