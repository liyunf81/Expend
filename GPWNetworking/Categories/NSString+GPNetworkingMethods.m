//
//  NSString+GPNetworkingMethods.m
//  GPWNetworking
//
//  Created by Angle on 15/9/15.
//  Copyright © 2015年 Feng. All rights reserved.
//

#import "NSString+GPNetworkingMethods.h"
#import "GPNetworking.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (GPNetworkingMethods)

- (NSString *)GPMd5
{
    NSData* inputData = [self dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char outputData[CC_MD5_DIGEST_LENGTH];
    CC_MD5([inputData bytes], (unsigned int)[inputData length], outputData);
    NSMutableString* hashStr = [NSMutableString string];
    int i = 0;
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; ++i)
        [hashStr appendFormat:@"%02x", outputData[i]];
    
    return hashStr;
}

- (NSArray *)arrayWithJsonString
{
    NSData* jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error = nil;
    NSArray* retArray = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers error:&error];
    if (jsonData) {
        //TODO 打log
    }
    return retArray;
}

- (NSDictionary *)dictionaryWithJsonString
{
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        //TODO 打log
    }
    return dic;
}

-(NSString *)normalNumToBankNum
{
    NSString *tmpStr = [self bankNumToNormalNum];
    
    NSInteger size = (tmpStr.length / 4);
    
    NSMutableArray *tmpStrArr = [[NSMutableArray alloc] init];
    for (int n = 0;n < size; n++)
    {
        [tmpStrArr addObject:[tmpStr substringWithRange:NSMakeRange(n*4, 4)]];
    }
    
    [tmpStrArr addObject:[tmpStr substringWithRange:NSMakeRange(size*4, (tmpStr.length % 4))]];
    
    tmpStr = [tmpStrArr componentsJoinedByString:@" "];
    
    return tmpStr;
}

// 银行卡号转正常号 － 去除4位间的空格
-(NSString *)bankNumToNormalNum
{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

+ (NSString*)GpUrlString:(NSString *)method
{
    NSString* realUrl = [NSString stringWithFormat:@"%@/%@",kGPNetworkBaseURL,method];
    return realUrl;
}

@end
