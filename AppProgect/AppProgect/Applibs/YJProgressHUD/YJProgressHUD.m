//

#import "YJProgressHUD.h"
#import "AppDelegate+HTAppdelegateCategory.h"
// 背景视图的宽度/高度
#define BGVIEW_WIDTH 100.0f
// 文字大小
#define TEXT_SIZE    16.0f
@implementation YJProgressHUD
+ (instancetype)sharedHUD {
    static id hud;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hud = [[self alloc] initWithView:[UIApplication sharedApplication].keyWindow];
        //[UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
        [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = [UIColor whiteColor];
        
    });
    return hud;
}
+ (void)showStatus:(ZWProgressHUDStatus)status text:(NSString *)text {
    YJProgressHUD *HUD = [YJProgressHUD sharedHUD];
    HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    HUD.bezelView.backgroundColor = [UIColor blackColor];
    [HUD setRemoveFromSuperViewOnHide:YES];
    [HUD showAnimated:YES];
    [HUD setShowNow:YES];
    [HUD setMinSize:CGSizeMake(BGVIEW_WIDTH, BGVIEW_WIDTH)];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:HUD];
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"ZWProgressHUD" ofType:@"bundle"];
    switch (status) {
        case ZWProgressHUDStatusSuccess: {
            NSString *sucPath = [bundlePath stringByAppendingPathComponent:@"MBHUD_Success.png"];
            UIImage *sucImage = [UIImage imageWithContentsOfFile:sucPath];
            HUD.mode = MBProgressHUDModeCustomView;
            UIImageView *sucView = [[UIImageView alloc] initWithImage:sucImage];
            HUD.customView = sucView;
            HUD.label.text = text;
            HUD.label.numberOfLines = 0;
            HUD.label.textColor = [UIColor whiteColor];
            HUD.label.font = [UIFont boldSystemFontOfSize:TEXT_SIZE];
            [HUD hideAnimated:YES afterDelay:1.5f];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [HUD setShowNow:NO];
                [HUD hideAnimated:YES];
            });
        }
            break;
        case ZWProgressHUDStatusError: {
            NSString *errPath = [bundlePath stringByAppendingPathComponent:@"MBHUD_Error.png"];
            UIImage *errImage = [UIImage imageWithContentsOfFile:errPath];
            HUD.mode = MBProgressHUDModeCustomView;
            UIImageView *errView = [[UIImageView alloc] initWithImage:errImage];
            HUD.customView = errView;
            HUD.label.text = text;
            HUD.label.numberOfLines = 0;
            HUD.label.textColor = [UIColor whiteColor];
            HUD.label.font = [UIFont boldSystemFontOfSize:TEXT_SIZE];
            [HUD hideAnimated:YES afterDelay:2.5f];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [HUD setShowNow:NO];
                [HUD hideAnimated:YES];
            });
        }
            break;
        case ZWProgressHUDStatusLoading: {
            HUD.label.text = text;
            HUD.label.numberOfLines = 0;
            [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = [UIColor whiteColor];
            HUD.label.textColor = [UIColor whiteColor];
            HUD.label.font = [UIFont boldSystemFontOfSize:TEXT_SIZE];
            HUD.mode = MBProgressHUDModeIndeterminate;//MBProgressHUDModeIndeterminate
        }
            break;
        case ZWProgressHUDStatusWaitting: {
            NSString *infoPath = [bundlePath stringByAppendingPathComponent:@"MBHUD_Warn.png"];
            UIImage *infoImage = [UIImage imageWithContentsOfFile:infoPath];
            HUD.mode = MBProgressHUDModeCustomView;//自定义视图
            UIImageView *infoView = [[UIImageView alloc] initWithImage:infoImage];
            HUD.customView = infoView;
            HUD.label.text = text;
            HUD.label.numberOfLines = 0;
            HUD.label.textColor = [UIColor whiteColor];
            HUD.label.font = [UIFont boldSystemFontOfSize:TEXT_SIZE];
            [HUD hideAnimated:YES afterDelay:1.5f];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [HUD setShowNow:NO];
                 [HUD hideAnimated:YES];
            });
        }
            break;
        case ZWProgressHUDStatusInfo: {
            NSString *infoPath = [bundlePath stringByAppendingPathComponent:@"MBHUD_Info.png"];
            UIImage *infoImage = [UIImage imageWithContentsOfFile:infoPath];
            HUD.mode = MBProgressHUDModeCustomView;
            UIImageView *infoView = [[UIImageView alloc] initWithImage:infoImage];
            HUD.customView = infoView;
            HUD.label.text = text;
            HUD.label.numberOfLines = 0;
            HUD.label.textColor = [UIColor whiteColor];
            HUD.label.font = [UIFont boldSystemFontOfSize:TEXT_SIZE];
            [HUD hideAnimated:YES afterDelay:1.5f];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [HUD setShowNow:NO];
                [HUD hideAnimated:YES];
            });
        }
            break;
        default:
            break;
    }
}
+ (void)showMessage:(NSString *)text {
    YJProgressHUD *HUD = [YJProgressHUD sharedHUD];
     HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    HUD.bezelView.backgroundColor = [UIColor blackColor];
    [HUD showAnimated:YES];
    [HUD setShowNow:YES];
    HUD.label.text = text;
    HUD.label.numberOfLines = 0;
    HUD.label.textColor = [UIColor whiteColor];
    HUD.detailsLabel.textColor = [UIColor whiteColor];
    [HUD setRemoveFromSuperViewOnHide:YES];
    HUD.label.font = [UIFont boldSystemFontOfSize:TEXT_SIZE];
    [HUD setMinSize:CGSizeMake(BGVIEW_WIDTH, BGVIEW_WIDTH)];
    HUD.mode = MBProgressHUDModeCustomView;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:HUD];
    [HUD hideAnimated:YES afterDelay:1.5f];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUD setShowNow:NO];
        [HUD hideAnimated:YES];
    });
}
+ (void)showWaiting:(NSString *)text {
    [self showStatus:ZWProgressHUDStatusWaitting text:text];
}
+ (void)showError:(NSString *)text {
    [self showStatus:ZWProgressHUDStatusError text:text];
}
+ (void)showSuccess:(NSString *)text {
    [self showStatus:ZWProgressHUDStatusSuccess text:text];
}
+ (void)showLoading:(NSString *)text {
    [self showStatus:ZWProgressHUDStatusLoading text:text];
    
}
+ (void)hideHUD {
    [[YJProgressHUD sharedHUD] setShowNow:NO];
    [[YJProgressHUD sharedHUD] hideAnimated:YES];
}


@end
