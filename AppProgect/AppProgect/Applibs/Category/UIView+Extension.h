//
//  UIView+Extension.h
//  XZ_WeChat
//
//  Created by 郭现壮 on 16/2/17.
//  Copyright © 2016年 XianZhuangGuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic,assign) CGFloat left;
@property (nonatomic,assign) CGFloat top;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGFloat right;
@property (nonatomic,assign) CGFloat bottom;
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGPoint origin;
@property (nonatomic,assign) CGSize size;
@property (nonatomic,assign) CGFloat centerX;
@property (nonatomic,assign) CGFloat centerY;

/**
 *  Center the view.
 */
- (void)centerInRect:(CGRect)rect;
- (void)centerVerticallyInRect:(CGRect)rect;
- (void)centerHorizontallyInRect:(CGRect)rect;

- (void)centerInSuperView;
- (void)centerVerticallyInSuperView;
- (void)centerHorizontallyInSuperView;

- (void)centerHorizontallyBelow:(UIView *)view padding:(CGFloat)padding;
- (void)centerHorizontallyBelow:(UIView *)view;


/**
 *  Remove all subviews.
 *
 *  @warning Never call this method inside your view's drawRect: method.
 */
- (void)removeAllSubviews;

/**
 *  Save the view to Photo.
 */
- (void)saveViewToPhoto;


/**
 *  获取当前view的父视图控制器
 *
 *  Returns the view's view controller (may be nil).
 */
- (UIViewController *)viewController;

/**
 *  返回当前veiw的所有层级结构
 *
 *  @return 字符串
 */
- (NSString *)viewAllSubViewToXMLString;

/**
 *  layer border radius
 */
- (void)setLayerBorderWidth:(CGFloat)width borderColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;

//
+ (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width;

/**
 *  Shortcut to set the view.layer's shadow
 *
 *  @param color  Shadow Color
 *  @param offset Shadow offset
 *  @param radius Shadow radius
 */
- (void)setLayerShadowColor:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius;

/**
 *
 */
- (void)drawInnerShadowInRect:(CGRect)rect fillColor:(UIColor *)fillColor;
- (void)drawInnerShadowInRect:(CGRect)rect radius:(CGFloat)radius fillColor:(UIColor *)fillColor;


@end
