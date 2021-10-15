//
//  项目结构说明.h
//  AppProgect
//
//  Created by step_zhang on 2021/9/7.
//

#ifndef _______h
#define _______h


#endif /* _______h */
/**=================================项目结构 ============================*/
/**
 2021-09-07
 1.pod 自动管理三方工具
 2.runtime,kvc 缓存, RSA + AES 服务端和客户端双向加密
 项目整体架构采用  BaseViewControler/BaseView/BaseCell/BaseViewModel/BaseModel/BaseNavGitagionControler + RAC + AfnetWorking + Tools  (MVVM模式)
 
 BaseViewControler,整体界面主题背景,公用方法,(返回按钮,图标,侧滑返回,网络权限判断,无网提示...)
 BaseView/BaseCell  自定义View?cell 相关
 BaseViewModel   将VC 内部 网络/数据处理  相关代码 抽离出来,
 BaseModel  模型基类, 处理后端返回数据转换成本地对象 特殊字符串转义等相关处理
 BaseNavGitagionControler   自定义导航控制器  统一设置自定义导航
 RAC 代替苹果原生的 代理,通知,block,实现类似于微信登录过程中,在没有输入账号情况下,按钮处于不可点击状态 等
 AfnetWorking  网络请求的二次封装, 增加网络数据本地缓存
 Tools  处理数据 加密,调用苹果设备交互公共方法,本地数据缓存,读取,登录状态的判断,常用类别,三方工具的封装

 */
/**=================================加密具体描述============================*/
/**
 1.非对称解密 = 校验格式是否正确 == 拿出来公钥 ====
 
 
 iOS端生成的公钥和私钥定义为iOSPublicKey、iOSPrivateKey，java端生成的公钥私钥定义为javaPublicKey、javaPrivateKey。将iOSPublicKey给java，让它用iOSPublicKey加密数据传给iOS端，iOS端用iOSPrivateKey解密；java端将javaPublicKey给iOS端，iOS端用javaPublicKey加密数据后上传给java，java端利用javaPrivateKey去解密，这样就实现了数据传输过程中的加密与解密，当然，也不一定非要按照我上面的步骤来，具体情况要和后台商量如何加密。
 
 
 #import "AESCipher.h"
 #import "RSA.h"
 
 传递数据的时候
 NSString *userData = [self convertToJsonData:parma];//用户信息字符串
 NSString *key = [self randomString:16];//key客户端生成的随机key  16位
 NSString *aesUserdata = [self AESString:userData WithKey:key];  //随机字符串aes加密
 NSString *aesuuid = [self RSAString:key WithKey:nil];//对随机字符串加密
 //userData 是客户端生成随机序列key对用户注册信息的加密
 
 
 //json转字符串
 -(NSString *)convertToJsonData:(NSMutableDictionary *)parma{
     NSError *error;
     NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parma options:NSJSONWritingPrettyPrinted error:&error];
     NSString *jsonString;
     if (!jsonData) {
         NSLog(@"%@",error);
     }else{
         jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
     }
     NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
     NSRange range = {0,jsonString.length};
     //去掉字符串中的空格
     [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
     NSRange range2 = {0,mutStr.length};
     //去掉字符串中的换行符
     [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
     return mutStr;
 }
 //16位随机字符串
 -(NSString *)randomString:(NSInteger )num{
     char data[num];
     for (int x=0;x<num;data[x++] = (char)('A' + (arc4random_uniform(26))));
     return [[NSString alloc] initWithBytes:data length:num encoding:NSUTF8StringEncoding];
 }
 ///AES 加密
 -(NSString *)AESString:(NSString *)str WithKey:(NSString *)key{
     
     if (key.length ==16) {
         NSString *encodeBase64 = aesEncryptString(str, key);
         return encodeBase64;
     }else{
         [YJProgressHUD showError:@"16位随机字符串生成失败"];
         return nil;
     }
 }
 ///RSA加密AES的key
 -(NSString *)RSAString:(NSString *)str WithKey:(NSString *)key{
     NSString *publicKey = [ZWSaveTool objectForKey:@"publicKey"];//创建section的时候,存储在本地的服务器的公钥
     if (publicKey) {
         return [RSA encryptString:str publicKey:publicKey];
     }else{
         [YJProgressHUD showError:@"publicKey没有获取到"];
         return nil;
     }
 }
 ///RSA解密 RSA公钥解密服务端传过来的AES加密的key
 -(NSString *)RSAJieMi:(NSString *)str{
     NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAMbOnSeeU92uCgnDi5/npJUzsWr2DpmFP83P6ynAYy2qWoos+4E5ppkj9Q1ThrVmAaBTx4nJaxvLGkzWgl6isl4rxNWnx7yFQ3AdLOlmGydqS29qCAkW8RnGJ2YxRySG9l7n0bgv7Qt7zqnHPNv4ndM70i6bfxyIB7mMgolhd5dDAgMBAAECgYEAnLLuG/Qnlms/bkK7IuaqSw/bn7sh9s+YYtinOtlxUuUbSB38fva54ar90+sqGoC0d3KRrIEd82I68KWDTKRggYR7Hvh89mGO0LIzhtn4lMT//AV3Pqi7a2ZWUN6JDns+O6n73neLQdlhBbugE/4X78+JUP5GIyqCAyWGY/kDRoECQQD11Tn+dJ1DTTemwWi36y1LXJezoqn9D3YA6jcnw4bwTQdliIL5ZKkZUFKJt2sW8ebE6Wlw8UJuFzU5F/ZuQCfrAkEAzwd/foa1VBglqjetz5zQYne9AMwJWFChbC7+fD4hHZidwxxnllnK1NIooda4DohKoOPFpN58kjPZVMG14caQCQJAb7TYiXvMCk0IQMoaH5jKGDiW5pW/0LI52OiU74i1xHP8LHL/sPvAqzQIjXO/QcniJxA5TY0TtprtIGh3HlogyQJAd5+xf35+z/ST7uL1P30wu3TMdOVwkOMmIsiUq12K7Pr+TXrgL/P6SzaT28+h0mPWG1kBHt6fxCrJbTvwyGBfYQJAUEFNi5mTy9sXcA+MjBb0f23XhcBHtfMWORIDwUxH3cw2/7sGydCBMFyOlxngxACLF9kcqqXIgT7bKt2T9qQJmA==";
     if (privateKey) {
         NSString *uuid = [RSA decryptString:str privateKey:privateKey];
         if (uuid) {
              return uuid;
         }else{
             [YJProgressHUD showError:@"RSA解密出错"];
             return nil;
         }
     }else{
         [YJProgressHUD showError:@"publicKey没有获取到"];
         return nil;
     }
 }
 ///AES解密
 -(NSString *)AESJieMi:(NSString *)str WithKey:(NSString *)key{
     ZWWLog(@"str=%@,key=%@",str,key)
     return  aesDecryptString(str, key);
 }
 */


