//
//  GPWUDIDCreator.h
//  GPWNetworking
//
//  Created by Angle on 15/9/14.
//  Copyright © 2015年 Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPUDIDCreator : NSObject

+ (instancetype)shareInstance;
- (NSString *)UDID;
- (void)saveUDID:(NSString *)udid;

@end
