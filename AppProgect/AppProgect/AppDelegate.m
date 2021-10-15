//
//  AppDelegate.m
//  AppProgect
//
//  Created by step_zhang on 2021/9/1.
//

#import "AppDelegate.h"
#import "AppDelegate+HTAppdelegateCategory.h"
#import "ZWDataManager.h"
#import<CoreTelephony/CTCellularData.h>
#import <AFNetworking/AFNetworking.h>
@interface AppDelegate ()
@property (strong,nonatomic) Reachability* reachablity;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initWindow];
    //1.获取网络权限 根绝权限进行人机交互
    if (__IPHONE_10_0) {
        self.reachablity = [Reachability reachabilityWithHostName:@"www.taobao.com"];
        [self.reachablity startNotifier];
        NetworkStatus status = [self.reachablity currentReachabilityStatus];
        [self monitorNetworkStatus:status];
        [self networkStatus:application didFinishLaunchingWithOptions:launchOptions];
    }else {
        //2.2已经开启网络权限 监听网络状态
        [self addReachabilityManager:application didFinishLaunchingWithOptions:launchOptions];
    }
    
    [self initUserManager];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    [ZWDataManager saveUserData];
    [[UIApplication alloc] setApplicationIconBadgeNumber:0];
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[UIApplication alloc] setApplicationIconBadgeNumber:0];
}
- (void)applicationWillTerminate:(UIApplication *)application {
    [ZWDataManager saveUserData];
    [[UIApplication alloc] setApplicationIconBadgeNumber:0];
}
//当收到Received memory warning.会调用次方法
-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    [mgr cancelAll];
    [mgr.imageCache clearWithCacheType:SDImageCacheTypeAll completion:nil];
}
- (void)networkStatus:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    //2.根据权限执行相应的交互
    CTCellularData *cellularData = [[CTCellularData alloc] init];
    /*
     此函数会在网络权限改变时再次调用
     */
    cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
        switch (state) {
            case kCTCellularDataRestricted:
                NSLog(@"Restricted");
                //2.1权限关闭的情况下 再次请求网络数据会弹出设置网络提示
                [self getAppInfo];
                break;
            case kCTCellularDataNotRestricted:
                NSLog(@"NotRestricted");
                //2.2已经开启网络权限 监听网络状态
                [self addReachabilityManager:application didFinishLaunchingWithOptions:launchOptions];
                [self getInfo_application:application didFinishLaunchingWithOptions:launchOptions];
                break;
            case kCTCellularDataRestrictedStateUnknown:
                NSLog(@"Unknown");
                //2.3未知情况 （还没有遇到推测是有网络但是连接不正常的情况下）
                [self getAppInfo];
                break;
            default:
                break;
        }
    };
}
- (void)addReachabilityManager:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //在这里,可以发送网络变化通知,做到每个界面适时监听网络状态
        //或者,在请求的回调函数里面,根据code值  确定网络状态,进行界面顶部提示
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                ZWWLog(@"网络不通：%@",@(status) );
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                ZWWLog(@"网络通过WIFI连接：%@",@(status));
                [self getInfo_application:application didFinishLaunchingWithOptions:launchOptions];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                ZWWLog(@"网络通过无线连接：%@",@(status) );
                [self getInfo_application:application didFinishLaunchingWithOptions:launchOptions];
                break;
            }
            default:
                break;
        }
    }];
    [afNetworkReachabilityManager startMonitoring];  //开启网络监视器；
}
///网络权限.修改
- (void)getInfo_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    ///此时,手机已经获取到了网络..开始配置第三方服
    //有网,添加自己的网络监测工具类
    NetworkStatus status = [self.reachablity currentReachabilityStatus];
    [self monitorNetworkStatus:status];
    //配置第三方
}
-(void)getAppInfo{
    ZWWLog(@"有网络,可以配置第三方")
    self.reachablity = [Reachability reachabilityWithHostName:@"https://www.baidu.com"];
    [self.reachablity startNotifier];
    NetworkStatus status = [self.reachablity currentReachabilityStatus];
    [self monitorNetworkStatus:status];
}
+ (AppDelegate *)shareAppDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
@end
