//
//  ZWUserModel.h
//  NBJKCardHome
//
//  Created by step_zhang on 2020/11/20.
//

#import "ZWBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZWUserModel : ZWBaseModel <NSCoding>

@property (nonatomic, copy) NSString *token;

+ (instancetype)currentUser;

@end

NS_ASSUME_NONNULL_END
