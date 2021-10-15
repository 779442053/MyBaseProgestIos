//
//  NSString+ZWString.m
//  共享蜂
//
//  Created by 张威威 on 2017/12/17.
//  Copyright © 2017年 张威威. All rights reserved.
//

#import "NSString+ZWString.h"

#import <sys/utsname.h>
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#include <sys/types.h>
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
@implementation NSString (ZWString)

- (NSString *)appendDocumentPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:self.lastPathComponent];
}

- (NSString *)appendCachePath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:self.lastPathComponent];
}

- (NSString *)appendTempPath {
    return [NSTemporaryDirectory() stringByAppendingPathComponent:self.lastPathComponent];
}


- (NSString*)wh_substringWithinBoundsLeft:(NSString*)strLeft right:(NSString*)strRight
{
    NSRange rangeSub;
    NSString *strSub;
    
    NSRange range;
    range = [self rangeOfString:strLeft options:0];
    
    if (range.location == NSNotFound) {
        return nil;
    }
    
    rangeSub.location = range.location + range.length;
    
    range.location = rangeSub.location;
    range.length = [self length] - range.location;
    range = [self rangeOfString:strRight options:0 range:range];
    
    if (range.location == NSNotFound) {
        return nil;
    }
    
    rangeSub.length = range.location - rangeSub.location;
    strSub = [[self substringWithRange:rangeSub] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return strSub;
}


/**
 阿拉伯数字转成中文
 
 @param arebic 阿拉伯数字
 @return 返回的中文数字
 */
+(NSString *)wh_translation:(NSString *)arebic
{
    NSString *str = arebic;
    NSArray *arabic_numerals = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chinese_numerals = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chinese_numerals forKeys:arabic_numerals];
    
    NSMutableArray *sums = [NSMutableArray array];
    for (int i = 0; i < str.length; i ++) {
        NSString *substr = [str substringWithRange:NSMakeRange(i, 1)];
        NSString *a = [dictionary objectForKey:substr];
        NSString *b = digits[str.length -i-1];
        NSString *sum = [a stringByAppendingString:b];
        if ([a isEqualToString:chinese_numerals[9]])
        {
            if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
            {
                sum = b;
                if ([[sums lastObject] isEqualToString:chinese_numerals[9]])
                {
                    [sums removeLastObject];
                }
            }else
            {
                sum = chinese_numerals[9];
            }
            
            if ([[sums lastObject] isEqualToString:sum])
            {
                continue;
            }
        }
        
        [sums addObject:sum];
    }
    
    NSString *sumStr = [sums componentsJoinedByString:@""];
    NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
    NSLog(@"%@",str);
    NSLog(@"%@",chinese);
    return chinese;
}

- (NSString*)wh_reverseWordsInString:(NSString*)str
{
    NSMutableString *reverString = [NSMutableString stringWithCapacity:str.length];
    [str enumerateSubstringsInRange:NSMakeRange(0, str.length) options:NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences  usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        [reverString appendString:substring];
    }];
    return reverString;
}

+ (NSString *)wh_transform:(NSString *)chinese
{
    //将NSString装换成NSMutableString
    NSMutableString *pinyin = [chinese mutableCopy];
    //将汉字转换为拼音(带音标)
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    NSLog(@"%@", pinyin);
    //去掉拼音的音标
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    NSLog(@"%@", pinyin);
    //返回最近结果
    return pinyin;
}

