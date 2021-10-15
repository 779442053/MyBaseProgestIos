//
//  UnitilMastros.h
//  NBJKCardHome
//
//  Created by step_zhang on 2020/11/20.
//

#ifndef UnitilMastros_h
#define UnitilMastros_h

#import <UIKit/UIKit.h>
//获取系统对象
#define kApplication        [UIApplication sharedApplication]
#define kAppWindow          [UIApplication sharedApplication].delegate.window
#define kAppDelegate        [AppDelegate shareAppDelegate]
#define kRootViewController [UIApplication sharedApplication].delegate.window.rootViewController
//获取屏幕宽高
#define KScreenWidth [[UIScreen mainScreen] bounds].size.width
#define KScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreen_Bounds [UIScreen mainScreen].bounds]
//屏幕适配==6s 做的适配
#define kRealValueWidth(with) (with)*KScreenWidth/375.0
#define kRealValueHeight(height) (height)*KScreenHeight/667.0
////根据ip6的屏幕来拉伸===
#define kRealValue(with) ((with)*(KScreenWidth/375.0f))

#define K_APP_ISIOS11 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.f)
#define K_APP_ISIPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define ZWiPhoneX (K_APP_ISIOS11 && K_APP_ISIPHONE && (MIN(KScreenWidth,KScreenHeight) >= 375 && MAX(KScreenWidth,KScreenHeight) >= 812))/** 判断设备类型是否iPhoneX*/


static inline UIWindow * getMainWindow(){
    UIWindow *window = nil;
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes){
            if (windowScene.activationState == UISceneActivationStateForegroundActive){
                window = windowScene.windows.firstObject;
                break;
            }
        }
    }else{
        window = UIApplication.sharedApplication.delegate.window;
    }return window;
}
static inline CGFloat ZWStatusBarHeightT(){
    if (@available(iOS 13.0, *)) {
        return getMainWindow().windowScene.statusBarManager.statusBarFrame.size.height;
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        return [[UIApplication sharedApplication] statusBarFrame].size.height;
#pragma clang diagnostic pop
    }
}
#define ZWStatusBarHeight ZWStatusBarHeightT()
/// navigation bar
#define ZWNavBarHeight self.navigationController.navigationBar.frame.size.height
///  Status bar & navigation bar height
#define ZWStatusAndNavHeight (ZWStatusBarHeight + ZWNavBarHeight)
#define  ZWTabbarSafeBottomMargin (ZWiPhoneX ? 34.f : 0.f)
#define  ZWTabbarHeight (ZWiPhoneX ? (49.f+34.f) : 49.f)
#define ZW(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define ZWWWeakSelf(type)  __weak typeof(type) weak##type = type;
#define ZWWStrongSelf(type) __strong typeof(type) type = weak##type;
// 当前系统版本
#define CurrentSystemVersion [[UIDevice currentDevice].systemVersion doubleValue]
//当前语言K
#define KCurrentLanguage (［NSLocale preferredLanguages] objectAtIndex:0])

//APP版本号
#define KAPP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
/**
 没有判空,程序闪退
 
 2021-01-19 全局判断服务端返回空对象引起的程序闪退!
 */
#define ZWWOBJECT_IS_EMPYT(object) \
({ \
BOOL flag = NO; \
if ([object isKindOfClass:[NSNull class]] || object == nil || object == Nil || object == NULL) \
flag = YES; \
if ([object isKindOfClass:[NSString class]]) \
if ([(NSString *)object length] < 1) \
flag = YES; \
if ([object isKindOfClass:[NSArray class]]) \
if ([(NSArray *)object count] < 1) \
flag = YES; \
if ([object isKindOfClass:[NSDictionary class]]) \
if ([(NSDictionary *)object allKeys].count < 1) \
flag = YES; \
(flag); \
})

// 颜色值
#define COLOR_RGB(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#ifdef DEBUG
#define ZWWLog(fmt, ...) NSLog((@"\n[文件名:%s]\n""[函数名:%s]""[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define ZWWLog(...)
#endif

//获取在不同屏幕上的真实高度
#define kRealValueHeight_S(width) (width)*465.0/260.0
#define kRealValueHeight_H(width) (width)*290.0/260.0
#define LOGIN_COOKIE_KEY @"Cookie"
#define ISLogin @"NBISLogin"
#define LoginMobile @"mobile"
#define LoginPassworld @"password"

#endif /* UnitilMastros_h */
