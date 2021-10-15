//
//  HTHomeViewController.m
//  AppProgect
//
//  Created by step_zhang on 2021/9/8.
//

#import "HTHomeViewController.h"
#import "ZWH5ViewController.h"
@interface HTHomeViewController ()

@end

@implementation HTHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)zw_addSubviews{
    [self setTitle:@"首页"];
    UIImageView *BgImageView = [[UIImageView alloc]init];
    BgImageView.image = [UIImage imageNamed:@"jiami"];
    [self.view addSubview:BgImageView];
    [BgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).with.mas_offset(10);
        make.right.mas_equalTo(self.view.mas_right).with.mas_offset(-10);
        make.top.mas_equalTo(self.view.mas_top).with.mas_offset(ZWStatusAndNavHeight + 10);
        make.height.mas_equalTo(250);
    }];
    
    
    UIButton *degitialBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [degitialBtn setTitle:@"查看详情" forState:UIControlStateNormal];
    [self.view addSubview:degitialBtn];
    [degitialBtn setTitleColor:[UIColor colorWithHexString:@"#fbbf41"] forState:UIControlStateNormal];
    [degitialBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(BgImageView.mas_bottom).with.mas_offset(30);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    
    //RAC
    [[degitialBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        ZWH5ViewController *VC = [[ZWH5ViewController alloc]init];
        VC.content = @"这是一个网页标题";
        VC.urlStr = @"https://blog.csdn.net/Z1591090/article/details/103774282";
        [self.navigationController pushViewController:VC animated:YES];
    }];
}


@end
