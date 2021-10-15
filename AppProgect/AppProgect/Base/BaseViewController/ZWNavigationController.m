//
//  ZWNavigationController.m
//  NBJKCardHome
//
//  Created by step_zhang on 2020/11/24.
//

#import "ZWNavigationController.h"
#define Color_RGB_HEX(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define Color_000000   Color_RGB_HEX(0x000000)
#define Color_ffffff   Color_RGB_HEX(0xffffff)
@interface ZWNavigationController ()<UINavigationControllerDelegate>
@property (nonatomic, assign) BOOL pushing;
@end

@implementation ZWNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    //全部隐藏导航,采用完全自定义导航的方式进行.(考虑到当前项目的复杂程度.易港通公司......)
    self.navigationBar.hidden = YES;
    [[UINavigationBar appearance] setTranslucent:NO];
    
    /**
    UINavigationBar * navBar = self.navigationBar;
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName:Color_000000,
                                   NSFontAttributeName:[UIFont systemFontOfSize:20]};

    UIImage * bgImg = [UIImage imageWithColor:Color_ffffff];
    [navBar setBackgroundImage:bgImg forBarMetrics:UIBarMetricsDefault];
    navBar.shadowImage = [UIImage new];
    [navBar setTranslucent:NO];
     */
}

#pragma mark - UINavigationControllerDelegate
-(void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion{
    ZWWLog(@"基类 拦截带有导航的present 方法==基类 拦截带有导航的present 方法")
    viewControllerToPresent.modalPresentationStyle = 0;
    if ([viewControllerToPresent isKindOfClass:[UIImagePickerController class]]) {
//        ZWWLog(@"选择相册,将导航栏显示出来")
//        viewControllerToPresent.navigationController.navigationBar.hidden = YES;
//        viewControllerToPresent.navigationController.navigationBar.translucent = NO;
    }
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.pushing) {
        return;
    }else{
        self.pushing = YES;
    }
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [self.view endEditing:YES];//无论push还是pop  都将当前界面的键盘消失
    //拦截push进来的控制器.在这里拿到控制器进行控制器的布局
    [super pushViewController:viewController animated:animated];
}
//ios 14  针对popfootVC 上面,tabbar消失的bug
- (NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    if (self.viewControllers.count > 1) {
        self.topViewController.hidesBottomBarWhenPushed = NO;
    }
    NSArray<UIViewController *> *viewControllers = [super popToRootViewControllerAnimated:animated];
    // self.viewControllers has two items here on iOS14
    return viewControllers;
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    self.pushing = NO;
}
- (BOOL)prefersStatusBarHidden{
    return [[self visibleViewController] prefersStatusBarHidden];
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
- (BOOL)shouldAutorotate{
    return [[self visibleViewController] shouldAutorotate];
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [[self visibleViewController] supportedInterfaceOrientations];
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [[self visibleViewController] preferredInterfaceOrientationForPresentation];
}
- (void)dealloc{
    ZWWLog(@"%@ 释放", NSStringFromClass([self class]));
}

@end
