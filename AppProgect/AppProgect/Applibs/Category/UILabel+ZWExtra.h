//
//  UILabel+ZWExtra.h
//  NBJKCardHome
//
//  Created by step_zhang on 2020/11/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (ZWExtra)
///iOS根据字体字号大小和字体label计算label宽度
+(CGSize)sizeWithText:(NSString *)text
                 font:(UIFont *)font
              maxSize:(CGSize)maxSize;

/*
 *  CGSize size = [self sizeWithText: @"此处是测试字体"
                                font:kFontSize(20)
                             maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
 */
@end

NS_ASSUME_NONNULL_END
