//
//  NSString+GPNetworkingMethods.h
//  GPWNetworking
//
//  Created by Angle on 15/9/15.
//  Copyright © 2015年 Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (GPNetworkingMethods)

- (NSString *)GPMd5;
- (NSDictionary *)dictionaryWithJsonString;
- (NSArray *)arrayWithJsonString;

-(NSString *)normalNumToBankNum;
-(NSString *)bankNumToNormalNum;

+ (NSString*)GpUrlString:(NSString *)method;


@end