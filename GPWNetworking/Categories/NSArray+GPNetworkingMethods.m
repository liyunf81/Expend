//
//  NSArray+GPNetworkingMethods.m
//  GPWNetworking
//
//  Created by Angle on 15/9/14.
//  Copyright © 2015年 Feng. All rights reserved.
//

#import "NSArray+GPNetworkingMethods.h"

@implementation NSArray (GPNetworkingMethods)

- (NSString *)GPParamsString
{
    NSMutableString *paramString = [[NSMutableString alloc] init];
    
    NSArray *sortedParams = [self sortedArrayUsingSelector:@selector(compare:)];
    [sortedParams enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([paramString length] == 0) {
            [paramString appendFormat:@"%@", obj];
        } else {
            [paramString appendFormat:@"&%@", obj];
        }
    }];
    
    return paramString;
}


- (NSString *)GPJsonString
{
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:NULL];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end
