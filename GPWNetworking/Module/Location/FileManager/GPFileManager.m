//
//  GPFileManager.m
//  GPWNetworking
//
//  Created by Angle on 15/9/15.
//  Copyright © 2015年 Feng. All rights reserved.
//

#import "GPFileManager.h"

@implementation GPFileManager

+ (NSString *)getDocumentFilePath:(NSString *)fileName
{
    NSString* libPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString* filePath = [libPath stringByAppendingPathComponent:fileName];
    return filePath;
}

+ (NSString *)getLibFilePath:(NSString *)fileName
{
    NSString* libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString* filePath = [libPath stringByAppendingPathComponent:fileName];
    return filePath;
}
@end
