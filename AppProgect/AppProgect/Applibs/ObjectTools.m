//
//  ObjectTools.m
//  NorthBayProject
//
//  Created by akun on 2020/5/15.
//

#import "ObjectTools.h"
#import <CommonCrypto/CommonDigest.h>

@implementation ObjectTools

//验证对象nil class
+(BOOL)isNullClassObject:(NSObject*)OBJ{
    if (OBJ == nil || !OBJ) {
        return YES;
    }
    if ([OBJ isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return NO;
}
//验证string是否为空
+(BOOL)isBlankString:(NSString *)string
{
    if (string == nil || !string) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        return YES;
    }
    return NO;
}

//验证array是否为空
+(BOOL)isEmptyArrayObject:(NSArray*)ArrayObj
{
    if (ArrayObj == nil || !ArrayObj) {
        return YES;
    }
    if ([ArrayObj isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([ArrayObj count]==0) {
        return YES;
    }
    return NO;
}

// 压缩图片到指定大小
+ (NSData *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    if (!image) {
        return nil;
    }
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return data;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return data;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    return data;
}

/**
 校验身份证号码是否正确 返回 BOOL值
 
 十八位： ^[1-9]\d{5}(18|19|([23]\d))\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$
 
 十五位： ^[1-9]\d{5}\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{2}$
 
 总结：
 
 ^[1-9]\d{5}(18|19|([23]\d))\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$)|(^[1-9]\d{5}\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{2}$
 
 @param IDNumber 身份证号码
 @return 返回 BOOL值 YES or NO
 */
+ (BOOL)isCorrect:(NSString *)IDNumber
{
    if (IDNumber.length<18) {
        return NO;
    }else{
        return YES;
    }
    /**
    NSMutableArray *IDArray = [NSMutableArray array];
    for (int i = 0; i < 18; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [IDNumber substringWithRange:range];
        [IDArray addObject:subString];
    }
    NSArray *coefficientArray = [NSArray arrayWithObjects:@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2", nil];
    NSArray *remainderArray = [NSArray arrayWithObjects:@"1", @"0", @"X", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2", nil];
    int sum = 0;
    for (int i = 0; i < 17; i++) {
        int coefficient = [coefficientArray[i] intValue];
        int ID = [IDArray[i] intValue];
        sum += coefficient * ID;
    }
    NSString *str = remainderArray[(sum % 11)];
    NSString *string = [IDNumber substringFromIndex:17];
    if ([str isEqualToString:string]) {
        return YES;
    } else {
        return NO;
    }
     */

    /**
    NSString *regex = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isRe = [predicate evaluateWithObject:IDNumber];
    if (!isRe) {
        //身份证号码格式不对
        return NO;
    }
    //加权因子 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2
    NSArray *weightingArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    //校验码 1, 0, 10, 9, 8, 7, 6, 5, 4, 3, 2
    NSArray *verificationArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    NSInteger sum = 0;//保存前17位各自乖以加权因子后的总和
    for (int i = 0; i < weightingArray.count; i++) {//将前17位数字和加权因子相乘的结果相加
        NSString *subStr = [IDNumber substringWithRange:NSMakeRange(i, 1)];
        sum += [subStr integerValue] * [weightingArray[i] integerValue];
    }
    NSInteger modNum = sum % 11;//总和除以11取余
    NSString *idCardMod = verificationArray[modNum]; //根据余数取出校验码
    NSString *idCardLast = [IDNumber.uppercaseString substringFromIndex:17]; //获取身份证最后一位
    if (modNum == 2) {//等于2时 idCardMod为10  身份证最后一位用X表示10
        idCardMod = @"X";
    }
    if ([idCardLast isEqualToString:idCardMod]) { //身份证号码验证成功
        return YES;
    } else { //身份证号码验证失败
        return NO;
    }
     */
}


+ (NSString *)md5:(NSString *)string{
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X", digest[i]];
    }
    return [result lowercaseString];
}
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:mobileNum];
}
+ (NSInteger)changeCollectionViewHeight:(NSMutableArray *)modelARR WithWidth:(CGFloat)width{
    NSInteger cellNum = 1;
    NSInteger strTotalWidth = 0;
    for (id Object in modelARR) {
//        if ([Object isKindOfClass:[ZWTagModel class]]) {
//            ZWTagModel *item = Object;
//            NSString *str = item.TextStr;
//            strTotalWidth = strTotalWidth + str.length *15 + 37;
//            if (strTotalWidth > width) {
//                cellNum ++;
//                strTotalWidth = str.length *15 + 37;
//            }
//        }else{
            NSString *str = Object;
            strTotalWidth = strTotalWidth + str.length *15 + 37;
            if (strTotalWidth > width) {
                cellNum ++;
                strTotalWidth = str.length *15 + 37;
            }
        //}
    }
    return cellNum * 40 + 10;
}
+ (NSInteger)changeCollectionViewHeightSTR:(NSString *)Str WithWidth:(CGFloat)width{
    if (Str.length) {
        NSArray *imagearr = [Str componentsSeparatedByString:@","];
        NSMutableArray *ARR = [[NSMutableArray alloc]init];
//        for (NSString *str in imagearr) {
//            ZWTagModel *Model = [[ZWTagModel alloc]init];
//            Model.IsSelected = YES;
//            Model.TextStr = str;
//            [ARR addObject:Model];
//        }
//        NSInteger cellNum = 1;
//        NSInteger strTotalWidth = 0;
//        for (ZWTagModel *item in ARR) {
//            NSString *str = item.TextStr;
//            strTotalWidth = strTotalWidth + str.length *15 + 37;
//            if (strTotalWidth > width) {
//                cellNum ++;
//                strTotalWidth = str.length *15 + 37;
//            }
//        }
        //return cellNum * 40 + 10;
        return  10;
    }else{
        return 50;
    }
}
//根据字符串内容的多少  在固定宽度 下计算出实际的行高
+ (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size{
    if ([ObjectTools getCurrentIOS] >= 7.0) {
        //iOS7之后
        /*
         第一个参数: 预设空间 宽度固定  高度预设 一个最大值
         第二个参数: 行间距 如果超出范围是否截断
         第三个参数: 属性字典 可以设置字体大小
         */
        NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};
        CGRect rect = [text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
        //返回计算出的行高
        return rect.size.height;
        
    }else {
        //iOS7之前
        /*
         1.第一个参数  设置的字体固定大小
         2.预设 宽度和高度 宽度是固定的 高度一般写成最大值
         3.换行模式 字符换行
         */
        CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:size] constrainedToSize:CGSizeMake(textWidth, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        return textSize.height;//返回 计算出得行高
    }
}
//获取iOS版本号
+ (double)getCurrentIOS {
    return [[[UIDevice currentDevice] systemVersion] doubleValue];
}
@end
