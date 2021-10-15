//
//  UIViewController+LYCurrentVC.h
//  ImagePicker
//
//  Created by Teonardo on 2019/7/18.
//  Copyright © 2019 Teonardo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (LYCurrentVC)

/**
 获取当前的视图控制器

 @return <#return value description#>
 */
+ (UIViewController *)ly_currrentVC;

@end

NS_ASSUME_NONNULL_END
