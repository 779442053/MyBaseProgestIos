//
//  HTLoginViewModel.h
//  AppProgect
//
//  Created by step_zhang on 2021/9/8.
//

#import "ZWBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTLoginViewModel : ZWBaseViewModel
@property(nonatomic,readwrite,copy)NSString     *phoneNum;

@property(nonatomic,readwrite,copy)NSString     *pswNum;
@property (nonatomic, strong)RACSignal    *phoneSignal;

@property (nonatomic, strong)RACSignal    *pswSignal;

@property (nonatomic, strong)RACSignal    *canLoginSignal;
@property (nonatomic, strong)RACCommand   *loginCommand;
@end

NS_ASSUME_NONNULL_END
