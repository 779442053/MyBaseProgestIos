//
//  ZWTabBarController.h
//  NBJKCardHome
//
//  Created by step_zhang on 2020/11/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWTabBarController : UITabBarController
/** 显示小红点 */
- (void)showBadgeOnItemIndex:(NSInteger)index
                   withValue:(NSInteger)badgeVal;

/** 隐藏小红点 */
- (void)hideBadgeOnItemIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
