//
//  ZWBaseViewController.h
//  NBJKCardHome
//
//  Created by step_zhang on 2020/11/24.
//

#import <UIKit/UIKit.h>
#import "ZWBaseViewControllerProtocol.h"
#import "ZWNavigationController.h"
#import "ZWMessage.h"
#import "YJProgressHUD.h"
#import "ZSKAlertView.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZWBaseViewController : UIViewController<ZWBaseViewControllerProtocol>
@property (nonatomic, assign) BOOL isHidenHomeLine;
@property (nonatomic, assign) BOOL statusBarHidden;
@property (nonatomic, strong) UIView *navigationView;
@property (nonatomic, strong) UIView *navigationBgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
- (void)setTitle:( NSString * _Nullable )title;
- (void)showLeftBackButton;

@end

NS_ASSUME_NONNULL_END
