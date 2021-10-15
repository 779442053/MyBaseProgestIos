//
//  ZWAPIConseKey.h
//  EasyIM
//
//  Created by step on 2019/10/31.
//  Copyright © 2019 step. All rights reserved.
//
#pragma ===========这里是API接口 =============
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWAPIConseKey : NSObject
// 服务地址
FOUNDATION_EXTERN NSString *const HTURL;//生产环境
FOUNDATION_EXTERN NSString *const HTURL_Test;//tese环境
FOUNDATION_EXTERN NSString *const HTURL_Mall;//mall 打包环境

/*****  登陆注册忘记密码  *****/
FOUNDATION_EXTERN NSString *const Login;
FOUNDATION_EXTERN NSString *const Regist;

@end

NS_ASSUME_NONNULL_END
