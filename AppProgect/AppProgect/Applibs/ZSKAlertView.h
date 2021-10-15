//
//  ZSKAlertView.h
//  NorthBayProject
//
//  Created by akun on 2020/5/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZSKAlertViewBlock)(NSInteger index);

@interface ZSKAlertView : UIView

+ (void)showWithTitle:(NSString *)title message:(NSString *)message btnTitle:(NSString *)btnTitle completeBlock:(ZSKAlertViewBlock)block;


+ (void)showWithTitle:(NSString *)title message:(NSString *)message sureBtnTitle:(NSString *)sureTitle cancleBtnTitle:(NSString *)cancleTitle completeBlock:(ZSKAlertViewBlock)block;

@end

NS_ASSUME_NONNULL_END
