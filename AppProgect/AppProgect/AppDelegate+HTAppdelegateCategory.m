//
//  AppDelegate+HTAppdelegateCategory.m
//  AppProgect
//
//  Created by step_zhang on 2021/9/7.
//

#import "AppDelegate+HTAppdelegateCategory.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "ZSKNetworking.h"
#import "ZWSaveTool.h"
#import "ZWAPIConseKey.h"
#import "ZWDataManager.h"
#import "HTLoginViewController.h"
#import "ZWTabBarController.h"
@implementation AppDelegate (HTAppdelegateCategory)
-(void)initUMengWithKey:(NSString *)key{
    //在网络连接成功的情况下,可以进行第三方平台的配置
}
#pragma mark ————— 网络状态监听 —————
- (void)monitorNetworkStatus:(NetworkStatus )status{
   //全局监听网络
}
#pragma mark ————— 初始化window —————
-(void)initWindow{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UIViewController alloc]init];
    BOOL islogin = [ZWSaveTool BoolForKey:ISLogin];
    if (islogin) {
        //获取新的session.登陆过,更新token
        [self SetMainVC];
    }else{
        //去登陆,跳转到登录界面
        HTLoginViewController *login = [HTLoginViewController new];
        ZWNavigationController *vc = [[ZWNavigationController alloc] initWithRootViewController:login];
        self.window.rootViewController = vc;
    }
    [[UIButton appearance] setExclusiveTouch:YES];
   //解决网页有黑边
   if(@available(iOS 11.0, *)){
       [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
       UITableView.appearance.estimatedRowHeight = 0;
       UITableView.appearance.estimatedSectionHeaderHeight = 0;
       UITableView.appearance.estimatedSectionFooterHeight = 0;
   }else{

   }
}
//登录之后,进到主页
-(void)SetMainVC{
    self.tabBarController = [[ZWTabBarController alloc]init];
    ZWNavigationController *nav = [[ZWNavigationController alloc]initWithRootViewController:self.tabBarController];
    self.window.rootViewController = nav;
}
-(void)initUserManager{
    //ZWWLog(@"设备IMEI ：%@",[OpenUDID value]);//移动设备国际识别码，又称为国际移动设备标识）是手机的唯一识别号码。
    //c14c1040f1e69c04e40a656637c3acd377cca4c4
    [ZWDataManager readUserData];
}
#pragma ===========键盘的回收事件 =============
/**
 2021-01-19 全局配置键盘回收事件.避免键盘弹起,遮挡输入框的情况
 */
-(void)zw_setKeyBord{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];//获取单例
    manager.enable = YES;//控制整个功能是否启用
    manager.shouldResignOnTouchOutside = YES;//启用手势触摸.控制点击背景,是否收起键盘
    manager.toolbarDoneBarButtonItemText =@"完成";//将右边Done改成完成
    manager.enableAutoToolbar = YES;//显示输入框提示栏
    manager.toolbarManageBehaviour =IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框;
    manager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义,(使用TextField的tintColor属性IQToolbar，否则色调的颜色是黑色 )
    manager.shouldShowToolbarPlaceholder = YES; // 是否显示占位文字
    manager.placeholderFont = [UIFont boldSystemFontOfSize:17]; // 设置占位文字的字体
    manager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
}
//检查版本更新
- (void)versionUpdate{
    
}
@end