/**=================================项目可能使用的三方库============================*/
/**
 # Uncomment the next line to define a global platform for your project
 #添加源方式，任选一，推荐使用清华镜像源
 ##新版CocoaPods支持CDN数据源，拿到的三方框架是最新
 #####1.没有私有specs，使用
 source 'https://cdn.cocoapods.org/'
 #####2.有私有specs，使用
 source 'https://github.com/artsy/Specs.git'
 source 'https://cdn.cocoapods.org/'

 ##旧版CocoaPods不支持CDN，可能拿到的三方框架不是最新的
 source 'https://github.com/CocoaPods/Specs.git'

 ##推荐使用清华大学镜像源
 source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'
 
 ##忽略.cocoapods中多个specs源引起的警告问题
 install! 'cocoapods', :warn_for_unused_master_specs_repo => false

 platform :ios, '9.0'
 target 'PodTest' do
   # Comment the next line if you don't want to use dynamic frameworks
   #use_frameworks!

   # Pods for PodTest
   pod 'TKBaseKit', '~> 2.0' #通用基础库，使用时最好指定某个版本
 ## TKBaseKit中包含
   pod 'Masonry'
   pod 'YYModel'
   pod 'MBProgressHUD'
   pod 'GTMBase64'           , '~> 1.0.1'
   pod 'MJRefresh'           , '~> 3.4'
   pod 'AFNetworking'        , '~> 4.0'
 ## TKBaseKit中包含

   pod 'TKPermissionKit'     #权限管理
   pod 'TKCrashNilSafe'      # iOS防奔溃处理！
   pod 'TKKeychain'          #钥匙串简单的封装，实现增，删，该，查。以及模拟获取设备UDID
   pod 'TKAnimationKit'      #动画-Demo
   pod 'TKUIKit'             #一些常用的UI控件与工具类集成
 
 
   pod 'MBProgressHUD'
   pod 'SDWebImage'
   pod 'SDWebImageFLPlugin' #gif
   pod 'FSPagerView'  #很强大的轮播，幻灯片库，支持的样式很多，推荐使用
   pod 'SDCycleScrollView'    #轮播图
   pod 'iCarousel'    #高度可定制的3D轮播图
   pod 'IQKeyboardManager'
   
   pod 'JXCategoryView' #分段选择器
   pod 'JXPagingView/Pager' #联动
   
   pod 'PYSearch'
   pod 'SocketRocket'
   pod 'YYModel'

   pod 'Texture'         #优秀的异步绘制库(原AsyncDisplayKit)
   pod 'YYText'          #支持HTML，富文本显示
   pod 'DTCoreText'      #支持HTML，富文本显示
   pod 'DTRichTextEditor'      #富文本编辑器
 
 
 #优秀动画库
 pod 'lottie-ios'


   pod 'AliyunPlayer_iOS', '~> 3.4.10'
   pod 'AliyunOSSiOS' #阿里云对象存储 OSS

   #数据库
   pod 'WCDB'    #微信开源数据库，推荐使用
   pod 'FMDB'
   pod 'Realm'   （也有Swift版）
   #说明：
         1.WCDB和FMDB都是基于Sqlite；
         2.WCDB，Realm支持ORM，FMDB不支持ORM。
         3.WCDB与FMDB都有基于SQLCipher的加密功能。
         4.WCDB，Realm都有Swift版本
         5.推荐等级：WCDB > FMDB > Realm
 
 #照片选择器
   pod 'TZImagePickerController'       #照片选择器
   pod 'TZImagePreviewController'      #对TZImagePickerController库的增强，支持用UIImage、NSURL预览照片和用NSURL预览视频。
   pod 'YBImageBrowser'                #图片浏览器-注意依耐
   pod 'YBImageBrowser/Video'          #视频功能需添加
   pod "PYPhotoBrowser"                #图片浏览器-可用于社区型APP-注意依耐
   pod 'MWPhotoBrowser'                #
   pod 'RSKImageCropViewController'    #相册剪裁

   pod 'CHTCollectionViewWaterfallLayout'    #瀑布流库
   pod 'LXMWaterfallLayout'    #瀑布流库 ,swift
   pod 'JTCalendar'    #日历控件
   pod 'FSCalendar'
   pod 'TQGestureLockView' #手势密码
   pod 'QRCodeReaderViewController' #二维码 --使用lib中修改过的

   pod 'NSDictionary-NilSafe'    #防止NSDictionary nil 崩溃
   pod 'AvoidCrash'              #防止APP崩溃
   #pod 'NSObjectSafe'

   #支付
   pod 'AlipaySDK-iOS'       #支付宝支付
   pod 'WechatOpenSDK'       #微信支付

   # pod 'JPush'             #极光推送
   pod 'Ono'         #html解析
   
   pod 'SVGKit'      #SVG图片加载

   pod 'ZYNetworkAccessibity'    #iOS网络权限的监控和判断
   
   pod 'M13ProgressSuite'  #进度条
   
   pod 'LBXScan'  #二维码-可根据需求添加库
   
   #  Chart
   #YYStock  #k线图（股票）--需要手动添加
   pod 'AAChartKit'
   pod 'PNChart'

  #
   pod 'FXBlurView'    #模糊处理
 
 #
   SwiftScan    #二维码/条形码扫描、生成，仿微信、支付宝
   StarRate     #星星评分控件，支持自定义数量、拖拽、间隔、设置最小星星数等操作
   JPCrop       #高仿小红书App裁剪功能的轻量级工具。
   pod 'MCTabBarController'       #
   pod 'MCTabBarControllerSwift'  #快速定制TabBar中间按钮
 
 
 # https://github.com/ChenYilong/CYLSearchViewController
 CYLSearchViewController  ##给一张或多张图片，让图片动起来
 pod 'DBSphereTagCloud'   #3D效果,  自动旋转效果,  惯性滚动效果
 pod 'HHTransition'       #主流转场动画，无侵入，API简单易用
 pod 'WXSTransition'      #🍎 界面转场动画集
 BabyPigAnimation         #基本动画、位移动画、缩放动画、旋转动画、组动画、关键帧动画、贝塞尔曲线、进度条动画、复杂动画、OC动画、aniamtion、basicanimation等。
 IOSAnimationDemo         #IOS动画总结
 MLMProgressCollection          #进度，刻度，水波纹，统计
 
 */
