//
//  ZWBaseViewModelProtocol.h
//  NBJKCardHome
//
//  Created by step_zhang on 2020/11/24.
//

#import <Foundation/Foundation.h>
#import "ZSKNetworking.h"
NS_ASSUME_NONNULL_BEGIN

@protocol ZWBaseViewModelProtocol <NSObject>
@property (strong, nonatomic)ZSKNetworking *request;
/**
 *  初始化
 */
- (void)zw_initialize;

@end

NS_ASSUME_NONNULL_END
