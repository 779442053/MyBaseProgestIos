//
//  ZWBaseViewModel.m
//  NBJKCardHome
//
//  Created by step_zhang on 2020/11/24.
//

#import "ZWBaseViewModel.h"

@implementation ZWBaseViewModel
@synthesize request  = _request;
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    ZWBaseViewModel *viewModel = [super allocWithZone:zone];
    
    if (viewModel) {
        
        [viewModel zw_initialize];
    }
    return viewModel;
}
- (instancetype)initWithModel:(id)model {
    
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)zw_initialize {
    
}
- (ZSKNetworking *)request {
    if (!_request) {
        _request = [ZSKNetworking shaerdInstance];
    }
    return _request;
}
@end
