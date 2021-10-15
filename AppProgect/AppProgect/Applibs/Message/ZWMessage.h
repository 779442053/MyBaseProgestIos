//
//  ZWMessage.h
//  Bracelet
//
//  Created by 张威威 on 2017/11/8.
//  Copyright © 2017年 ShYangMiStepZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ZWMessage : NSObject

+ (void)error:(NSString*)error title:(NSString *)title;
+ (void)message:(NSString*)msg title:(NSString *)title;
+ (void)success:(NSString*)msg title:(NSString *)title;
+ (void)Warning:(NSString*)msg title:(NSString *)title;
+ (void)setDefaultViewController:(UINavigationController *)myNav;
@end
