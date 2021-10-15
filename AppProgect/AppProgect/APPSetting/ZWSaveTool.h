//
//  ZWSaveTool.h
//  NBJKCardHome
//
//  Created by step_zhang on 2020/11/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWSaveTool : NSObject
+ (id)objectForKey:(NSString *)defaultName;
+ (BOOL)BoolForKey:(NSString *)defaultName;
+ (void)setObject:(id)value forKey:(NSString *)defaultName;
+ (void)setBool:(BOOL)value forKey:(NSString *)defaultName;
@end

NS_ASSUME_NONNULL_END
