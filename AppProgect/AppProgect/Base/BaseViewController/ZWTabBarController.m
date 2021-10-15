//
//  ZWTabBarController.m
//  NBJKCardHome
//
//  Created by step_zhang on 2020/11/24.
//

#import "ZWTabBarController.h"
#import "ZWNavigationController.h"
#import "HTHomeViewController.h"
#import "HTMyViewController.h"

@interface ZWTabBarController ()<UITabBarControllerDelegate>
@property (nonatomic,assign) NSInteger  indexFlag;
@end

@implementation ZWTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.indexFlag = 0;
    [self setupChildViewController:[[HTHomeViewController alloc] init]
                             title:@"首页"
                             image:@"bottom_icon1"
                     selectedImage:@"bottom_icon11"];
    [self setupChildViewController:[[HTMyViewController alloc] init]
                            title:@"我的"
                            image:@"bottom_icon5"
                    selectedImage:@"bottom_icon15"];
   
}
//在这里,处理tabbar的样式,整个生命周期中,只会走一次
+ (void)initialize {
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSFontAttributeName] = [UIFont zwwNormalFont:12];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#A9A9A9"];
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = [UIFont zwwNormalFont:14];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#2660AD"];
    UITabBarItem *appearance = [UITabBarItem appearance];
    [appearance setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [appearance setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    //设置tabbar的颜色
    [[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    [[UITabBar appearance] setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];
    [UITabBar appearance].translucent = NO;
}
- (void)showBadgeOnItemIndex:(NSInteger)index
                   withValue:(NSInteger)badgeVal{
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    //新建小红点
    UILabel *badgeView = [[UILabel alloc] init];
    //文本
    //badgeView.text = badgeVal>99?@"...":[NSString stringWithFormat:@"%ld",badgeVal];
    badgeView.textColor = [UIColor whiteColor];
    badgeView.font = [UIFont zwwNormalFont:9];
    badgeView.adjustsFontSizeToFitWidth = YES;
    badgeView.textAlignment = NSTextAlignmentCenter;
    badgeView.tag = 1000 + index;
    badgeView.layer.cornerRadius = 7.5;//圆形
    badgeView.backgroundColor = [UIColor redColor];//颜色：红色
    CGRect tabFrame = self.tabBar.frame;
    
    //确定小红点的位置
    CGFloat percentX = (index + 0.6) / 5;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height) - 10;
    badgeView.frame = CGRectMake(x, y, 15.0, 15.0);//圆形大小为10
    badgeView.clipsToBounds = YES;
    [self.tabBar addSubview:badgeView];
    [self.tabBar bringSubviewToFront:badgeView];
}
//隐藏小红点
- (void)hideBadgeOnItemIndex:(NSInteger)index{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}
//移除小红点
- (void)removeBadgeOnItemIndex:(NSInteger)index{
    //按照tag值进行移除
    for (UIView*subView in self.tabBar.subviews) {
        if (subView.tag == 1000+index) {
            [subView removeFromSuperview];
        }
    }
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSInteger index = [self.tabBar.items indexOfObject:item];
    if (index != self.indexFlag) {
        //执行动画
        NSMutableArray *arry = [NSMutableArray array];
        for (UIView *btn in self.tabBar.subviews) {
            if ([btn isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                 [arry addObject:btn];
            }
        }
        //添加动画
        //放大效果
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        //速度控制函数，控制动画运行的节奏
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.duration = 0.2;       //执行时间
        animation.repeatCount = 1;      //执行次数
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;           //保证动画效果延续
        animation.fromValue = [NSNumber numberWithFloat:1.0];   //初始伸缩倍数
        animation.toValue = [NSNumber numberWithFloat:1.15];     //结束伸缩倍数
        [[arry[index] layer] addAnimation:animation forKey:nil];
        //移除其他tabbar的动画
        for (int i = 0; i<arry.count; i++) {
            if (i != index) {
                [[arry[i] layer] removeAllAnimations];
            }
        }
        self.indexFlag = index;
    }
}
- (void)setupChildViewController:(UIViewController *)childController
                           title:(NSString *)title
                           image:(NSString *)image
                   selectedImage:(NSString *)selectedImage {
    //childController.title = title; //因为 自定义导航,所以这里不需要写
    [childController.tabBarItem setImage:[UIImage imageNamed:image]];
    [childController.tabBarItem setSelectedImage:[UIImage imageNamed:selectedImage]];
    ZWNavigationController *navCon = [[ZWNavigationController alloc] initWithRootViewController:childController];
   // navCon.title = title;   //因为 自定义导航,所以这里不需要写
     childController.tabBarItem.title = title;
    [self addChildViewController:navCon];
}
@end
