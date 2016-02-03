//
//  GPPlistManager.m
//  GPWNetworking
//
//  Created by Angle on 15/9/14.
//  Copyright © 2015年 Feng. All rights reserved.
//

#import "GPPlistManager.h"

@implementation GPPlistManager

///////////////////////////////////

#pragma mark -
#pragma mark 共有方法
- (BOOL)saveData:(id)data withFileName:(NSString *)fileName
{
    if (!([data isKindOfClass:[NSArray class]] ||
          [data isKindOfClass:[NSDictionary class]])) {
        return NO;
    }
    
    if ([self isExistWithFileNameInLibrary:fileName]) {
        [self deletePlistFile:fileName];
    }
    
    NSError* error = nil;
    NSString* filePath = [self getLibFilePath:fileName];
    NSData* plistData = [NSPropertyListSerialization dataWithPropertyList:data
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                                  options:0
                                                                    error:&error];
    if (plistData) {
        [[NSFileManager defaultManager]createFileAtPath:filePath contents:nil attributes:nil];
        [plistData writeToFile:filePath atomically:YES];
        return YES;
    }
    
    if (error) {
        //TODO: log
    }
    return NO;
}

- (BOOL)saveString:(NSString *)string withFileName:(NSString *)fileName
{
    if ([self isExistWithFileNameInLibrary:fileName]) {
        [self deletePlistFile:fileName];
    }
    
    NSError* error = nil;
    NSString* filePath = [self getLibFilePath:fileName];
    BOOL ret = [string writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (!ret && error) {
        //TODO: log
    }
    
    return ret;
}

- (BOOL)deletePlistFile:(NSString *)fileName
{
    if ([self isExistWithFileNameInLibrary:fileName]) {
        return YES;
    }
    
    NSError* error = nil;
    NSString* filePath = [self getLibFilePath:fileName];
    if (![[NSFileManager defaultManager] removeItemAtPath:filePath error:&error]) {
        //TODO: log
        return NO;
    }
    
    return YES;
}

- (id)loadDataWithFileName:(NSString *)fileName
{
    NSString* filePath = [self getFilePath:fileName];
    if (filePath) {
        NSPropertyListFormat format;
        NSError* error;
        NSData* plistData = [[NSFileManager defaultManager] contentsAtPath:filePath];
        id result = [NSPropertyListSerialization propertyListWithData:plistData
                                                              options:0
                                                               format:&format
                                                                error:&error];
        if (!result) {
            //TODO log
        }
        return result;
    }

    return nil;
}

- (NSString *)loadStringWithFileName:(NSString *)fileName
{
    NSString* filePath = [self getFilePath:fileName];
    if (filePath) {
        NSError* error = nil;
        NSString* content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
        if (!content && error) {
            //TODO Log
        }
        return content;
    }
    return nil;
}

- (NSString *)getLibFilePath:(NSString *)fileName
{
    NSString* libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    if (![fileName hasSuffix:@".plist"]) {
        fileName = [fileName stringByAppendingString:@".plist"];
    }
    NSString* filePath = [libPath stringByAppendingPathComponent:fileName];
    return filePath;
}

/**
 *  获取文件名对应的路径，可能在bundle或者lib中
 *
 *  @param fileName 文件名
 *
 *  @return 返回文件路径
 */
- (NSString *)getFilePath:(NSString *)fileName
{
    BOOL fileFounded = YES;
    NSString* filePath = nil;
    fileFounded = [self isExistWithFileNameInLibrary:fileName];
    if (!fileFounded) {
        fileFounded = [self isExistWithFileNameInBundle:fileName];
    }else
    {
        filePath = [self getLibFilePath:fileName];
    }
    
    if (fileFounded) {
        if (!filePath) {
            if (![fileName hasSuffix:@".plist"]) {
                fileName = [fileName stringByAppendingString:@".plist"];
            }
            filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
        }
        return filePath;
    }
    return nil;
}

#pragma mark -
#pragma mark 私有方法
- (BOOL)isExistWithFileNameInLibrary:(NSString *)fileName
{
    NSString *filePath = [self getLibFilePath:fileName];
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

- (BOOL)isExistWithFileNameInBundle:(NSString *)fileName
{
    if (![fileName hasSuffix:@".plist"]) {
        fileName = [fileName stringByAppendingString:@".plist"];
    }
    NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    return filePath != nil;
}


@end
