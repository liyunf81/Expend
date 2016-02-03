//
//  NSURLRequest+GPNetworkingMethods.m
//  GPWNetworking
//
//  Created by Angle on 15/9/15.
//  Copyright © 2015年 Feng. All rights reserved.
//

#import <objc/runtime.h>

#import "NSURLRequest+GPNetworkingMethods.h"

static void* GPNetworkingRequestParams;

@implementation NSURLRequest (GPNetworkingMethods)

- (void)setRequestParams:(NSDictionary *)requestParams
{
    objc_setAssociatedObject(self, &GPNetworkingRequestParams, requestParams, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)requestParams
{
    return objc_getAssociatedObject(self, &GPNetworkingRequestParams);
}

@end
