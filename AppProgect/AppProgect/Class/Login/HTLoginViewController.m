//
//  HTLoginViewController.m
//  AppProgect
//
//  Created by step_zhang on 2021/9/8.
//

#import "HTLoginViewController.h"
#import "HTLoginViewModel.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "ZWTabBarController.h"
@interface HTLoginViewController ()
@property(nonatomic,strong)UITextField *phoneTex;
@property(nonatomic,strong)UIButton *loginBtn;
@property(nonatomic,strong)UITextField *codeTex;
@property(nonatomic,strong)HTLoginViewModel *ViewModel;
@property (nonatomic, strong) Reachability * reach;
@end

@implementation HTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationBgView setHidden:YES];
    [self.navigationView setHidden:YES];
    self.reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [self.reach startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kNetworkReachabilityChangedNotification) name:@"kNetworkReachabilityChangedNotification" object:nil];
}
-(void)zw_bindViewModel{
    @weakify(self);
    [[RACSignal merge:@[self.phoneTex.rac_textSignal, RACObserve(self.phoneTex, text)]] subscribeNext:^(NSString* text){
        @strongify(self);
        self.ViewModel.phoneNum = text;
    }];
    [[RACSignal merge:@[self.codeTex.rac_textSignal, RACObserve(self.codeTex, text)]] subscribeNext:^(NSString* text){
        @strongify(self);
        self.ViewModel.pswNum = text;
    }];
    RAC(self.loginBtn, enabled)              = self.ViewModel.canLoginSignal;
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [[self.ViewModel.loginCommand execute:self.loginBtn] subscribeNext:^(NSDictionary* x) {
            if ([x[@"code"] intValue] == 0) {
                //成功
                [self setMainView];
            }else{
                //失败

            }
        }];
    }];
}
- (void)setMainView{
    AppDelegate *appDelegate =  [AppDelegate shareAppDelegate];
    ZWTabBarController *kinTabBarController = [[ZWTabBarController alloc] init];
    ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:kinTabBarController];
    appDelegate.window.rootViewController = nav;
    appDelegate.tabBarController = kinTabBarController;
}
-(void)zw_addSubviews{
    UIImageView *logoimage = [[UIImageView alloc]init];
    [self.view addSubview:logoimage];
    logoimage.userInteractionEnabled = YES;
    logoimage.image = [UIImage imageNamed:@"loginbg"];
    ZW(weakSelf)
    [logoimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
        make.top.mas_offset(0);
        make.left.mas_equalTo(weakSelf.view.mas_left);
        make.right.mas_equalTo(weakSelf.view.mas_right);
    }];
    UIImageView *logotext = [[UIImageView alloc]init];
    [self.view addSubview:logotext];
    logotext.image = [UIImage imageNamed:@"logintext"];
    [logotext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.top.mas_offset(130);
    }];
    
    UIView *phoneView = [[UIView alloc] init];
    phoneView.backgroundColor = [UIColor whiteColor];
    [logoimage addSubview:phoneView];
    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(logoimage.mas_left).with.mas_offset(30);
        make.right.mas_equalTo(logoimage.mas_right).with.mas_offset(-30);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(logoimage.mas_bottom).with.mas_offset(-310);
    }];
    phoneView.layer.cornerRadius = 5.0;
    phoneView.layer.masksToBounds = YES;
    
    self.phoneTex = [[UITextField alloc]init];
    [phoneView addSubview:self.phoneTex];
    self.phoneTex.keyboardType        = UIKeyboardTypeNumberPad;
    self.phoneTex.placeholder = @"输入手机号码";
    self.phoneTex.font = [UIFont zwwNormalFont:12];
    self.phoneTex.layer.cornerRadius = 5.0;
    self.phoneTex.backgroundColor = [UIColor whiteColor];
    //[self.phoneTex setValue:[UIColor colorWithHexString:@"#FD4772"] forKeyPath:@"_placeholderLabel.textColor"];
    self.phoneTex.textColor = [UIColor colorWithHexString:@"#333333"];
    //点击获取验证码之后,颜色改变
    [self.phoneTex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneView.mas_left).with.mas_offset(10);
        make.right.mas_equalTo(phoneView.mas_right).with.mas_offset(-10);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(phoneView.mas_bottom);
    }];

    UIView *codeView = [[UIView alloc] init];
    codeView.backgroundColor = [UIColor whiteColor];
    [logoimage addSubview:codeView];
    [codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(logoimage.mas_left).with.mas_offset(30);
        make.right.mas_equalTo(logoimage.mas_right).with.mas_offset(-30);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(logoimage.mas_bottom).with.mas_offset(-245);
    }];
    codeView.layer.cornerRadius = 5.0;
    codeView.layer.masksToBounds = YES;
    
    
    
    self.codeTex = [[UITextField alloc]init];
    self.codeTex.placeholder = @"输入密码";
    self.codeTex.backgroundColor = [UIColor whiteColor];
    self.codeTex.layer.cornerRadius = 5.0;
    self.codeTex.secureTextEntry = YES;
    //self.codeTex.keyboardType        = UIKeyboardTypeNumberPad;
    //[self.codeTex setValue:[UIColor colorWithHexString:@"#FD4772"] forKeyPath:@"_placeholderLabel.textColor"];
    [codeView addSubview:self.codeTex];
    self.codeTex.font = [UIFont zwwNormalFont:12];
    self.codeTex.tintColor = [UIColor colorWithHexString:@"#333333"];
    [self.codeTex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(codeView.mas_left).with.mas_offset(10);
        make.right.mas_equalTo(codeView.mas_right).with.mas_offset(-10);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(codeView.mas_bottom);
    }];
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoimage addSubview:_loginBtn];
    [self.loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    [_loginBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#e65674"]] forState:UIControlStateNormal];
    [_loginBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#fbbf41"]] forState:UIControlStateSelected];
    [self.loginBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font= [UIFont zwwNormalFont:20];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(logoimage.mas_bottom).with.mas_offset(-188);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(logoimage.mas_left).with.mas_offset(30);
        make.right.mas_equalTo(logoimage.mas_right).with.mas_offset(-30);
    }];
    self.loginBtn.layer.cornerRadius = 5.0f;
    self.loginBtn.layer.masksToBounds = YES;

    UILabel *protocolLab = [[UILabel alloc]init];
    protocolLab.text = @"忘记密码";
    protocolLab.font = [UIFont zwwNormalFont:12];
    protocolLab.textColor = [UIColor colorWithHexString:@"#FD4772"];
    protocolLab.textAlignment = NSTextAlignmentRight;
    [logoimage addSubview:protocolLab];
    protocolLab.userInteractionEnabled = YES;
    [protocolLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.loginBtn.mas_right);
        make.size.mas_equalTo(CGSizeMake(100, 17));
        make.bottom.mas_equalTo(logoimage.mas_bottom).with.mas_offset(-155);
    }];
    
    UILabel *forgetLab = [[UILabel alloc]init];
    forgetLab.text = @"新用户注册";
    forgetLab.font = [UIFont zwwNormalFont:12];
    forgetLab.textColor = [UIColor colorWithHexString:@"#FD4772"];
    forgetLab.textAlignment = NSTextAlignmentLeft;
    [logoimage addSubview:forgetLab];
    forgetLab.userInteractionEnabled = YES;
    [forgetLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.loginBtn.mas_left);
        make.size.mas_equalTo(CGSizeMake(100, 17));
        make.bottom.mas_equalTo(logoimage.mas_bottom).with.mas_offset(-155);
    }];


    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        [YJProgressHUD showMessage:@"忘记密码"];
    }];
    [protocolLab addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] init];
    [[tap1 rac_gestureSignal] subscribeNext:^(id x) {
        [YJProgressHUD showMessage:@"新用户注册"];
    }];
    [forgetLab addGestureRecognizer:tap1];
}
//网络变化刷新页面
- (void)kNetworkReachabilityChangedNotification {
    //根据self。reach 当前网络状态返回对应参数
    switch (self.reach.currentReachabilityStatus) {
        case NotReachable:
            NSLog(@"无网络连接");
            break;
        case ReachableViaWiFi:
            NSLog(@"Wifi");
            //创建section
//            [[self.viewModel.CreatSectionCommand execute:nil] subscribeNext:^(NSDictionary* x) {
//                if ([x[@"code"] intValue] == 1) {
//                    [YJProgressHUD showError:@"请检查网络连接"];
//                }
//            }];
            break;
        case ReachableViaWWAN:
            NSLog(@"移动流量");
            //创建section
//            [[self.viewModel.CreatSectionCommand execute:nil] subscribeNext:^(NSDictionary* x) {
//                if ([x[@"code"] intValue] == 1) {
//                    [YJProgressHUD showError:@"请检查网络连接"];
//                }
//            }];
            break;
        default:
            NSLog(@"未知网络");
            break;
    }
   
}
-(HTLoginViewModel *)ViewModel{
    if (_ViewModel == nil) {
        _ViewModel = [[HTLoginViewModel alloc]init];
    }
    return _ViewModel;
}
@end
