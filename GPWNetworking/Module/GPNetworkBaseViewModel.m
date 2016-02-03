//
//  GPNetworkBaseViewModel.m
//  GPFruitShop
//
//  Created by feng on 16/1/9.
//  Copyright © 2016年 Feng. All rights reserved.
//

#import "GPNetworkBaseViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface GPNetworkBaseViewModel()

@property (nonatomic, strong, readwrite) RACSubject* requestFaild;
@property (nonatomic, strong, readwrite) RACSubject* requestSuccess;

@end

@implementation GPNetworkBaseViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _requestFaild = [RACSubject subject];
        _requestSuccess = [RACSubject subject];
    }
    return self;
}

- (void)dealloc
{
    _requestSuccess = nil;
    _requestFaild = nil;
    _baseModel = nil;
}

- (BOOL)sendData:(id)value
{
    return value != nil;
}

@end
