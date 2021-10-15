//
//  AppDelegate+HTAppdelegateCategory.h
//  AppProgect
//
//  Created by step_zhang on 2021/9/7.
//

#import "AppDelegate.h"
#import "Reachability.h"
NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (HTAppdelegateCategory)
//初始化 window
-(void)initWindow;
//初始化 UMeng
-(void)initUMengWithKey:(NSString *)key;
//初始化用户系统
-(void)initUserManager;
//键盘事件
- (void)zw_setKeyBord;
//监听网络状态
- (void)monitorNetworkStatus:(NetworkStatus )status;
- (void)versionUpdate;
@end

NS_ASSUME_NONNULL_END
