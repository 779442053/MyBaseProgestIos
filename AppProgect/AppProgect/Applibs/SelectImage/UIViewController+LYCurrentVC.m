//
//  UIViewController+LYCurrentVC.m
//  ImagePicker
//
//  Created by Teonardo on 2019/7/18.
//  Copyright © 2019 Teonardo. All rights reserved.
//

#import "UIViewController+LYCurrentVC.h"

@implementation UIViewController (LYCurrentVC)

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)ly_currrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self ly_getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

+ (UIViewController *)ly_getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;

    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self ly_getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self ly_getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    
    return currentVC;
}

@end
