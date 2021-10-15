//
//  ZWDataManager.h
//  NBJKCardHome
//
//  Created by step_zhang on 2020/11/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWDataManager : NSObject
/**
 *  保存用户数据
 */
+ (void)saveUserData;

/**
 *  读取用户数据
 */
+ (void)readUserData;

/**
 *  删除用户数据
 */
+ (void)removeUserData;
@end

NS_ASSUME_NONNULL_END
