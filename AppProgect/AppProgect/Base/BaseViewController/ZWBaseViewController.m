//
//  ZWBaseViewController.m
//  NBJKCardHome
//
//  Created by step_zhang on 2020/11/24.
//

#import "ZWBaseViewController.h"

@interface ZWBaseViewController ()

@end

@implementation ZWBaseViewController
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    ZWBaseViewController*viewController = [super allocWithZone:zone];
    ZWWWeakSelf(viewController)
    [[viewController rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
        ZWWStrongSelf(viewController);
        [viewController zw_addSubviews];
        [viewController zw_bindViewModel];
    }];
    [[viewController rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
        ZWWStrongSelf(viewController);
        [viewController zw_layoutNavigation];
        [viewController zw_getNewData];
    }];
    return viewController;
}
- (instancetype)initWithViewModel:(id<ZWBaseViewControllerProtocol>)viewModel {
    self = [super init];
    if (self) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        self.automaticallyAdjustsScrollViewInsets = NO;
#pragma clang diagnostic pop
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.statusBarStyle = UIStatusBarStyleLightContent;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    //防止顶部出现未知空白
    if (@available(iOS 11.0, *)) {
        [UITableView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [UICollectionView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else {
        if([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)])
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            self.automaticallyAdjustsScrollViewInsets=NO;
#pragma clang diagnostic pop
        }
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            //通过设置此属性，你可以指定view的边（上、下、左、右）延伸到整个屏幕。
        }
    }
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setNavView];
}
- (void)viewDidLayoutSubviews
{
    [self.view bringSubviewToFront:_navigationView];//始终放在最上层
}
- (void)setNavView
{
    _navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, ZWStatusAndNavHeight)];
    _navigationView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];//#F5F5F5
    [self.view addSubview:_navigationView];
    _navigationBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, ZWStatusAndNavHeight)];
    _navigationBgView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];//#F5F5F5
    [_navigationView addSubview:_navigationBgView];
}
- (void)setTitle:(NSString *)title
{
    [_navigationView addSubview:self.titleLabel];
    _titleLabel.text = title;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_navigationView.mj_w/2 - 100, _navigationView.mj_h - 30, 200, 20)];
        _titleLabel.font = [UIFont zwwNormalFont:17];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#1B247A"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (void)showLeftBackButton
{
    _leftButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _leftButton.frame = CGRectMake(15, ZWStatusBarHeight + 5, 45, 35);
    [_leftButton setImage:[UIImage imageNamed:@"App_back"] forState:(UIControlStateNormal)];
    [_leftButton addTarget:self action:@selector(backAction) forControlEvents:(UIControlEventTouchUpInside)];
    [_navigationView addSubview:_leftButton];
}
- (void)backAction
{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion{
    viewControllerToPresent.modalPresentationStyle = 0;
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}
#if defined(__IPHONE_13_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0
- (UIUserInterfaceStyle)overrideUserInterfaceStyle{
    return UIUserInterfaceStyleLight;
}
#endif
//MARK: - 状态栏颜色
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (BOOL)isIphoneX{
    if (@available(iOS 11.0, *)) {
        CGFloat a =  [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom;
        if (a>0) {
            return YES;
        }else{
            return NO;
        }
    }
    return NO;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
- (BOOL)prefersHomeIndicatorAutoHidden {
    return self.isHidenHomeLine;
}
- (BOOL)prefersStatusBarHidden {
    return self.statusBarHidden;
}
#pragma mark - RAC
/**
 *  添加控件
 */
- (void)zw_addSubviews {}
/**
 *  绑定
 */
- (void)zw_bindViewModel {}
/**
 *  设置navation
 */
- (void)zw_layoutNavigation {}
/**
 *  初次获取数据
 */
- (void)zw_getNewData {}
/**
 
 未实现 此方法情况下,容易造成内存泄漏.
 
 2021-01-19  在基类里面,实现 dealloc 方法,可以监听工程所有继承于当前基类的 类是否释放了自己的内存
 */
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    ZWWLog(@"%@--释放了释放了释放了释放了",NSStringFromClass([self class]));
}

@end
