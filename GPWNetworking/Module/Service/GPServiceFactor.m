//
//  GPServiceFactor.m
//  GPFruit
//
//  Created by Angle on 15/9/30.
//  Copyright © 2015年  果铺电子商务有限公司. All rights reserved.
//

#import "GPServiceFactor.h"
#import "GPServiceBase.h"
#import "GPServiceBaiduCity.h"

@implementation GPServiceFactor

+ (GPServiceBase *)createService:(NSString *)service
{
    GPServiceBase* resutlService = nil;
    if ([service isEqualToString:@"baidu"]) {
        resutlService = [[GPServiceBaiduCity alloc] init];
    }else
    {
        resutlService = [[GPServiceBase alloc] init];
    }
    return resutlService;
}


@end
