//
//  UIFont+ZWWFount.m
//  MyBaseProgect
//
//  Created by  on 2018/5/9.
//  Copyright © 2018年 . All rights reserved.
//

#import "UIFont+ZWWFount.h"
#import <objc/runtime.h>
// 设备
#define IS_IPAD     [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad
#define IS_IPHONE   [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone
#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )480) < DBL_EPSILON )
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )568) < DBL_EPSILON )
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )667) < DBL_EPSILON )
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )960) < DBL_EPSILON )

// 放大的字号数
#define IPHONE6_INCREMENT 2
#define IPHONE6PLUS_INCREMENT 3
/*
 
 UI给的图是以6s为标准的 标注,在pluse 或者 更大的 设备上,会显得很小,失真
 
 2021-01-19
 这里的放大字号数的意思是，如果设置的系统字体大小为15，那么在4、5上面的大小就是15，而在6上就增加2，即17，在6P上就增加3，即18。具体改变多少根据需求设定。这个为了显示出区别，暂且改为10便于观察
 全局适配UI标注字体和实际字体.根据不同的屏幕尺寸,作相应的放大和缩小  (6s设备为UI设计标准尺寸)
 */
@implementation UIFont (ZWWFount)

+(void)load
{
    // 获取交换后的方法
    Method newMethod = class_getClassMethod([self class], @selector(adjustFont:));
    // 获取替换前的方法
    Method method = class_getClassMethod([self class], @selector(systemFontOfSize:));
    // 交换
    method_exchangeImplementations(newMethod, method);
}
+ (UIFont *)adjustFont:(CGFloat)fontSize{
    UIFont * newFont = nil;
    if (IS_IPHONE_6) {
        newFont = [UIFont adjustFont:fontSize + IPHONE6_INCREMENT];
    }else if (IS_IPHONE_6_PLUS){
        newFont = [UIFont adjustFont:fontSize + IPHONE6PLUS_INCREMENT];
    }else{
        newFont = [UIFont adjustFont:fontSize];
    }
    return newFont;
}


@end
