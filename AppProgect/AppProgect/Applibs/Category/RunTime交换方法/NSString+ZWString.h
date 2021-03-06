//
//  NSString+ZWString.h
//  共享蜂
//
//  Created by 张威威 on 2017/12/17.
//  Copyright © 2017年 张威威. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
@interface NSString (ZWString)
///  追加文档目录
- (NSString *)appendDocumentPath;
///  追加缓存目录
- (NSString *)appendCachePath;
///  追加临时目录
- (NSString *)appendTempPath;


/**
 根据左边和右边的字符串,获得中间特定字符串
 @param strLeft 左边匹配字符串
 @param strRight 右边匹配的字符串
 */
- (NSString*)wh_substringWithinBoundsLeft:(NSString*)strLeft right:(NSString*)strRight;

/**
 阿拉伯数字转成中文
 
 @param arebic 阿拉伯数字
 @return 返回的中文数字
 */
+(NSString *)wh_translation:(NSString *)arebic;

/**
 字符串反转
 
 @param str 要反转的字符串
 @return 反转之后的字符串
 */
- (NSString*)wh_reverseWordsInString:(NSString*)str;

/**
 获得汉字的拼音
 
 @param chinese 汉字
 @return 拼音
 */
+ (NSString *)wh_transform:(NSString *)chinese;

/** 判断URL中是否包含中文 */
- (BOOL)isContainChinese;
/** 判断字符串中是否包含表情 */
- (BOOL)isContainEmoji;

/** 获取字符数量 */
- (int)wordsCount;

/** JSON字符串转成NSDictionary */
-(NSDictionary *)dictionaryValue;


/**
 *  手机号码的有效性:分电信、联通、移动和小灵通
 */
- (BOOL)isMobileNumberClassification;
/**
 *  手机号有效性
 */
- (BOOL)isMobileNumber;

/**
 *  邮箱的有效性
 */
- (BOOL)isEmailAddress;

/**
 *  简单的身份证有效性
 *
 */
- (BOOL)simpleVerifyIdentityCardNum;

/**
 *  精确的身份证号码有效性检测
 *
 *  @param value 身份证号
 */
+ (BOOL)accurateVerifyIDCardNumber:(NSString *)value;

/**
 *  车牌号的有效性
 */
- (BOOL)isCarNumber;

/**
 *  银行卡的有效性
 */
- (BOOL)bankCardluhmCheck;

/**
 *  IP地址有效性
 */
- (BOOL)isIPAddress;

/**
 *  Mac地址有效性
 */
- (BOOL)isMacAddress;

/**
 *  网址有效性
 */
- (BOOL)isValidUrl;

/**
 *  纯汉字
 */
- (BOOL)isValidChinese;

/**
 *  邮政编码
 */
- (BOOL)isValidPostalcode;

/**
 *  工商税号
 */
- (BOOL)isValidTaxNo;



/** 清除html标签 */
- (NSString *)stringByStrippingHTML;

/** 清除js脚本 */
- (NSString *)stringByRemovingScriptsAndStrippingHTML;

/** 去除空格 */
- (NSString *)trimmingWhitespace;

/** 去除空格与空行 */
- (NSString *)trimmingWhitespaceAndNewlines;



/** 加密 */
- (NSString *)toMD5;
- (NSString *)MD5Hash;
- (NSString *)to16MD5;
- (NSString *)sha1;
- (NSString *)sha256;
- (NSString *)sha512;

#pragma mark - Data convert to string or string to data.
/**
 *    string与Data转化
 */
- (NSData *)toData;
+ (NSString *)toStringWithData:(NSData *)data;

/////////


- (NSString *)HMACWithSecret:(NSString *)secret;
+ (NSString *)getDeviceName;
- (NSString *)fileIdFromUrl;
/// 手机号码格式化 例如:136 5422 5352
+ (NSString *)phoneNumFormat:(NSString *)phoneString;
///去掉手机号格式化之后的空格
- (NSString *)trimAll;
- (NSString *)md5;

+ (NSString *)phone:(NSString *)phone num:(NSString *)num;
///格式化语音时长  return: mm'ss"
+ (NSString *)stringFormatWithVoiceTime:(NSInteger)time;
///格式化语音时长  return: mm:ss
+ (NSString *)stringFormatWithVoiceTime1:(NSInteger)time;
///截取语音的filedId
+ (NSString *)stringWithAudioUrl:(NSString *)url;
/// 传入的时间搓与当前时间比较 return: hh:mm/昨天hh:mm/MM-dd hh:mm/yyyy-MM-dd hh:mm
+ (NSString *)dateStringWithTime:(NSString *)time;
///格式化距离
+ (NSString *)stringWithDistance:(NSInteger)distance;
+ (NSString *)fileIDPlistPath;
+ (NSString *)nowDate;
+ (NSDictionary *)dictionaryFromQuery:(NSString*)query usingEncoding:(NSStringEncoding)encoding;
//获取当前时间戳格式XXXX-XX-XX
+ (NSString *)getNowTimeStr;
//正则表达式取链接URL里的汉字
+ (NSString *)textSelectFromHerfString:(NSString *)string;
//处理国家码
+ (NSString *)getAreaCodeWithString:(NSString *)areaCode;