- (BOOL)isContainChinese
{
    NSUInteger length = [self length];
    for (NSUInteger i = 0; i < length; i++)
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [self substringWithRange:range];
        const char *cString = [subString UTF8String];
        if (strlen(cString) == 3)
        {
            return YES;
        }
    }
    return NO;
}
- (BOOL)isContainEmoji{
    __block BOOL containsEmoji = NO;
        [self enumerateSubstringsInRange:NSMakeRange(0,[self length])
                                 options:NSStringEnumerationByComposedCharacterSequences
                              usingBlock:^(NSString *substring,
                                           NSRange substringRange,
                                           NSRange enclosingRange,
                                           BOOL *stop) {
             const unichar hs = [substring characterAtIndex:0];
             // surrogate pair
             if (0xd800 <= hs && hs <= 0xdbff) {
                 if (substring.length > 1) {
                     const unichar ls = [substring characterAtIndex:1];
                     const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                     if (0x1d000 <= uc && uc <= 0x1FAD6) {
                         containsEmoji = YES;
                     }
                 }
             }else if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 if (ls == 0x20e3 ||
                     ls == 0xfe0f ||
                     ls == 0xd83c) {
                     containsEmoji = YES;
                 }
             } else {
                 // non surrogate
                 if (0x2100 <= hs && hs <= 0x27ff) {
                     containsEmoji = YES;
                     if (0x278b <= hs && hs <= 0x2792) {
                         containsEmoji = NO;
                     }
                 }else if (0x2B05 <= hs && hs <= 0x2b07) {
                     containsEmoji = YES;
                 } else if (0x2934 <= hs && hs <= 0x2935) {
                     containsEmoji = YES;
                 }else if (0x3297 <= hs && hs <= 0x3299) {
                     containsEmoji = YES;
                 }else if (hs == 0xa9 ||
                          hs == 0xae ||
                          hs == 0x303d ||
                          hs == 0x3030 ||
                          hs == 0x2b55 ||
                          hs == 0x2b1c ||
                          hs == 0x2b1b ||
                          hs == 0x2b50) {
                     containsEmoji = YES;
                 }
             }
             if (containsEmoji) {
                 *stop = YES;
             }
         }];
        return containsEmoji;
}
/** 获取字符数量 */
- (int)wordsCount
{
    NSInteger n = self.length;
    int i;
    int l = 0, a = 0, b = 0;
    unichar c;
    
    for (i = 0; i < n; i++)
    {
        c = [self characterAtIndex:i];
        if (isblank(c))
        {
            b++;
        }
        else if (isascii(c))
        {
            a++;
        }
        else
        {
            l++;
        }
    }
    
    if (a == 0 && l == 0)
    {
        return 0;
    }
    return l + (int)ceilf((float)(a + b) / 2.0);
}



-(NSDictionary *)dictionaryValue
{
    NSError *errorJson;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&errorJson];
    if (errorJson != nil)
    {
#ifdef DEBUG
        NSLog(@"fail to get dictioanry from JSON: %@, error: %@", self, errorJson);
#endif
    }
    return jsonDict;
}



#pragma mark - 正则相关
- (BOOL)isValidateByRegex:(NSString *)regex
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:self];
}

#pragma mark -

//手机号分服务商
- (BOOL)isMobileNumberClassification{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,1705
     * 联通：130,131,132,152,155,156,185,186,1709
     * 电信：133,1349,153,180,189,1700,173
     */
    //    NSString * MOBILE = @"^1((3//d|5[0-35-9]|8[025-9])//d|70[059])\\d{7}$";//总况
    
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188，1705
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d|705)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186,1709
     17         */
    NSString * CU = @"^1((3[0-2]|5[256]|8[56])\\d|709)\\d{7}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,1700,173
     22         */
    NSString * CT = @"^1((33|53|73|8[09])\\d|349|700)\\d{7}$";
    
    
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    
    //    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    if (([self isValidateByRegex:CM])
        || ([self isValidateByRegex:CU])
        || ([self isValidateByRegex:CT])
        || ([self isValidateByRegex:PHS]))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//手机号有效性
- (BOOL)isMobileNumber{
    NSString *mobileRegex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[0678]|18[0-9]|14[57])[0-9]{8}$";
    BOOL ret1 = [self isValidateByRegex:mobileRegex];
    return ret1;
}

//邮箱
- (BOOL)isEmailAddress{
    NSString *emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self isValidateByRegex:emailRegex];
}

//身份证号
- (BOOL)simpleVerifyIdentityCardNum
{
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    return [self isValidateByRegex:regex2];
}

//车牌
- (BOOL)isCarNumber{
    //车牌号:湘K-DE829 香港车牌号码:粤Z-J499港
    NSString *carRegex = @"^[\u4e00-\u9fff]{1}[a-zA-Z]{1}[-][a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fff]$";//其中\u4e00-\u9fa5表示unicode编码中汉字已编码部分，\u9fa5-\u9fff是保留部分，将来可能会添加
    return [self isValidateByRegex:carRegex];
}

- (BOOL)isMacAddress{
    NSString * macAddRegex = @"([A-Fa-f\\d]{2}:){5}[A-Fa-f\\d]{2}";
    return  [self isValidateByRegex:macAddRegex];
}

- (BOOL)isValidUrl
{
    NSString *regex = @"^((http)|(https))+:[^\\s]+\\.[^\\s]*$";
    return [self isValidateByRegex:regex];
}

