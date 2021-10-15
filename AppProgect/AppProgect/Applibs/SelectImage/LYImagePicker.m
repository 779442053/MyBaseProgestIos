//
//  LYImagePicker.m
//  ImagePicker
//
//  Created by Teonardo on 2019/7/18.
//  Copyright © 2019 Teonardo. All rights reserved.
//

#import "LYImagePicker.h"
#import "LYAuthorizationTool.h"
#import "UIViewController+LYCurrentVC.h"

@interface LYImagePicker () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePicker;

@end

@implementation LYImagePicker

- (instancetype)init
{
    self = [super init];
    if (self) {
        _allowsEditing = YES; // 默认允许编辑
    }
    return self;
}

- (void)show {
    [self showWithTitle:nil message:@"选择图片"];
}

- (void)showWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIViewController *currentVC = [UIViewController ly_currrentVC];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
    }];
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openAlbum];
    }];
    
    [alertController addAction:cancleAction];
    [alertController addAction:cameraAction];
    [alertController addAction:albumAction];
    [currentVC presentViewController:alertController animated:YES completion:nil];
}

- (void)takePhoto {
    // 1 先判断相机是否可用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self showAlertWithTitle:@"提示" message:@"相机不可用"];
        return;
    }
    
    // 2 再判断用户是否授权
    [LYAuthorizationTool ly_requestCameraAuthorization:^(BOOL granted) {
        if (granted) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            UIViewController *currentVC = [UIViewController ly_currrentVC];
            [currentVC presentViewController:self.imagePicker animated:YES completion:nil];
        }
    }];
}

- (void)openAlbum {
    // 1 先判断相册是否可用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [self showAlertWithTitle:@"提示" message:@"相册不可用"];
        return;
    }
    
    // 2 再判断用户是否授权
    [LYAuthorizationTool ly_requestPhotoLibraryAuthorization:^(BOOL granted) {
        if (granted) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            UIViewController *currentVC = [UIViewController ly_currrentVC];
            [currentVC presentViewController:self.imagePicker animated:YES completion:nil];
        }
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
    
    if ([self.delegate respondsToSelector:@selector(imagePicker:didFinishPickingImage:)]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];;
        if (!self.allowsEditing) {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        [self.delegate imagePicker:self didFinishPickingImage:image];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private Method
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:cancleAction];
    UIViewController *currentVC = [UIViewController ly_currrentVC];
    [currentVC presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Setter
- (void)setAllowsEditing:(BOOL)allowsEditing {
    _allowsEditing = allowsEditing;
    self.imagePicker.allowsEditing = allowsEditing;
}

#pragma mark - Getter
- (UIImagePickerController *)imagePicker {
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.allowsEditing = YES; // 默认允许编辑, 在代理方法中返回的是编辑后的图片
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}

@end
