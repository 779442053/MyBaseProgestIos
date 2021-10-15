//
//  ThirdMacros.h
//  NBJKCardHome
//
//  Created by step_zhang on 2020/11/20.
//

#ifndef ThirdMacros_h
#define ThirdMacros_h
/**
 记录一些第三方的key 或者常用字符串
 */
//颜色的相关配置
#define ZWColorTheme       [UIColor colorWithHexString:@"#2660AD"]
#define ZWColorTitle       [UIColor colorWithHexString:@"#333333"]
#define ZWColorline       [UIColor colorWithHexString:@"#F5F5F5"]


// 16进制数
#define Color_RGB_HEX(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define Color_999999   Color_RGB_HEX(0x999999)//灰色
#define Color_000000   Color_RGB_HEX(0x000000)//黑色
#define Color_ffffff   Color_RGB_HEX(0xffffff)//白色
#endif /* ThirdMacros_h */

/**
 if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
             // do something in main thread
             NSLog(@"--main thread");
         } else {
             // do something in other thread
             NSLog(@"--other thread");
             
         }
 
 
 NSLog(@"main thread:%@",[NSThread currentThread]);
 
 //    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
 //    UIAlertAction *photoAlbumAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
 //
 //
 //    }];
 //    UIAlertAction *cemeraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
 //
 //    }];
 //    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
 //
 //    }];
 //    [alertController addAction:photoAlbumAction];
 //    [alertController addAction:cancleAction];
 //    [self.navigationController presentViewController:alertController animated:YES completion:nil];
 
 */

