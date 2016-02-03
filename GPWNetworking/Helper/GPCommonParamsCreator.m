//
//  GPCommonParamsCreator.m
//  GPWNetworking
//
//  Created by Angle on 15/9/15.
//  Copyright © 2015年 Feng. All rights reserved.
//

#import "GPCommonParamsCreator.h"
#import "GPAppContext.h"
#import "NSDictionary+GPNetworkingMethods.h"

@implementation GPCommonParamsCreator

+ (NSDictionary *)commonParamsDictionary
{
    GPAppContext* context = [GPAppContext shareInstance];
    return @{};
}

+ (NSDictionary *)commonParamsDictionaryForLog
{
    GPAppContext* context = [GPAppContext shareInstance];
    return @{};
}

@end
