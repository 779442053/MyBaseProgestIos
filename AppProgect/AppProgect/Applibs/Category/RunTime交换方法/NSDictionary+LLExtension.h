//
//  NSDictionary+LLExtension.h
//  LeLiaoAPP
//
//  Created by step_zhang on 2020/2/19.
//  Copyright © 2020 step_zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (LLExtension)
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonStr;

- (NSString*)jsonString;
@end

NS_ASSUME_NONNULL_END
