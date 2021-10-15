//
//  ZSKMemoryCache.h
//
//  AppProgect
//
//  Created by step_zhang on 2021/9/7.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZSKMemoryCache : NSObject

/**
 *  将数据写入内存
 *
 *  @param data 数据
 *  @param key  键值
 */
+ (void)writeData:(id) data forKey:(NSString *)key;

/**
 *  从内存中读取数据
 *
 *  @param key 键值
 *
 *  @return 数据
 */
+ (id)readDataWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
