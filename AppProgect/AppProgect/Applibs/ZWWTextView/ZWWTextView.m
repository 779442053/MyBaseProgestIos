//
//  ZWWTextView.m
//  MyBaseProgect
//
//  Created by 张威威 on 2018/4/27.
//  Copyright © 2018年 张威威. All rights reserved.
//

#import "ZWWTextView.h"
#import "ZWMessage.h"
@interface ZWWTextView ()<UITextViewDelegate>
@property(nonatomic,strong)UILabel *zw_label;
@end
@implementation ZWWTextView
+(instancetype)textView
{
    return [[self alloc]init];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initView];
        self.delegate = self;
    }
    return self;
}

- (void)initView
{
    self.zw_label            = [[UILabel alloc]initWithFrame:CGRectMake(kRealValueWidth(10), kRealValueHeight(0), kRealValue(300), kRealValue(30))];
    self.zw_label.textColor  = [UIColor colorWithHexString:@"C3C3C5"];
    self.zw_label.font       = self.font;
    self.zw_label.text       = @"placeholder";
    [self addSubview:self.zw_label];
    
    self.clearButton.frame = CGRectMake(kRealValueWidth(KScreenWidth - 40), kRealValueHeight(15), kRealValue(30), kRealValue(30));
    [self addSubview:self.clearButton];
    
}
- (void)setText:(NSString *)text
{
    [super setText:text];
    if (self.text.length == 0)
    {
        self.zw_label.hidden = NO;
    }
    else
    {
        self.zw_label.hidden = YES;
    }
}
- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.zw_label.font = font;
    self.zw_label.frame = CGRectMake(kRealValue(10),kRealValue(0),kRealValue(300),kRealValue(font.pointSize + 17));
}
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.zw_label.text = placeholder;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (text.length == 0 && textView.text.length == 1)
    {
        self.zw_label.hidden = NO;
        return YES;
    }
    if (text.length == 0 && textView.text.length == 0)
    {
        self.zw_label.hidden = NO;
        return YES;
    }
    self.zw_label.hidden = YES;
    if ([[[UITextInputMode currentInputMode]primaryLanguage] isEqualToString:@"emoji"]) {
        //[YJProgressHUD showMessage:@"暂不支持输入表情符号"];
        [ZWMessage error:@"暂时只支持输入中文，英文和数字" title:@"温馨提示"];
        return NO;
    }
    //禁止输入emoji表情
    if ([text isContainEmoji]) {
       // [YJProgressHUD showMessage:@"暂不支持输入表情符号"];
        [ZWMessage error:@"暂时只支持输入中文，英文和数字" title:@"温馨提示"];
        return NO;
    }
    return YES;
}
- (UIButton *)clearButton {
    if (!_clearButton) {
        _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearButton setBackgroundImage:[UIImage imageNamed:@"clearImage"] forState:UIControlStateNormal];
        _clearButton.backgroundColor = [UIColor clearColor];
        _clearButton.hidden = YES;
        [_clearButton addTarget:self action:@selector(clearAllText) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearButton;
}
- (void)clearAllText {
    self.text = @"";
}


@end
