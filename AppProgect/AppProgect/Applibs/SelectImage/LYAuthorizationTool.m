//
//  LYAuthorizationTool.m
//  ImagePicker
//
//  Created by Teonardo on 2019/7/18.
//  Copyright © 2019 Teonardo. All rights reserved.
//

#import "LYAuthorizationTool.h"
// 相册权限
#import <Photos/Photos.h>
//
#import "UIViewController+LYCurrentVC.h"
#import "UIApplication+LYURLTool.h"

@interface LYAuthorizationTool ()

@end

@implementation LYAuthorizationTool

#pragma mark - Public Method
+ (void)ly_requestCameraAuthorization:(void(^)(BOOL granted))completion {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!granted) {
                        [self ly_showCameraAuthorizationSettingAlert];
                    }
                    !completion ? : completion(granted);
                });
            }];
            break;
        }
        case AVAuthorizationStatusRestricted:
        {
            [self ly_showCancelAlertWithTitle:@"无法访问相机" message:@"无法授权, 操作受限"];
            break;
        }
        case AVAuthorizationStatusDenied:
        {
            [self ly_showCameraAuthorizationSettingAlert];
            break;
        }
        case AVAuthorizationStatusAuthorized:
        {
            !completion ? : completion(YES);
            break;
        }
            
        default:
            break;
    }
}

+ (void)ly_requestPhotoLibraryAuthorization:(void(^)(BOOL granted))completion {
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusNotDetermined: // 未决定权限
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (status == PHAuthorizationStatusDenied) {
                        [self ly_showPhotoLibraryAuthorizationSettingAlert];
                    }
                    !completion ? : completion(status == PHAuthorizationStatusAuthorized);
                });
            }];
            break;
        }
        case PHAuthorizationStatusRestricted: // 未授权, 用户活动受限, 比如开启了家长控制
        {
            [self ly_showCancelAlertWithTitle:@"无法访问相册" message:@"无法授权, 操作受限"];
            break;
        }
        case PHAuthorizationStatusDenied:// 已禁止权限
        {
            [self ly_showPhotoLibraryAuthorizationSettingAlert];
            break;
        }
        case PHAuthorizationStatusAuthorized: // 已授予权限
        {
            !completion ? : completion(YES);
            break;
        }
        default:
            break;
    }
}

#pragma mark - Private Method
/**
 显示设置权限提示

 @param title 提示的标题
 @param message 提示的内容
 */
+ (void)ly_showSettingAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *settingAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [UIApplication ly_openSettings];
    }];
    
    [alertController addAction:cancleAction];
    [alertController addAction:settingAction];
    UIViewController *currentVC = [UIViewController ly_currrentVC];
    [currentVC presentViewController:alertController animated:YES completion:nil];
}


/**
 显示操作取消的提示

 @param title 提示的标题
 @param message 提示的内容
 */
+ (void)ly_showCancelAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:cancleAction];
    UIViewController *currentVC = [UIViewController ly_currrentVC];
    [currentVC presentViewController:alertController animated:YES completion:nil];
}

+ (void)ly_showPhotoLibraryAuthorizationSettingAlert {
    [self ly_showSettingAlertWithTitle:@"无法访问相册" message:@"请在iPhone的\"设置-隐私-相册\"中允许访问相册"];
}

+ (void)ly_showCameraAuthorizationSettingAlert {
    [self ly_showSettingAlertWithTitle:@"无法访问相机" message:@"请在iPhone的\"设置-隐私-相机\"中允许访问相机"];
}



@end
