//
//  GPPlistManager.h
//  GPWNetworking
//
//  Created by Angle on 15/9/14.
//  Copyright © 2015年 Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPPlistManager : NSObject

@property (nonatomic, copy, readonly) NSString* fileName;
@property (nonatomic, copy) id listData;

//当文件存在时删除并且重新创建，当文件不存在，则创建一个
- (BOOL) saveData:(id)data withFileName:(NSString *)fileName;
- (BOOL) saveString:(NSString *)string withFileName:(NSString *)fileName;

- (BOOL) deletePlistFile:(NSString *)fileName;
- (id) loadDataWithFileName:(NSString *)fileName;
- (NSString *)loadStringWithFileName:(NSString *)fileName;

- (NSString *)getLibFilePath:(NSString *)fileName;
@end
