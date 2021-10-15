//
//  UIButton+ZWWBtn.h
//  MyBaseProgect
//
//  Created by  on 2018/5/9.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    ButtonImgViewStyleTop,
    ButtonImgViewStyleLeft,
    ButtonImgViewStyleBottom,
    ButtonImgViewStyleRight,
} ButtonImgViewStyle;
@interface UIButton (ZWWBtn)
/**
 设置 按钮 图片所在的位置
 
 @param style   图片位置类型（上、左、下、右）
 @param size    图片的大小
 @param space 图片跟文字间的间距
 */
- (void)setImgViewStyle:(ButtonImgViewStyle)style imageSize:(CGSize)size space:(CGFloat)space;

@end