- (BOOL)isValidChinese;
{
    NSString *chineseRegex = @"^[\u4e00-\u9fa5]+$";
    return [self isValidateByRegex:chineseRegex];
}

- (BOOL)isValidPostalcode {
    NSString *postalRegex = @"^[0-8]\\d{5}(?!\\d)$";
    return [self isValidateByRegex:postalRegex];
}

- (BOOL)isValidTaxNo
{
    NSString *taxNoRegex = @"[0-9]\\d{13}([0-9]|X)$";
    return [self isValidateByRegex:taxNoRegex];
}

#pragma mark - 算法相关
//精确的身份证号码有效性检测
+ (BOOL)accurateVerifyIDCardNumber:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    int length =0;
    if (!value) {
        return NO;
    }else {
        length = (int)value.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                NSString *test = [value substringWithRange:NSMakeRange(17,1)];
                if ([[M lowercaseString] isEqualToString:[test lowercaseString]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return NO;
    }
}



/** 银行卡号有效性问题Luhn算法
 *  现行 16 位银联卡现行卡号开头 6 位是 622126～622925 之间的，7 到 15 位是银行自定义的，
 *  可能是发卡分行，发卡网点，发卡序号，第 16 位是校验码。
 *  16 位卡号校验位采用 Luhm 校验方法计算：
 *  1，将未带校验位的 15 位卡号从右依次编号 1 到 15，位于奇数位号上的数字乘以 2
 *  2，将奇位乘积的个十位全部相加，再加上所有偶数位上的数字
 *  3，将加法和加上校验位能被 10 整除。
 */
- (BOOL)bankCardluhmCheck{
    NSString * lastNum = [[self substringFromIndex:(self.length-1)] copy];//取出最后一位
    NSString * forwardNum = [[self substringToIndex:(self.length -1)] copy];//前15或18位
    
    NSMutableArray * forwardArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<forwardNum.length; i++) {
        NSString * subStr = [forwardNum substringWithRange:NSMakeRange(i, 1)];
        [forwardArr addObject:subStr];
    }
    
    NSMutableArray * forwardDescArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = (int)(forwardArr.count-1); i> -1; i--) {//前15位或者前18位倒序存进数组
        [forwardDescArr addObject:forwardArr[i]];
    }
    
    NSMutableArray * arrOddNum = [[NSMutableArray alloc] initWithCapacity:0];//奇数位*2的积 < 9
    NSMutableArray * arrOddNum2 = [[NSMutableArray alloc] initWithCapacity:0];//奇数位*2的积 > 9
    NSMutableArray * arrEvenNum = [[NSMutableArray alloc] initWithCapacity:0];//偶数位数组
    
    for (int i=0; i< forwardDescArr.count; i++) {
        NSInteger num = [forwardDescArr[i] intValue];
        if (i%2) {//偶数位
            [arrEvenNum addObject:[NSNumber numberWithInteger:num]];
        }else{//奇数位
            if (num * 2 < 9) {
                [arrOddNum addObject:[NSNumber numberWithInteger:num * 2]];
            }else{
                NSInteger decadeNum = (num * 2) / 10;
                NSInteger unitNum = (num * 2) % 10;
                [arrOddNum2 addObject:[NSNumber numberWithInteger:unitNum]];
                [arrOddNum2 addObject:[NSNumber numberWithInteger:decadeNum]];
            }
        }
    }
    
    __block  NSInteger sumOddNumTotal = 0;
    [arrOddNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumOddNumTotal += [obj integerValue];
    }];
    
    __block NSInteger sumOddNum2Total = 0;
    [arrOddNum2 enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumOddNum2Total += [obj integerValue];
    }];
    
    __block NSInteger sumEvenNumTotal =0 ;
    [arrEvenNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumEvenNumTotal += [obj integerValue];
    }];
    
    NSInteger lastNumber = [lastNum integerValue];
    
    NSInteger luhmTotal = lastNumber + sumEvenNumTotal + sumOddNum2Total + sumOddNumTotal;
    
    return (luhmTotal%10 ==0)?YES:NO;
}

- (BOOL)isIPAddress{
    //NSString *regex = [NSString stringWithFormat:@"^(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})$"];
    NSString  *regex =@"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
                            "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
                            "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
                            "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
   
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL rc = [pre evaluateWithObject:self];
    
    if (rc) {
        NSArray *componds = [self componentsSeparatedByString:@","];
        
        BOOL v = YES;
        for (NSString *s in componds) {
            if (s.integerValue > 255) {
                v = NO;
                break;
            }
        }
        
        return v;
    }
    
    return NO;
}



