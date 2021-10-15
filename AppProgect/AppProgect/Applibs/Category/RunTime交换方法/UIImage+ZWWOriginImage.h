//
//  UIImage+ZWWOriginImage.h
//  MyBaseProgect
//
//  Created by on 2018/5/9.
//  Copyright © 2018年  All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ZWWOriginImage)

// 传入 一个字符串 -> 返回 不被 渲染的原始图片

+ (id)ImageOriginalWithStrName:(NSString *)name;
@end