//输入金额小数点控制
+ (BOOL)checkNumberStr:(NSString *)string orRange:(NSRange)range orTextFiled:(UITextField *)textField;

// 手机号码正则处理
+ (BOOL)isValidateHomePhoneNum:(NSString *)phoneNum;
//中文正则
- (BOOL)isValidateChinese;

// 去除空格符
+ (NSString *)deteleTheBlankWithString:(NSString *)str;

// 密码设置正则处理
+ (BOOL)isValidPassword:(NSString *)passWord;

//身份证号
+ (BOOL)validateIdentityCard:(NSString *)identityCard;

//时间戳处理
+ (NSString *)compareCurrentTime:(NSString *)str;
+ (NSString *)getTime:(NSString *)time;

//请求完整Url打印处理
+ (NSString *)getUrlWithBaseUrl:(NSString *)baseUrl parameters:(NSDictionary *)parameters;


//计算字体的高度
- (CGFloat)zww_heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;

- (CGFloat)zww_heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width lineSpacing:(CGFloat)lineSpacing;
@end


/**
 *  正则表达式简单说明
 *  语法：
 .       匹配除换行符以外的任意字符
 \w      匹配字母或数字或下划线或汉字
 \s      匹配任意的空白符
 \d      匹配数字
 \b      匹配单词的开始或结束
 ^       匹配字符串的开始
 $       匹配字符串的结束
 *       重复零次或更多次
 +       重复一次或更多次
 ?       重复零次或一次
 {n}     重复n次
 {n,}     重复n次或更多次
 {n,m}     重复n到m次
 \W      匹配任意不是字母，数字，下划线，汉字的字符
 \S      匹配任意不是空白符的字符
 \D      匹配任意非数字的字符
 \B      匹配不是单词开头或结束的位置
 [^x]     匹配除了x以外的任意字符
 [^aeiou]匹配除了aeiou这几个字母以外的任意字符
 *?      重复任意次，但尽可能少重复
 +?      重复1次或更多次，但尽可能少重复
 ??      重复0次或1次，但尽可能少重复
 {n,m}?     重复n到m次，但尽可能少重复
 {n,}?     重复n次以上，但尽可能少重复
 \a      报警字符(打印它的效果是电脑嘀一声)
 \b      通常是单词分界位置，但如果在字符类里使用代表退格
 \t      制表符，Tab
 \r      回车
 \v      竖向制表符
 \f      换页符
 \n      换行符
 \e      Escape
 \0nn     ASCII代码中八进制代码为nn的字符
 \xnn     ASCII代码中十六进制代码为nn的字符
 \unnnn     Unicode代码中十六进制代码为nnnn的字符
 \cN     ASCII控制字符。比如\cC代表Ctrl+C
 \A      字符串开头(类似^，但不受处理多行选项的影响)
 \Z      字符串结尾或行尾(不受处理多行选项的影响)
 \z      字符串结尾(类似$，但不受处理多行选项的影响)
 \G      当前搜索的开头
 \p{name}     Unicode中命名为name的字符类，例如\p{IsGreek}
 (?>exp)     贪婪子表达式
 (?<x>-<y>exp)     平衡组
 (?im-nsx:exp)     在子表达式exp中改变处理选项
 (?im-nsx)       为表达式后面的部分改变处理选项
 (?(exp)yes|no)     把exp当作零宽正向先行断言，如果在这个位置能匹配，使用yes作为此组的表达式；否则使用no
 (?(exp)yes)     同上，只是使用空表达式作为no
 (?(name)yes|no) 如果命名为name的组捕获到了内容，使用yes作为表达式；否则使用no
 (?(name)yes)     同上，只是使用空表达式作为no
 
 捕获
 (exp)               匹配exp,并捕获文本到自动命名的组里
 (?<name>exp)        匹配exp,并捕获文本到名称为name的组里，也可以写成(?'name'exp)
 (?:exp)             匹配exp,不捕获匹配的文本，也不给此分组分配组号
 零宽断言
 (?=exp)             匹配exp前面的位置
 (?<=exp)            匹配exp后面的位置
 (?!exp)             匹配后面跟的不是exp的位置
 (?<!exp)            匹配前面不是exp的位置
 注释
 (?#comment)         这种类型的分组不对正则表达式的处理产生任何影响，用于提供注释让人阅读
 
 *  表达式：\(?0\d{2}[) -]?\d{8}
 *  这个表达式可以匹配几种格式的电话号码，像(010)88886666，或022-22334455，或02912345678等。
 *  我们对它进行一些分析吧：
 *  首先是一个转义字符\(,它能出现0次或1次(?),然后是一个0，后面跟着2个数字(\d{2})，然后是)或-或空格中的一个，它出现1次或不出现(?)，
 *  最后是8个数字(\d{8})
 */



