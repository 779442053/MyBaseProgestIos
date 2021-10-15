//
//  UIApplication+LYURLTool.m
//  ImagePicker
//
//  Created by Teonardo on 2019/7/18.
//  Copyright © 2019 Teonardo. All rights reserved.
//

#import "UIApplication+LYURLTool.h"

@implementation UIApplication (LYURLTool)

+ (void)ly_openURL:(NSURL *)url completionHandler:(void (^__nullable)(BOOL success))completion {
    UIApplication *application = [UIApplication sharedApplication];
    if ([application canOpenURL:url]) {
        if (@available(iOS 10.0, *)) {
            [application openURL:url options:@{} completionHandler:completion];
        } else {
            BOOL success = [application openURL:url];
            !completion ? : completion(success);
        }
    } else {
        !completion ? : completion(NO);
    }
}

+ (void)ly_openSettings {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [self ly_openURL:url completionHandler:nil];
}

@end
