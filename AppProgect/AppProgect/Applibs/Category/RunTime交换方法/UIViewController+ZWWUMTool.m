//
//  UIViewController+ZWWUMTool.m
//  MyBaseProgect
//
//  Created by  on 2018/5/11.
//  Copyright © 2018年 . All rights reserved.
//
//关于友盟大点统计某一个按钮的点击次数,,,,https://www.jianshu.com/p/d96973e15e4a
#import "UIViewController+ZWWUMTool.h"
//#import <UMMobClick/MobClick.h>
#import <objc/runtime.h>
@implementation UIViewController (ZWWUMTool)

+(void)load{
    // 交换方法
    
    // 获取 zw_viewWillAppear: 方法
    Method zw_viewWillAppear = class_getClassMethod(self, @selector(zw_viewWillAppear:));
    // 获取 viewWillAppear 方法
    Method viewWillAppear = class_getClassMethod(self, @selector(viewWillAppear:));
    // 交换方法地址, 相当于交换实现
    method_exchangeImplementations(zw_viewWillAppear, viewWillAppear);
    
    Method zw_viewWillDisappear = class_getClassMethod(self, @selector(zw_viewWillDisappear:));
    Method viewWillDisappear = class_getClassMethod(self, @selector(viewWillDisappear:));
    method_exchangeImplementations(zw_viewWillDisappear, viewWillDisappear);
}
//新的viewWillAppear方法
- (void)zw_viewWillAppear:(BOOL)animated
{
    [self zw_viewWillAppear:animated];
    //开始友盟页面统计
    //[MobClick beginLogPageView:[RuntimeKit fetchClassName:[self class]]];
    
    //当然这里也可以使用self.title作为页面的名称，这样在友盟后台查看的时候更加方便些
    //[MobClick beginLogPageView:self.title];
}

//新的viewWillDisappear方法
- (void)zw_viewWillDisappear:(BOOL)animated
{
    [self zw_viewWillDisappear:animated];
    //结束友盟页面统计
    //[MobClick endLogPageView:[RuntimeKit fetchClassName:[self class]]];
    
    //当然这里也可以使用self.title作为页面的名称，这样在友盟后台查看的时候更加方便些
    //[MobClick endLogPageView:self.title];
}



@end
