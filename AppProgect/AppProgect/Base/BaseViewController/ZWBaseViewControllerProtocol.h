//
//  ZWBaseViewControllerProtocol.h
//  NBJKCardHome
//
//  Created by step_zhang on 2020/11/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ZWBaseViewModelProtocol;
@protocol ZWBaseViewControllerProtocol <NSObject>
//绑定modelview
- (instancetype)initWithViewModel:(id <ZWBaseViewModelProtocol>)viewModel;
- (void)zw_bindViewModel;
- (void)zw_addSubviews;
- (void)zw_layoutNavigation;
- (void)zw_getNewData;
@end

NS_ASSUME_NONNULL_END
