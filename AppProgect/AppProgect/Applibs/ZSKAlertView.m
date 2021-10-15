//
//  ZSKAlertView.m
//  NorthBayProject
//
//  Created by akun on 2020/5/22.
//

#import "ZSKAlertView.h"
#import <Masonry/Masonry.h>

// 16进制数
#define Color_RGB_HEX(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define Color_999999   Color_RGB_HEX(0x999999)
#define Color_000000   Color_RGB_HEX(0x000000)
#define Color_ffffff   Color_RGB_HEX(0xffffff)
#define ThemeFont(size)     [UIFont systemFontOfSize:size]
#define FontContent       ThemeFont(14)
#define FontTitle         ThemeFont(18)
#define ColorTheme         Color_RGB_HEX(0x113885)
#define FontBtnTitle      ThemeFont(16)

@interface ZSKAlertView ()

//
@property (nonatomic, strong) UILabel * titleLb;
//
@property (nonatomic, strong) UILabel * messageLb;
//
@property (nonatomic, strong) UIView * contentView;
//
@property (nonatomic, strong) UIButton * cancleBtn;
//
@property (nonatomic, strong) UIButton * sureBtn;
@property (nonatomic, strong) UIView * toplineView;
@property (nonatomic, strong) UIView * lineView;
//
@property (nonatomic, copy) ZSKAlertViewBlock block;

@end

@implementation ZSKAlertView
+ (void)showWithTitle:(NSString *)title message:(NSString *)message btnTitle:(NSString *)btnTitle completeBlock:(ZSKAlertViewBlock)block{
    [self showWithTitle:title message:message sureBtnTitle:btnTitle cancleBtnTitle:@"" completeBlock:block];
}
+ (void)showWithTitle:(NSString *)title message:(NSString *)message sureBtnTitle:(NSString *)sureTitle cancleBtnTitle:(NSString *)cancleTitle completeBlock:(ZSKAlertViewBlock)block{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    ZSKAlertView * alerView = [[ZSKAlertView alloc] init];
    alerView.block = block;
    [window addSubview:alerView];
    alerView.titleLb.text = title;
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:message];
    [attStr addAttributes:@{NSForegroundColorAttributeName:Color_999999} range:NSMakeRange(0, message.length)];
    [attStr addAttributes:@{NSFontAttributeName:FontContent} range:NSMakeRange(0, message.length)];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:1.5];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [attStr addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, message.length)];
    [attStr addAttributes:@{NSKernAttributeName:@(1.2)} range:NSMakeRange(0, message.length)];
    
    alerView.messageLb.attributedText = attStr;
    [alerView.cancleBtn setTitle:cancleTitle forState:UIControlStateNormal];
    [alerView.sureBtn setTitle:sureTitle forState:UIControlStateNormal];
    
    [alerView.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(alerView).offset(50);
        make.right.equalTo(alerView).offset(-50);
        make.centerY.equalTo(alerView).offset(-20);
    }];
    
    [alerView.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(alerView.contentView);
        make.top.equalTo(alerView.contentView).offset(5);
        make.height.mas_equalTo(40);
    }];
    
    [alerView.messageLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(alerView.contentView).offset(15);
        make.right.equalTo(alerView.contentView).offset(-15);
        make.top.equalTo(alerView.titleLb.mas_bottom).offset(5);
        make.height.mas_greaterThanOrEqualTo(35);
    }];
    
    [alerView.toplineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(alerView.contentView);
        make.right.equalTo(alerView.contentView);
        make.top.equalTo(alerView.messageLb.mas_bottom).offset(15);
        make.height.mas_greaterThanOrEqualTo(0.5);
    }];
    
    if ([@"" isEqualToString:cancleTitle]) {
        alerView.cancleBtn.hidden = YES;
        [alerView.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(alerView.toplineView.mas_bottom);
            make.left.right.equalTo(alerView.contentView);
            make.bottom.equalTo(alerView.contentView).offset(-5);
            make.height.mas_equalTo(44);
        }];
    }else{
        [alerView.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(alerView.toplineView.mas_bottom);
            make.left.equalTo(alerView.contentView);
            make.bottom.equalTo(alerView.contentView).offset(-5);
            make.height.mas_equalTo(44);
        }];
        
        [alerView.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(alerView.toplineView.mas_bottom);
            make.left.equalTo(alerView.cancleBtn.mas_right);
            make.bottom.equalTo(alerView.contentView);
            make.size.mas_equalTo(CGSizeMake(0.5, 44));
        }];
        
        [alerView.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(alerView.toplineView.mas_bottom);
            make.left.equalTo(alerView.lineView.mas_right);
            make.right.equalTo(alerView.contentView);
            make.width.equalTo(alerView.cancleBtn);
            make.bottom.equalTo(alerView.contentView).offset(-5);
            make.height.mas_equalTo(44);
        }];
    }
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.titleLb];
        [self.contentView addSubview:self.messageLb];
        [self.contentView addSubview:self.toplineView];
        [self.contentView addSubview:self.cancleBtn];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.sureBtn];
        self.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.5];
        //self.backgroundColor = [UIColor redColor];
//        self.backgroundColor = [UIColor darkGrayColor];//背景
//        self.alpha = 0.8;
    }
    return self;
}
#pragma mark - 懒加载
- (UIView *)contentView{
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = Color_ffffff;
        _contentView.layer.cornerRadius = 5.0;
        _contentView.clipsToBounds = YES;
    }
    return _contentView;
}

- (UILabel *)titleLb{
    if (_titleLb == nil) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.textColor = Color_000000;
        _titleLb.font = FontTitle;
        _titleLb.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLb;
}

- (UILabel *)messageLb{
    if (_messageLb == nil) {
        _messageLb = [[UILabel alloc] init];
        _messageLb.numberOfLines = 0;
        _messageLb.textAlignment = NSTextAlignmentCenter;
    }
    return _messageLb;
}
- (UIButton *)cancleBtn{
    if (_cancleBtn == nil) {
        _cancleBtn = [[UIButton alloc] init];
        [_cancleBtn setTitleColor:Color_999999 forState:UIControlStateNormal];
        _cancleBtn.titleLabel.font = FontBtnTitle;
        [_cancleBtn addTarget:self action:@selector(clickedCancleBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBtn;
}
- (UIButton *)sureBtn{
    if (_sureBtn == nil) {
        _sureBtn = [[UIButton alloc] init];
        [_sureBtn setTitleColor:Color_999999 forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = FontBtnTitle;
        [_sureBtn addTarget:self action:@selector(clickedSureBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
- (void)clickedCancleBtn{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            if (self.block) {
                self.block(0);
            }
        }
    }];
}
- (void)clickedSureBtn{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            if (self.block) {
                self.block(1);
            }
        }
    }];
}
-(UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = ZWColorline;
    }
    return _lineView;;
}
-(UIView *)toplineView{
    if (_toplineView == nil) {
        _toplineView = [[UIView alloc]init];
        _toplineView.backgroundColor = ZWColorline;
    }
    return _toplineView;;
}
@end
