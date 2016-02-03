//
//  GPLogger.m
//  GPWNetworking
//
//  Created by Angle on 15/9/15.
//  Copyright © 2015年 Feng. All rights reserved.
//

#import <CocoaLumberjack/CocoaLumberjack.h>

#import "GPLogger.h"
#import "GPURLResponse.h"
#import "GPAppContext.h"
#import "GPNetworkingConfigure.h"
#import "NSMutableString+GPNetworkingMethods.h"
#import "GPFileManager.h"
#import "NSString+GPNetworkingMethods.h"
#import "NSDictionary+Swizzling.h"

#ifdef DEBUG
static const int ddLogLevel = DDLogLevelVerbose;
#else
static const int ddLogLevel = DDLogLevelError;
#endif

@implementation GPLogger

#pragma mark - 静态方法
+ (void) logDebugInfoWithRequest:(NSURLRequest *)request apiName:(NSString *)apiName requestParams:(id)requestParams httpMethod:(NSString *)httpMethod
{
     NSMutableString *logString = [NSMutableString stringWithString:@"\n\n**************************************************************\n*                       Request Start                        *\n**************************************************************\n\n"];
    [logString appendFormat:@"API Name:\t\t%@\n", apiName];
    [logString appendFormat:@"Method:\t\t\t%@\n", httpMethod];
#ifdef DEBUG
    [logString appendFormat:@"Public Key:\t\t%@\n", kGPNetworkingPublicKey];
    [logString appendFormat:@"Private Key:\t%@\n", kGPNetworkingPrivateKey];
#endif
    [logString appendFormat:@"Params:\n%@", requestParams];
    
    [logString appendURLRequest:request];
    
    [logString appendFormat:@"\n\n**************************************************************\n*                         Request End                        *\n**************************************************************\n\n\n\n"];
    [[GPLogger shareInstance] infoLog:logString];
    
}

+ (void)logDebugInfoWithResponse:(NSHTTPURLResponse *)response responseString:(NSString *)responseString request:(NSURLRequest *)request error:(NSError *)error
{
    BOOL shouldLogError = error ? YES : NO;
    
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n==============================================================\n=                        API Response                        =\n==============================================================\n\n"];
    
    [logString appendFormat:@"Status:\t%ld\t(%@)\n\n", (long)response.statusCode, [NSHTTPURLResponse localizedStringForStatusCode:response.statusCode]];
    [logString appendFormat:@"Content Json:\n\t%@\n\n", [[responseString dictionaryWithJsonString] description]];
    if (shouldLogError) {
        [logString appendFormat:@"Error Domain:\t\t\t\t\t\t\t%@\n", error.domain];
        [logString appendFormat:@"Error Domain Code:\t\t\t\t\t\t%ld\n", (long)error.code];
        [logString appendFormat:@"Error Localized Description:\t\t\t%@\n", error.localizedDescription];
        [logString appendFormat:@"Error Localized Failure Reason:\t\t\t%@\n", error.localizedFailureReason];
        [logString appendFormat:@"Error Localized Recovery Suggestion:\t%@\n\n", error.localizedRecoverySuggestion];
    }
    
    [logString appendString:@"\n---------------  Related Request Content  --------------\n"];
    
    [logString appendURLRequest:request];
    
    [logString appendFormat:@"\n\n==============================================================\n=                        Response End                        =\n==============================================================\n\n\n\n"];

    if (shouldLogError) {
        [[GPLogger shareInstance] errorLog:logString];
    }else
    {
        [[GPLogger shareInstance] infoLog:logString];
    }
}

+ (void)logDebugInfoWithCachedResponse:(GPURLResponse *)response methodName:(NSString *)methodName
{
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n==============================================================\n=                      Cached Response                       =\n==============================================================\n\n"];
    
    [logString appendFormat:@"API Name:\t\t%@\n", methodName];
#ifdef DEBUG
    [logString appendFormat:@"Public Key:\t\t%@\n", kGPNetworkingPublicKey];
    [logString appendFormat:@"Private Key:\t%@\n", kGPNetworkingPrivateKey];
#endif
    [logString appendFormat:@"Method Name:\t%@\n", methodName];
    [logString appendFormat:@"Params:\n%@\n\n", response.requestParams];
    [logString appendFormat:@"Content:\n\t%@\n\n", response.contentString];
    
    [logString appendFormat:@"\n\n==============================================================\n=                        Response End                        =\n==============================================================\n\n\n\n"];
    [[GPLogger shareInstance] infoLog:logString];
}

#pragma mark - 共有方法

+ (instancetype)shareInstance
{
    static dispatch_once_t dponce;
    static GPLogger* logger;
    dispatch_once(&dponce, ^{
        logger = [[GPLogger alloc] init];
    });
    
    return logger;
}

+ (void)load
{
    [super load];
    [NSDictionary changeDescriptionMethods];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [DDLog addLogger:[DDASLLogger sharedInstance]];
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        DDFileLogger* fileLog = [[DDFileLogger alloc] init];
        fileLog.maximumFileSize = 5 * 1024 * 1024; //5m
        [DDLog addLogger:fileLog];
        //允许控制台输出有颜色区分
        [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    }
    return self;
}

- (void)infoLog:(NSString *)msg
{
    NSString* msgString = [NSString stringWithFormat:@"%@:",[GPAppContext shareInstance].logCt];
    
    msgString = [NSString stringWithFormat:@"%@%@",msgString,msg];
    NSLog(@"%@",msgString);
//    DDLogInfo(msgString,nil);
}

- (void)waringLog:(NSString *)msg
{
    NSString* msgString = [NSString stringWithFormat:@"%@:",[GPAppContext shareInstance].logCt];
    
    msgString = [NSString stringWithFormat:@"%@%@",msgString,msg];
    NSLog(@"%@",msgString);
//    DDLogWarn(msgString,nil);
}

- (void)errorLog:(NSString *)message
{
    NSString* msgString = [NSString stringWithFormat:@"%@:",[GPAppContext shareInstance].logCt];
    
    msgString = [NSString stringWithFormat:@"%@%@",msgString,message];
    NSLog(@"%@",msgString);
    
//    DDLogDebug(msgString,nil);
}

- (void)serverLog:(NSString *)msg
{
    NSString* msgString = [NSString stringWithFormat:@"%@:",[GPAppContext shareInstance].logCt];
    
    msgString = [NSString stringWithFormat:@"%@%@",msgString,msg];
    NSLog(@"%@",msgString);
    
//    DDLogInfo(msgString,nil);
}


@end
