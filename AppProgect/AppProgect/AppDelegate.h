//
//  AppDelegate.h
//  AppProgect
//
//  Created by step_zhang on 2021/9/1.
//

#import <UIKit/UIKit.h>
@class ZWTabBarController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong)  ZWTabBarController*tabBarController;
+ (AppDelegate *)shareAppDelegate;
@end