- (NSString *)stringByStrippingHTML
{
    return [self stringByReplacingOccurrencesOfString:@"<[^>]+>" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
}

- (NSString *)stringByRemovingScriptsAndStrippingHTML
{
    NSMutableString *mString = [self mutableCopy];
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<script[^>]*>[\\w\\W]*</script>" options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regex matchesInString:mString options:NSMatchingReportProgress range:NSMakeRange(0, [mString length])];
    for (NSTextCheckingResult *match in [matches reverseObjectEnumerator]) {
        [mString replaceCharactersInRange:match.range withString:@""];
    }
    return [mString stringByStrippingHTML];
}

- (NSString *)trimmingWhitespace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)trimmingWhitespaceAndNewlines
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


- (NSString *)MD5Hash
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

- (NSString *)toMD5 {
    if (self == nil || [self length] == 0) {
        return nil;
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([self UTF8String], (int)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ms appendFormat:@"%02x", (int)(digest[i])];
    }
    
    return [ms copy];
    //MD5((MD5(密码) 32位大写) + "kuaifeng") 32位大写
    
}

- (NSString *)to16MD5 {
    if (self == nil || [self length] == 0) {
        return nil;
    }
    
    return [[self toMD5] substringWithRange:NSMakeRange(8, 16)];
}

- (NSString *)sha1 {
    if (self == nil || [self length] == 0) {
        return nil;
    }
    
    unsigned char digest[CC_SHA1_DIGEST_LENGTH], i;
    CC_SHA1([self UTF8String], (int)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for ( i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [ms appendFormat:@"%02x", (int)(digest[i])];
    }
    
    return [ms copy];
}

- (NSString *)sha256 {
    if (self == nil || [self length] == 0) {
        return nil;
    }
    
    unsigned char digest[CC_SHA256_DIGEST_LENGTH], i;
    CC_SHA256([self UTF8String], (int)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [ms appendFormat: @"%02x", (int)(digest[i])];
    }
    
    return [ms copy];
}

- (NSString *)sha512 {
    if (self == nil || [self length] == 0) {
        return nil;
    }
    
    unsigned char digest[CC_SHA512_DIGEST_LENGTH], i;
    CC_SHA512([self UTF8String], (int)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < CC_SHA512_DIGEST_LENGTH; i++) {
        [ms appendFormat: @"%02x", (int)(digest[i])];
    }
    
    return [ms copy];
}

- (NSData *)toData {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)toStringWithData:(NSData *)data {
    if (data && [data isKindOfClass:[NSData class]]) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}



- (NSString *)HMACWithSecret:(NSString *) secret
{
    CCHmacContext    ctx;
    const char       *key = [secret UTF8String];
    const char       *str = [self UTF8String];
    unsigned char    mac[CC_MD5_DIGEST_LENGTH];
    char             hexmac[2 * CC_MD5_DIGEST_LENGTH + 1];
    char             *p;
    
    CCHmacInit( &ctx, kCCHmacAlgMD5, key, strlen( key ));
    CCHmacUpdate( &ctx, str, strlen(str) );
    CCHmacFinal( &ctx, mac );
    
    p = hexmac;
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++ ) {
        snprintf( p, 3, "%02x", mac[ i ] );
        p += 2;
    }
    
    return [NSString stringWithUTF8String:hexmac];
}

