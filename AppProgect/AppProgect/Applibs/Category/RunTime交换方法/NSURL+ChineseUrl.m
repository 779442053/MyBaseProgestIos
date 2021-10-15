//
//  NSURL+ChineseUrl.m
//  KuaiZhu
//
//  Created by step_zhang on 2019/11/1.
//  Copyright © 2019 su. All rights reserved.
//

#import "NSURL+ChineseUrl.h"
#import <objc/runtime.h>
@implementation NSURL (ChineseUrl)
+ (void)load {
    /*
     self:UIImage
     谁的事情,谁开头 1.发送消息(对象:objc) 2.注册方法(方法编号:sel) 3.交互方法(方法:method) 4.获取方法(类:class)
     Method:方法名

     获取方法,方法保存到类
     Class:获取哪个类方法
     SEL:获取哪个方法
     imageName
     */
    // 获取imageName:方法的地址
    Method URLWithStringMethod = class_getClassMethod(self, @selector(URLWithString:));

    // 获取sc_imageWithName:方法的地址
    Method sc_URLWithStringMethod = class_getClassMethod(self, @selector(sc_URLWithString:));

    // 交换方法地址，相当于交换实现方式2
    method_exchangeImplementations(URLWithStringMethod, sc_URLWithStringMethod);

}
+ (NSURL *)sc_URLWithString:(NSString *)URLString {
    NSString *newURLString = [self IsChinese:URLString];
    return [NSURL sc_URLWithString:newURLString];
}
//判断是否有中文
+ (NSString *)IsChinese:(NSString *)str {
    NSString *newString = str;
    for(int i=0; i< [str length];i++){
            int a = [str characterAtIndex:i];
            if( a > 0x4e00 && a < 0x9fff)
            {
                 newString = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //            NSString *oldString = [str substringWithRange:NSMakeRange(i, 1)];
    //            NSString *string = [oldString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //            newString = [newString stringByReplacingOccurrencesOfString:oldString withString:string];
            } else{

            }
        }
    return newString;
}
@end
