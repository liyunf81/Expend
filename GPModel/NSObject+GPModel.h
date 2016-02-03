
//
//  NSObject+GPModel.h
//  GPModel
//
//  Created by feng on 15/12/29.
//  Copyright © 2015年 feng. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  可以将json转换成oc对象，也可以将oc对象转化为json对象。
 *  使用key-value来设置对象
 *  实现了NSCopying,NSCoding,isEqual,hash,description.
 */
@interface NSObject (GPModel)
/**
 *  通过一个json数据创建一个新的oc对象
 *
 *  @param json json数据,可能是NSString,NSDictionary,NSData.
 *
 *  @return oc对象，如果出错，则返回nil
 */
+ (instancetype)gpModelWithJSON:(id)json;

/**
 *  通过json字典数据创建一个新的oc对象
 *
 *  @param jsonDic json数据字典,其key为对象的属性.
 *  无效的key-value值将会被忽略，避免程序崩溃
 *  jsonDic的key 为对象的属性名，value为属性的值.
 *  如果value's的类型不能匹配属性类型，则会按照下面的规则进行转换
 *  NSString or NSNumber -> c number.
 *  NSString -> NSdate,解析格式为常见的日期格式 如:yyyy-MM-dd HH:mm:ss
 *  NSString -> NSURL.
 *  NSValue  -> struct , union,比如CGRect,CGSize...
 *  NSString -> SEL,Class
 *
 *  @return oc对象，如果出错，则返回nil.
 */
+ (instancetype)gpModelWithDictionary:(NSDictionary *)jsonDic;

/**
 *  根据json对象 转换成一个对象数组
 *
 *  @param json json数据,类型必须为NSArray,NSString,NSData.
 *
 *  @return Array,如果有错误发生，则返回nil.
 */
+ (NSArray*)gpModelListWithJSON:(id)json;

/**
 *  根据json对象转换成一个字典数组
 *
 *  @param json json数据，类型必须为NSDictionary,NSString,NSData.
 *
 *  @return 字典,如果有错误发生，则返回nil.
 */
+ (NSDictionary *)gpModelDictionaryWithJson:(id)json;

/**
 *  通过json数据 设置oc对象属性
 *
 *  @param json json数据，忽略无效的值
 *
 *  @return 设置是否成功
 */
- (BOOL)gpModelSetWithJSON:(id)json;

/**
 *  通过json字典，设置oc对象属性
 *
 *  @param jsonDic json字典，
 *
 *  @return 设置是否成功
 */
- (BOOL)gpModelSetWithDictionary:(NSDictionary*)jsonDic;

/**
 *  根据oc属性 转换成一个json对象
 *
 *  @return 返回json对象，类型为NSDictionary或者NSArray，nil.
 */
- (id)gpModelToJSONObject;

/**
 *  根据oc的属性，转换成一个json string data.
 *
 *  @return json string data,如果有错误发生，则会返回nil.
 */
- (NSData *)gpModelToJSONData;

/**
 *  根据oc的属性,转换成一个json string
 *
 *  @return json string ，如果有错误发送，则会返回nil.
 */
- (NSString *)gpModelToJSONString;



/**
 *  拷贝对象的属性并且创建新的oc对象
 *
 *  @return 新对象，如果有错误发送，则会返回nil
 */
- (id)gpModelCopy;

/**
 *  将对象编码
 *
 *  @param aCoder 存储对象
 */
- (void)gpModelEncodeWithCoder:(NSCoder *)aCoder;

/**
 *  为对象解码
 *
 *  @param aCoder 存储对象
 *
 *  @return 返回解码的对象
 */
- (id)gpModelInitWithCoder:(NSCoder *)aCoder;

/**
 *  获取对象的hash值
 *  同isequial相互作用
 *  @return 返回hash值
 */
- (NSUInteger)gpModelHash;

/**
 *  根据属性来比较两个对象的等同性
 *
 *  @param model 其他对象
 *
 *  @return 是否相等.
 */
- (BOOL)gpModelIsEqual:(id)model;

@end

/**
 *  为NSArray提供的一个 json-model方法
 */
@interface NSArray (GPModel)

/**
 *  将json对象转换成一个数组对象,
 *  json对象必须是一个数组
 *
 *  @param cls  NSArray所持对象的类
 *  @param json json数据，类型可为NSString,NSArray,NSData.
 *
 *  @return 返回一个数组，如果有错误发生，则返回nil.
 */
+ (NSArray *)gpModelArrayWithClass:(Class)cls JSON:(id)json;

@end

/**
 *  为NSDictionary 提供一个 json-model方法
 */
@interface NSDictionary (GPModel)

/**
 *  将json对象转换成一个字典
 *
 *  @param cls  value的类型
 *  @param json json对象,类型可为:NSDictionary,NSString,NSData.
 *
 *  @return A Dictionary,如果有错误发生，则返回nil.
 */
+ (NSDictionary *)gpModelDictonryWithClass:(Class)cls JSON:(id)json;

@end

/**
 *  如果默认的模型转换功能无法满足您的要求,实现一个或多个协议里面的方法，改变默认的模型转换工作.
 *  不是必须遵循此协议，代码内部会自动为您自动转换
 */
@protocol GPModel <NSObject>
@optional

/**
 *  自定义属性映射
 *  如果json数据中 有存在model中没有包含的属性值，或者不匹配，那么实现这个方法.
 *
 *  @return 返回自定义属性映射.
 */
+ (NSDictionary *)gpModelCustomPropertyMapper;

/**
 *  容器属性的类型映射
 *  如果属性是一个容器,比如NSArray,NSSet/NSDictionary,
 *  实现此方法，告诉模型转换方法，将什么类型放入容器中.
 *  @return 返回容器属性映射
 */
+ (NSDictionary *)gpModelContainerPropertyClassMapper;

/**
 *  如果你想用不同的类型创建一个实例，那么就需要实现此方法
 *  如果实现了此方法，那么会在gpModelWithJSON,gpModelWithDictionary中调用
 *  @param dictionary
 *
 *  @return a Class,或者当前类型
 */
+ (Class)gpModelCustomClassForDictionary:(NSDictionary *)dictionary;

/**
 *  在黑名单中属性名称，在模型转换过程中，都会被忽略.
 *
 *  @return 黑名单数组
 */
+ (NSArray *)gpModelPropertyBlacklist;

@end