+ (NSString *)getDeviceName
{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *code = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];
    NSDictionary *deviceNamesByCode = @{
                                        @"i386"      :@"Simulator",
                                        @"iPod1,1"   :@"iPodTouch",      // (Original)
                                        @"iPod2,1"   :@"iPodTouch",      // (Second Generation)
                                        @"iPod3,1"   :@"iPodTouch",      // (Third Generation)
                                        @"iPod4,1"   :@"iPodTouch",      // (Fourth Generation)
                                        @"iPhone1,1" :@"iPhone",          // (Original)
                                        @"iPhone1,2" :@"iPhone",          // (3G)
                                        @"iPhone2,1" :@"iPhone",          // (3GS)
                                        @"iPad1,1"   :@"iPad",            // (Original)
                                        @"iPad2,1"   :@"iPad2",          //
                                        @"iPad3,1"   :@"iPad",            // (3rd Generation)
                                        @"iPhone3,1" :@"iPhone4",        // (GSM)
                                        @"iPhone3,3" :@"iPhone4",        // (CDMA/Verizon/Sprint)
                                        @"iPhone4,1" :@"iPhone4S",       //
                                        @"iPhone5,1" :@"iPhone5",        // (model A1428, AT&T/Canada)
                                        @"iPhone5,2" :@"iPhone5",        // (model A1429, everything else)
                                        @"iPad3,4"   :@"iPad",            // (4th Generation)
                                        @"iPad2,5"   :@"iPadMini",       // (Original)
                                        @"iPhone5,3" :@"iPhone5c",       // (model A1456, A1532 | GSM)
                                        @"iPhone5,4" :@"iPhone5c",       // (model A1507, A1516, A1526 (China), A1529 | Global)
                                        @"iPhone6,1" :@"iPhone5s",       // (model A1433, A1533 | GSM)
                                        @"iPhone6,2" :@"iPhone5s",       // (model A1457, A1518, A1528 (China), A1530 | Global)
                                        @"iPhone7,1" :@"iPhone6Plus",   //
                                        @"iPhone7,2" :@"iPhone6",        //
                                        @"iPad4,1"   :@"iPadAir",        // 5th Generation iPad (iPad Air) - Wifi
                                        @"iPad4,2"   :@"iPadAir",        // 5th Generation iPad (iPad Air) - Cellular
                                        @"iPad4,4"   :@"iPadMini",       // (2nd Generation iPad Mini - Wifi)
                                        @"iPad4,5"   :@"iPadMini"        // (2nd Generation iPad Mini - Cellular)
                                        };
    
    NSString *deviceName = [deviceNamesByCode objectForKey:code];
    
    if (!deviceName) {
        if ([code rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod Touch";
        }
        else if([code rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        }
        else if([code rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = @"iPhone";
        }
        else
        {
            deviceName = @"unknow";
        }
    }
    
    return deviceName;
}




- (NSString *)fileIdFromUrl {
    NSRange fileIdRange=[self rangeOfString:@"fileid="];
    if (fileIdRange.location==NSNotFound) {
        fileIdRange = [self rangeOfString:@"/"];
        if (fileIdRange.location == NSNotFound) {
            return self;
        }else{
            return [[self componentsSeparatedByString:@"/"] lastObject];
        }
    }
    NSString *fileId=[self substringFromIndex:fileIdRange.location+fileIdRange.length];
    fileIdRange=[fileId rangeOfString:@"&"];
    if (fileIdRange.location==NSNotFound) {
        return fileId;
    }
    return [fileId substringToIndex:fileIdRange.location];
}

+ (NSString *)phoneNumFormat:(NSString *)phoneString {
    BOOL flag;//是否是以“1”开头
    if (phoneString && phoneString.length >= 1) {
        NSString *firstStr = [phoneString substringToIndex:1];
        if ([firstStr isEqualToString:@"1"] && [phoneString rangeOfString:@"@"].location == NSNotFound) {
            flag = YES;
        }else{
            flag = NO;
        }
    }
    
    if (flag) {
        phoneString = [phoneString stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (phoneString.length > 3) {
            NSString *a = [[phoneString substringToIndex:3] stringByAppendingString:@" "];
            NSString *b = [phoneString substringFromIndex:3];
            for (NSUInteger i = 0; i + 4 < b.length; i += 4) {
                NSString *c = [[b substringWithRange:NSMakeRange(i, 4)] stringByAppendingString:@" "];
                a = [a stringByAppendingString:c];
            }
            NSUInteger spareLen = (b.length%4 == 0?4:b.length%4);
            NSString *spare = [b substringFromIndex:b.length - spareLen];
            a = [a stringByAppendingString:spare];
            return a;
        }
    }
    
    return phoneString;
    
}

- (NSString *)trimAll {
    NSMutableString *result=[[NSMutableString alloc] init];
    for (int i=0;i<self.length;i++) {
        NSString* chr = [self substringWithRange:NSMakeRange(i, 1)];
        if (![chr isEqualToString:@" "]) {
            [result appendString:chr];
        }
    }
    return result;
}

- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

//- (NSString *)sha1
//{
//    const char *ptr = [self UTF8String];
//
//    int i =0;
//    size_t len = strlen(ptr);
//    Byte byteArray[len];
//    while (i!=len)
//    {
//        unsigned eachChar = *(ptr + i);
//        unsigned low8Bits = eachChar & 0xFF;
//        
//        byteArray[i] = low8Bits;
//        i++;
//    }
//
//    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
//
//    CC_SHA1(byteArray, len, digest);
//
//    NSMutableString *hex = [NSMutableString string];
//    for (int i=0; i<20; i++)
//        [hex appendFormat:@"%02x", digest[i]];
//
//    NSString *immutableHex = [NSString stringWithString:hex];
//
//    return immutableHex;
//}

+ (NSString *)phone:(NSString *)phone num:(NSString *)num {
    if ([num rangeOfString:@"+"].location != NSNotFound) {
        num = [num substringFromIndex:1];
    }
    phone = [num stringByAppendingString:phone];
    return phone;
}

+ (NSString *)stringFormatWithVoiceTime:(NSInteger)time
{
    //    NSInteger timeM = time/60;
    //    NSInteger timeS = time%60;
    //
    //    NSString *str = nil;
    //    if (timeM > 0) {
    //        if (timeS > 0) {
    //            str = [NSString stringWithFormat:@"%zd\'%2zd\"",timeM,timeS];
    //        }else{
    //            str = [NSString stringWithFormat:@"%zd\'",timeM];
    //        }
    //    }else{
    //        str = [NSString stringWithFormat:@"%2zd\"",timeS];
    //    }
    
    NSDateFormatter *dfm = [[NSDateFormatter alloc] init];
    [dfm setDateFormat:@"mm:ss"];
    
    NSString *str = [dfm stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
    
    NSArray *arr = [str componentsSeparatedByString:@":"];
    str = [NSString stringWithFormat:@"%@'%@\"",arr[0],arr[1]];
    
    return str;
}

+ (NSString *)stringFormatWithVoiceTime1:(NSInteger)time
{
    NSDateFormatter *dfm = [[NSDateFormatter alloc] init];
    [dfm setDateFormat:@"mm:ss"];
    
    return [dfm stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
}

+ (NSString *)stringWithAudioUrl:(NSString *)url
{
    NSString *filedId = [NSString stringWithFormat:@"%@",[[url componentsSeparatedByString:@"fileid/"] lastObject]];
    return filedId;
}

+ (NSString *)dateStringWithTime:(NSString *)time;
{
    NSDate *fromDate = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                          fromDate:fromDate];
    NSDateComponents *compsNow = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                             fromDate:[NSDate date]];
    
    NSDateFormatter* dfm = [[NSDateFormatter alloc] init];
    [dfm setAMSymbol:NSLocalizedString(@"AM",nil)];
    [dfm setPMSymbol:NSLocalizedString(@"PM",nil)];
    [dfm setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh"]];
    [dfm setDateFormat:@"yyyy:MM:dd:hh:mm:a"];
    NSString* dateStrr = [dfm stringFromDate:fromDate];
    NSArray *dateArr = [dateStrr componentsSeparatedByString:@":"];
    
    NSString *yyyy = [dateArr objectAtIndex:0];
    NSString *MM = [dateArr objectAtIndex:1];
    NSString *dd = [dateArr objectAtIndex:2];
    NSString *hh = [dateArr objectAtIndex:3];
    NSString *mm = [dateArr objectAtIndex:4];
    NSString *ampm = [dateArr objectAtIndex:5];
    
    if (compsNow.year - comps.year > 0) {
        dateStrr = [NSString stringWithFormat:@"%@,%@ %@,%@:%@ %@",yyyy,MM,dd,hh,mm,ampm];
    }else if (compsNow.month - comps.month > 0){
        dateStrr = [NSString stringWithFormat:@"%@ %@,%@:%@ %@",MM,dd,hh,mm,ampm];
    }else if (compsNow.day - comps.day > 1){
        dateStrr = [NSString stringWithFormat:@"%@ %@,%@:%@ %@",MM,dd,hh,mm,ampm];
    }else if (compsNow.day - comps.day <= 1){
        dateStrr = [NSString stringWithFormat:@"%@:%@ %@",hh,mm,ampm];
        if (compsNow.day - comps.day == 1) {
            dateStrr = [@"昨天 " stringByAppendingString:dateStrr];
        }
    }else{
        dateStrr = [NSString stringWithFormat:@"%@ %@,%@:%@ %@",MM,dd,hh,mm,ampm];
    }
    
    return dateStrr;
}

+ (NSString *)stringWithDistance:(NSInteger)distance
{
    NSString *distanceStr = nil;
    if (distance >= 0) {
        if (distance >= 1000) {
            distanceStr = [NSString stringWithFormat:@"%.2fkm",distance/1000.f];
        }else{
            distanceStr = [NSString stringWithFormat:@"%.2fm",distance/1.f];
        }
    }
    return distanceStr;
}

+ (NSString *)fileIDPlistPath {
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [doc stringByAppendingPathComponent:@"fileID.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
        NSDictionary *dic = [[NSDictionary alloc]init];
        [dic writeToFile:path atomically:YES];
    }
    return path;
}

+ (NSString *)nowDate
{
    NSString *date = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    return date;
}

+ (NSDictionary *)dictionaryFromQuery:(NSString*)query usingEncoding:(NSStringEncoding)encoding {
    NSCharacterSet *delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary *pairs = [NSMutableDictionary dictionary];
    NSScanner *scanner = [[NSScanner alloc] initWithString:query];
    while (![scanner isAtEnd]) {
        NSString *pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray *kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 2) {
            NSString* key = [[kvPair objectAtIndex:0]
                             stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSString* value = [[kvPair objectAtIndex:1]
                               stringByReplacingPercentEscapesUsingEncoding:encoding];
            [pairs setObject:value forKey:key];
        }
    }
    return [NSDictionary dictionaryWithDictionary:pairs];
}

+ (NSString *)getNowTimeStr{
    NSDate *datea=[NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[datea timeIntervalSince1970];
    NSString *timeStampString=[NSString stringWithFormat:@"%.0f",time];
    NSTimeInterval _interval=[timeStampString doubleValue] ;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd"];
    NSString * timeStr = [objDateformat stringFromDate:date];
    return timeStr;
}

+ (NSString *)textSelectFromHerfString:(NSString *)string {
    NSString *regexString = @"[\u4E00-\u9FA5]+";
    NSError *error;
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                             options:NSRegularExpressionCaseInsensitive
                                                                               error:&error];
    // 对str字符串进行匹配
    NSArray *matches = [regular matchesInString:string
                                        options:0
                                          range:NSMakeRange(0, string.length)];
    // 遍历匹配后的每一条记录
    NSString *textString = @"";
    for (NSTextCheckingResult *match in matches) {
        NSRange range = [match range];
        NSString *mStr = [string substringWithRange:range];
        
        textString = [textString stringByAppendingString:mStr];
    }
    return textString;
}



//处理国家码
+ (NSString *)getAreaCodeWithString:(NSString *)areaCode
{
    if ([areaCode rangeOfString:@"+"].location != NSNotFound) {
        NSString *str = [[areaCode componentsSeparatedByString:@"+"] lastObject];
        return str;
    }else {
        return areaCode;
    }
}

//输入金额小数点控制
+ (BOOL)checkNumberStr:(NSString *)string orRange:(NSRange)range orTextFiled:(UITextField *)textField {
    
    NSScanner      *scanner    = [NSScanner scannerWithString:string];
    NSCharacterSet *numbers;
    NSRange         pointRange = [textField.text rangeOfString:@"."];
    
    if ( (pointRange.length > 0) && (pointRange.location < range.location  || pointRange.location > range.location + range.length) )
    {
        numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    }
    else
    {
        numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    }
    
    if ( [textField.text isEqualToString:@""] && [string isEqualToString:@"."] )
    {
        return NO;
    }
    
    short remain = 2; //默认保留2位小数
    
    NSString *tempStr = [textField.text stringByAppendingString:string];
    NSUInteger strlen = [tempStr length];
    if(pointRange.length > 0 && pointRange.location > 0){ //判断输入框内是否含有“.”。
        if([string isEqualToString:@"."]){ //当输入框内已经含有“.”时，如果再输入“.”则被视为无效。
            return NO;
        }
        if(strlen > 0 && (strlen - pointRange.location) > remain+1){ //当输入框内已经含有“.”，当字符串长度减去小数点前面的字符串长度大于需要要保留的小数点位数，则视当次输入无效。
            //[XDHub showLongText:@"输入金额小数点后最多2位" hideDelay:1.0];
            return NO;
        }
    }
    
    NSRange zeroRange = [textField.text rangeOfString:@"0"];
    if(zeroRange.length == 1 && zeroRange.location == 0){ //判断输入框第一个字符是否为“0”
        if(![string isEqualToString:@"0"] && ![string isEqualToString:@"."] && [textField.text length] == 1){ //当输入框只有一个字符并且字符为“0”时，再输入不为“0”或者“.”的字符时，则将此输入替换输入框的这唯一字符。
            textField.text = string;
            return NO;
        }else{
            if(pointRange.length == 0 && pointRange.location > 0){ //当输入框第一个字符为“0”时，并且没有“.”字符时，如果当此输入的字符为“0”，则视当此输入无效。
                if([string isEqualToString:@"0"]){
                    return NO;
                }
            }
        }
    }
    
    NSString *buffer;
    //NSLog(@"****%@",buffer);
    if ( ![scanner scanCharactersFromSet:numbers intoString:&buffer] && ([string length] != 0) )
    {
        
        return NO;
    }
    
    return YES;
}

//密码设置正则
+ (BOOL)isValidPassword:(NSString *)passWord; {
    
    //以字母开头，只能包含“字母”，“数字”，“下划线”，长度6~16
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,16}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:passWord];
    
    return isMatch;
}



//手机号码正则
+ (BOOL)isValidateHomePhoneNum:(NSString *)phoneNum {
    
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:phoneNum];
}

//中文正则
- (BOOL)isValidateChinese{
    
    NSString *MOBILE = @"[\u4e00-\u9fa5]";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    NSRange range;
    for(int i=0; i<self.length; i+=range.length){
        range = [self rangeOfComposedCharacterSequenceAtIndex:i];
        NSString *s = [self substringWithRange:range];
        
        if (![regextestmobile evaluateWithObject:s]) {
            
            return NO;
        }
    }
    
    return YES;
}

// 去掉空格符
+ (NSString *)deteleTheBlankWithString:(NSString *)str
{
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *newStr = [[NSString alloc]initWithString:[str stringByTrimmingCharactersInSet:whiteSpace]];
    return newStr;
}


//身份证号正则
+ (BOOL)validateIdentityCard: (NSString *)identityCard
{
    // 粗略验证身份证号
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:identityCard];
    return isMatch;
}

