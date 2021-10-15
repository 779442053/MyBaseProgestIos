//
//  HTLoginViewModel.m
//  AppProgect
//
//  Created by step_zhang on 2021/9/8.
//

#import "HTLoginViewModel.h"

@implementation HTLoginViewModel
-(void)zw_initialize{
    @weakify(self);
   RACSignal *phoneSignal      = [RACObserve(self, phoneNum) map:^NSString *(NSString * mobilePhone) {
       @strongify(self);
       return @([mobilePhone length] == 11);
   }];
   RACSignal *pswSignal      = [RACObserve(self, pswNum) map:^NSString *(NSString * pswString) {
       @strongify(self);
       return @([pswString length] >= 2);
   }];
   self.canLoginSignal         = [RACSignal combineLatest:@[phoneSignal,pswSignal]
                                                   reduce:^id(id phone,id psw){
                                                       return @([psw boolValue] && [phone boolValue]);
                                                   }];
    
    self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            [YJProgressHUD showSuccess:@"登陆成功"];
            [subscriber sendNext:@{@"code":@"0"}];
            return [RACDisposable disposableWithBlock:^{
                ZWWLog(@"登录信号消失")
            }];
        }];
    }];
}
@end
