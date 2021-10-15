//
//  YJProgressHUD.h
//  YJGeneralProject
//
//  Created by 叶炯 on 2017/4/12.
//  Copyright © 2017年 YeJiong. All rights reserved.
//
#import "MBProgressHUD.h"
typedef NS_ENUM(NSInteger, ZWProgressHUDStatus) {
    
    /** 成功 */
    ZWProgressHUDStatusSuccess,
    
    /** 失败 */
    ZWProgressHUDStatusError,
    
    /** 警告*/
    ZWProgressHUDStatusWaitting,
    
    /** 提示 */
    ZWProgressHUDStatusInfo,
    
    /** 等待 */
    ZWProgressHUDStatusLoading

};
@interface YJProgressHUD : MBProgressHUD
/**
 *  是否正在显示
 */
@property (nonatomic, assign, getter=isShowNow) BOOL showNow;
/** 返回一个 HUD 的单例 */
+ (instancetype)sharedHUD;

/** 在 window 上添加一个 HUD */
+ (void)showStatus:(ZWProgressHUDStatus)status text:(NSString *)text;
#pragma mark - 建议使用的方法
/** 在 window 上添加一个只显示文字的 HUD */
+ (void)showMessage:(NSString *)text;

/** 在 window 上添加一个提示`信息`的 HUD */
+ (void)showWaiting:(NSString *)text;

/** 在 window 上添加一个提示`失败`的 HUD */
+ (void)showError:(NSString *)text;

/** 在 window 上添加一个提示`成功`的 HUD */
+ (void)showSuccess:(NSString *)text;

/** 在 window 上添加一个提示`等待`的 HUD, 需要手动关闭 */
+ (void)showLoading:(NSString *)text;

/** 手动隐藏 HUD */
+ (void)hideHUD;
@end
