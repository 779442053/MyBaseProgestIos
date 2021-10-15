//
//  UIColor+ZWColor.h
//  共享蜂
//
//  Created by  on 2017/12/17.
//  Copyright © 2017年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ZWColor)
/**
 * 使用16进制数字创建颜色
 */
+ (instancetype)ZW_colorWithHex:(uint32_t)hex;

/**
 * 随机颜色
 */
+ (instancetype)ZW_randomColor;

/**
 * RGB颜色
 */
+ (instancetype)ZW_colorWithRed:(uint8_t)red green:(uint8_t)green blue:(uint8_t)blue;

/**
 十六进制字符串显示颜色
 
 @param color 十六进制字符串
 @param alpha 透明度
 @return 颜色
 */
+ (UIColor *)ZW_colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;


/**
 *  @brief  渐变颜色
 *
 *  @param fromColor  开始颜色
 *  @param toColor    结束颜色
 *  @param height     渐变高度
 *
 *  @return 渐变颜色
 */
+ (UIColor*)ZW_gradientFromColor:(UIColor*)fromColor toColor:(UIColor*)toColor withHeight:(CGFloat)height;

+ (UIColor *)colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;

/**
 *  16进制转uicolor
 *
 *  @param color @"#FFFFFF" ,@"OXFFFFFF" ,@"FFFFFF"
 *
 *  @return uicolor
 */
+ (UIColor *)colorWithHexString:(NSString *)color;
@end
