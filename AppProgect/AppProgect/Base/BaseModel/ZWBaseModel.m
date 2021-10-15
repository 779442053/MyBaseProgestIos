//
//  ZWBaseModel.m
//  NBJKCardHome
//
//  Created by step_zhang on 2020/11/20.
//

#import "ZWBaseModel.h"

@implementation ZWBaseModel
/**
   规避后端返回的特殊字段造成的程序闪退或者数据异常的情况
 */
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}
@end
