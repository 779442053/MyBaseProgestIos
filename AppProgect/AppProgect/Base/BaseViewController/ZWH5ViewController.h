//
//  ZWH5ViewController.h
//  NBJKCardHome
//
//  Created by step_zhang on 2020/11/24.
//

#import "ZWBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^H5VCWillDismissBlock)(void);
@interface ZWH5ViewController : ZWBaseViewController
//网页链接
@property(nonatomic,copy)NSString *urlStr;
//html内容
@property(nonatomic,copy)NSString *content;

//
@property (nonatomic, copy) H5VCWillDismissBlock block;
@end

NS_ASSUME_NONNULL_END
