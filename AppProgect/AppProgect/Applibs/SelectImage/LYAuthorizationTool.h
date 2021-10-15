//
//  LYAuthorizationTool.h
//  ImagePicker
//
//  Created by Teonardo on 2019/7/18.
//  Copyright © 2019 Teonardo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LYAuthorizationTool : NSObject
+ (void)ly_requestCameraAuthorization:(void(^)(BOOL granted))completion;
+ (void)ly_requestPhotoLibraryAuthorization:(void(^)(BOOL granted))completion;

@end

NS_ASSUME_NONNULL_END
