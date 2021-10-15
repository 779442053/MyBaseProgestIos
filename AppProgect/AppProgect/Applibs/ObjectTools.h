//
//  ObjectTools.h
//  NorthBayProject
//
//  Created by akun on 2020/5/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ObjectTools : NSObject
//验证对象nil class
+(BOOL)isNullClassObject:(NSObject*)OBJ;
//验证string是否为空
+(BOOL)isBlankString:(NSString *)string;
//验证array是否为空
+(BOOL)isEmptyArrayObject:(NSArray*)ArrayObj;
// 压缩图片到指定大小
+ (NSData *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength;
// 校验身份证号是否合法
+ (BOOL)isCorrect:(NSString *)IDNumber;
// MD5加密
+ (NSString *)md5:(NSString *)string;
// 校验手机号
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
//计算tag标签所占用内容的高度
+ (NSInteger)changeCollectionViewHeight:(NSMutableArray *)modelARR WithWidth:(CGFloat)width;
+ (NSInteger)changeCollectionViewHeightSTR:(NSString *)Str WithWidth:(CGFloat)width;
//根据字符串内容的多少  在固定宽度 下计算出实际的行高
+ (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size;
//获取iOS版本号
+ (double)getCurrentIOS;
@end

NS_ASSUME_NONNULL_END
