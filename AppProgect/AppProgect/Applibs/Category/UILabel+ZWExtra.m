//
//  UILabel+ZWExtra.m
//  NBJKCardHome
//
//  Created by step_zhang on 2020/11/24.
//

#import "UILabel+ZWExtra.h"

@implementation UILabel (ZWExtra)
///iOS根据字体字号大小和字体label计算label宽度
+(CGSize)sizeWithText:(NSString *)text
                 font:(UIFont *)font
              maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:attrs
                              context:nil].size;
}
@end