//时间戳处理
+ (NSString *)compareCurrentTime:(NSString *)str {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *timeDate = [formatter dateFromString:str];
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:timeDate];
    long temp = 0;
    NSString *result;
    if (timeInterval/60 < 1) {
        result = @"刚刚";
    }else if ((temp = timeInterval/60)<60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }else if ((temp = temp/60)<24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }else if ((temp = temp/24)<30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }else if ((temp = temp/30)<12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return result;
}


+ (NSString *)getTime:(NSString *)time {
    // 把时间戳转换为NSString型的时间
    NSDateFormatter*formatter = [[NSDateFormatter alloc] init];
    NSTimeInterval _interval=[time doubleValue] / 1000.0;
    NSDate*confromTimesp = [NSDate dateWithTimeIntervalSince1970:_interval];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString*confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}


/** 传入请求地址和请求参数(字典) 返回请求的URL */
+ (NSString *)getUrlWithBaseUrl:(NSString *)baseUrl parameters:(NSDictionary *)parameters {
    
    //创建一个数组用来存储每组keyValue
    NSMutableArray *allParametersArr = [NSMutableArray array];
    [allParametersArr removeAllObjects];
    
    //获得字典所有key
    NSArray *keysArray = [parameters allKeys];
    for (int i = 0; i < keysArray.count; i++)
    {
        //根据每个key获得对应value -> 拼接放进可变数组
        NSString *key   = keysArray[i];
        NSString *value = parameters[key];
        NSString *keyValueStr = [NSString stringWithFormat:@"%@=%@", key, value];
        [allParametersArr addObject:keyValueStr];
    }
    
    //数组转为字符串以&分割每个元素
    NSString *paraStr = [allParametersArr componentsJoinedByString:@"&"];
    NSString *UrlStr  = [NSString stringWithFormat:@"%@?%@", baseUrl, paraStr];
    //NSLog(@"%@", UrlStr);
    
    return UrlStr;
}

- (CGFloat)zww_heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width{
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    CGSize textSize;
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
    return ceil(textSize.height);
}

- (CGFloat)zww_heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width lineSpacing:(CGFloat)lineSpacing{
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    CGSize textSize;
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.lineSpacing  = lineSpacing;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
    return ceil(textSize.height);
}


@end
