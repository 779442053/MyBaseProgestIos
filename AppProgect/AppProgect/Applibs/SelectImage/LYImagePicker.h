//
//  LYImagePicker.h
//  ImagePicker
//
//  Created by Teonardo on 2019/7/18.
//  Copyright © 2019 Teonardo. All rights reserved.
//
#import <UIKit/UIKit.h>

/********************************************
 需配置以下权限:
 Privacy - Camera Usage Description (相机使用权限)
 Privacy - Photo Library Usage Description (相册使用权限)
 
 注意: 为解决系统相机调用后界面为英文, 需
 在info.plist中添加 Localized resources can be mixed 字段, 设置为YES（表示是否允许应用程序获取框架库内语言）
 ********************************************/

NS_ASSUME_NONNULL_BEGIN
@class LYImagePicker;
@protocol LYImagePickerDelegate <NSObject>
@optional;

/**
 选择图片完成时调用

 @param picker LYImagePicker对象
 @param image 选取的图片. 默认是编辑后的图片; 若设置了不允许编辑, 则是原图.
 */
- (void)imagePicker:(LYImagePicker *)picker didFinishPickingImage:(UIImage *)image;

@end

@interface LYImagePicker : NSObject

/**
 是否允许编辑, 默认允许编辑.
 */
@property (nonatomic, assign) BOOL allowsEditing;
@property (nonatomic, weak) id<LYImagePickerDelegate> delegate;


/**
 显示, 只显示"选择图片"的message.
 */
- (void)show;

/**
 自定义方式显示,可以设置title和message

 @param title 标题
 @param message 内容
 */
- (void)showWithTitle:(NSString *__nullable)title message:(NSString *__nullable)message;

#pragma mark - 手动调用
/**
 拍照
 */
- (void)takePhoto;

/**
 相册
 */
- (void)openAlbum;

@end

NS_ASSUME_NONNULL_END
