//
//  UIApplication+LYURLTool.h
//  ImagePicker
//
//  Created by Teonardo on 2019/7/18.
//  Copyright © 2019 Teonardo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (LYURLTool)

/**
 打开URL

 @param url URL对象
 @param completion 完成回调, 判断是否成功
 */
+ (void)ly_openURL:(NSURL *)url completionHandler:(void (^__nullable)(BOOL success))completion;

/**
 打开当前应用的设置界面
 */
+ (void)ly_openSettings;

@end

NS_ASSUME_NONNULL_END
