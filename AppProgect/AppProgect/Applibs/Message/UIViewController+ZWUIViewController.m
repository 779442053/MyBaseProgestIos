//
//  UIViewController+ZWUIViewController.m
//  Bracelet
//
//  Created by 张威威 on 2017/11/8.
//  Copyright © 2017年 ShYangMiStepZhang. All rights reserved.
//

#import "UIViewController+ZWUIViewController.h"

@implementation UIViewController (ZWUIViewController)
+ (UIViewController *)rootViewController
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    UIView *frontView;
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                
                frontView = tmpWin;
                
                break;
            }
        }
    }
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]){
        result = nextResponder;
    }
    else{
        result = window.rootViewController;
    }
    return result;
}
@end
