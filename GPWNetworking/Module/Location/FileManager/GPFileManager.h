//
//  GPFileManager.h
//  GPWNetworking
//
//  Created by Angle on 15/9/15.
//  Copyright © 2015年 Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPFileManager : NSObject

+ (NSString *)getDocumentFilePath:(NSString *)fileName;
+ (NSString *)getLibFilePath:(NSString *)fileName;

@end
