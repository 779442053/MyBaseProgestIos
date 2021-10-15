//
//  ZWMessage.m
//  Bracelet
//
//  Created by 张威威 on 2017/11/8.
//  Copyright © 2017年 ShYangMiStepZhang. All rights reserved.
//

#import "ZWMessage.h"
#import "RMessage.h"
#import "RMessageView.h"
#import "UIViewController+ZWUIViewController.h"

@interface ZWMessage () <RMessageProtocol>

@end
@implementation ZWMessage
+(void)initialize
{
    //如果需要自定义,在配置json文件里面进行配置即可
    //[RMessage addDesignsFromFileWithName:@"AlternativeDesigns" inBundle:[NSBundle mainBundle]];
    //如果应用支持横屏.在代理里面添加下面代码即可
//    - (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
//    {
//        [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
//        [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
//            [RMessage interfaceDidRotate];
//        }];
//    }
    
    [RMessage setDefaultViewController:[self controllerToBeShownIn]];
    //[RMessage setDelegate:[self controllerToBeShownIn]];
    //需要遵循该第三方的额协议.当遵循了协议之后,就可以进行自定义的操作
}

+ (UIViewController*)controllerToBeShownIn
{
    UIViewController* rootController = [UIViewController rootViewController];
    UIViewController* presentedViewController = [rootController presentedViewController];
    if(presentedViewController)
    {
        if([presentedViewController isKindOfClass:[UINavigationController class]])
        {
            return [(UINavigationController*)presentedViewController topViewController];
        }
        return presentedViewController;
    }
    return rootController;
}
+ (void)error:(NSString*)error title:(NSString *)title//错误
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [RMessage
         showNotificationWithTitle:title
         subtitle:error
         type:RMessageTypeError
         customTypeName:nil
         callback:nil];
    });
    
}
+ (void)message:(NSString*)msg title:(NSString *)title{
    dispatch_async(dispatch_get_main_queue(), ^{
        [RMessage showNotificationWithTitle:title
                                   subtitle:msg
                                       type:RMessageTypeNormal
                             customTypeName:nil
                                   callback:nil];
    });
}

+ (void)success:(NSString*)msg title:(NSString *)title{
    dispatch_async(dispatch_get_main_queue(), ^{
//        [RMessage showNotificationWithTitle:title
//                                   subtitle:msg
//                                       type:RMessageTypeSuccess
//                             customTypeName:nil
//                                   callback:nil];
        //[RMessage showNotificationWithTitle:title subtitle:msg type:RMessageTypeSuccess customTypeName:nil duration:1.0 callback:nil];
        [RMessage showNotificationInViewController:[self controllerToBeShownIn]
                                             title:title
                                          subtitle:msg
                                         iconImage:nil
                                              type:RMessageTypeSuccess
                                    customTypeName:nil
                                          duration:1.5
                                          callback:nil
                                       buttonTitle:nil
                                    buttonCallback:nil
                                        atPosition:RMessagePositionNavBarOverlay
                              canBeDismissedByUser:YES];
    });
}
+ (void)Warning:(NSString*)msg title:(NSString *)title{
    dispatch_async(dispatch_get_main_queue(), ^{
        [RMessage showNotificationWithTitle:title
                                   subtitle:msg
                                       type:RMessageTypeWarning
                             customTypeName:nil
                                   callback:nil];
    });
}
+ (void)setDefaultViewController:(UINavigationController *)myNav{
    [RMessage setDefaultViewController:myNav];
}

/*
 ====长文提示
 [RMessage
 showNotificationWithTitle:NSLocalizedString(@"With 'Text' I meant a long text, so here it is", nil)
 subtitle:NSLocalizedString(@"Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed "
 @"diam nonumy eirmod tempor invidunt ut labore et dolore magna "
 @"aliquyam erat, sed diam voluptua. At vero eos et accusam et "
 @"justo duo dolores et ea rebum. Stet clita kasd gubergren, no "
 @"sea takimata sanctus.At vero eos et accusam et justo duo "
 @"dolores et ea rebum. Stet clita kasd gubergren, no sea takimata "
 @"sanctus.Lorem ipsum dolor sit amet, consetetur sadipscing "
 @"elitr, sed diam nonumy eirmod tempor invidunt ut labore et "
 @"dolore magna aliquyam erat, sed diam voluptua. At vero eos et "
 @"accusam et justo duo dolores et ea rebum. Stet clita kasd "
 @"gubergren, no sea takimata sanctus.At vero eos et accusam et "
 @"justo duo dolores et ea rebum. Stet clita kasd gubergren, no "
 @"sea takimata sanctus.",
 nil)
 type:RMessageTypeWarning
 customTypeName:nil
 callback:nil];
 
 //在消息中添加一个图标图像，出现在左边
 [RMessage showNotificationInViewController：self
 title：@“ Update available ”
 subtitle：@“ Please update the app ”
 iconImage： iconUIImageHere
 type： RMessageTypeNormal
 customTypeName：nil
 duration： RMessageDurationAutomatic
 callback：nil
 buttonTitle：@“ Update ”
 buttonCallback： ^ {
 NSLog（@“用户点击按钮”）;
 }
 atPosition： RMessagePositionTop
 canBeDismissedByUser：YES ];
 
 
 //////=====https://github.com/donileo/RMessage(翻墙翻译汉语)
 
 */

@end
