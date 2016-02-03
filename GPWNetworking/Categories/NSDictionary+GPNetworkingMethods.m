//
//  NSDictionary+GPNetworkingMethods.m
//  GPWNetworking
//
//  Created by Angle on 15/9/14.
//  Copyright © 2015年 Feng. All rights reserved.
//

#import "NSDictionary+GPNetworkingMethods.h"
#import "NSArray+GPNetworkingMethods.h"

@implementation NSDictionary (GPNetworkingMethods)

- (NSString *)GPUrlParamsString
{
    NSArray* sortedArray = [self GPTransformedUrlParamsArray];
    return [sortedArray GPParamsString];
}

- (NSString *)GPJsonString
{
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted error:NULL];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSArray *)GPTransformedUrlParamsArray
{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
    {
        NSString* tmp = [NSString stringWithFormat:@"%@",obj];
        NSString* tranString = [tmp stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
        [result addObject:[NSString stringWithFormat:@"%@=%@",key,tranString]];
    }];
    return result;
}


@end
