//
//  GPServiceFactor.h
//  GPFruit
//
//  Created by Angle on 15/9/30.
//  Copyright © 2015年  果铺电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GPServiceBase;
@interface GPServiceFactor : NSObject

+ (GPServiceBase *)createService:(NSString *)service;

@end
