//
//  ZWH5ViewController.m
//  NBJKCardHome
//
//  Created by step_zhang on 2020/11/24.
//

#import "ZWH5ViewController.h"
#import <WebKit/WebKit.h>
static void *WKWebBrowserContext = &WKWebBrowserContext;
@interface ZWH5ViewController ()<WKNavigationDelegate>
@property(nonatomic,strong)WKWebView * contentWebView;

@property(nonatomic,strong)UIProgressView * progressView;
@end

@implementation ZWH5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.contentWebView];
    [self.view addSubview:self.progressView];
    if (@available(iOS 11.0, *)) {
        self.contentWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self layoutConstraints];
    [self loadData];
}
-(void)zw_addSubviews{
    if (self.content && [self.content isEqualToString:@"实名认证"]) {
//        self.navigationBgView.hidden = YES;
//        self.navigationView.hidden = YES;
        [self setTitle:@"实名认证"];
    }else{
        [self setTitle:self.content];
    }
    
    [self showLeftBackButton];
}
- (void)layoutConstraints {
    if (self.content && [self.content isEqualToString:@"实名认证"]) {
        [self.contentWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(ZWStatusBarHeight);
            make.right.left.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
    }else{
        [self.contentWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(ZWStatusAndNavHeight);
            make.right.left.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
    }
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).with.mas_offset(ZWStatusAndNavHeight);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(2);
    }];
}
- (void)loadData {
    if (self.urlStr.length) {
        NSURL* url=[NSURL URLWithString:self.urlStr relativeToURL:[NSURL URLWithString:@"http://"]];
        NSURLRequest *request =[NSURLRequest requestWithURL:url];
        [self.contentWebView loadRequest:request];
        return;
    }
    if (self.content.length) {
        [self.contentWebView loadHTMLString:self.content baseURL:nil];
        return;
    }
}
#pragma mark - WKNavigationDelegate
//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    //开始加载的时候，让加载进度条显示
    self.progressView.hidden = NO;
}
//网页加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    // 获取加载网页的标题
    ZWWLog(@"获取加载网页的标题 = %@",self.contentWebView.title)
//    self.title = self.contentWebView.title;
}
//内容返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
}

//服务器请求跳转的时候调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    ZWWLog(@"服务器请求跳转的时候调用 = %@",navigation)
}
// 内容加载失败时候调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    ZWWLog(@"跳转网页或者是拨打电话等相关网页内的操作")
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    NSURL *URL = navigationAction.request.URL;
    [self dealSomeThing:URL];
    decisionHandler(WKNavigationActionPolicyAllow);
}
/**
 拨打电话
 2021-01-19  当系统版本大于iOS9 时候.应用内唤醒拨号功能,无法打开和打开吃顿 bug修复
 */
- (void)dealSomeThing:(NSURL *)url{
    NSString *scheme = [url scheme];
    NSString *resourceSpecifier = [url resourceSpecifier];
    if ([scheme isEqualToString:@"tel"]) {
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", resourceSpecifier];
        /// 防止iOS 10及其之后，拨打电话系统弹出框延迟出现
        //dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSURL *url = [NSURL URLWithString:callPhone];
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
//                [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:^(BOOL success){
//
//                }];
            } else {
                // Fallback on earlier versions
                if ([[UIApplication sharedApplication]canOpenURL:url]) {
                    [[UIApplication sharedApplication]openURL:url];
                }
            }
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        //});
    }
}
//进度条
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
}
/**
 弱网情况下,用户体验差
 
 2021-01-19 采用KVO 监听网页加载进度,在加载完毕的情况下,隐藏掉 加载网页的进度条.优化用户体验
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.contentWebView) {
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.contentWebView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.contentWebView.estimatedProgress animated:animated];
        
        // Once complete, fade out UIProgressView
        if(self.contentWebView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        if ([keyPath isEqualToString:@"title"]) {
            if (object == self.contentWebView)
            {
                //self.title = self.contentWebView.title;
                ZWWLog(@"加载的网页标题 = %@",self.contentWebView.title)
            }
            else {
                [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
            }
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
}
#pragma mark - getters and setters
- (WKWebView *)contentWebView {
    if (!_contentWebView) {
        _contentWebView = [[WKWebView alloc] init];
        _contentWebView.backgroundColor = [UIColor whiteColor];
        _contentWebView.opaque = YES;
        //适应你设定的尺寸
        [_contentWebView sizeToFit];
        _contentWebView.scrollView.showsVerticalScrollIndicator = NO;
        // 设置代理
        _contentWebView.navigationDelegate = self;
        //kvo 添加进度监控
        [_contentWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:WKWebBrowserContext];
        
        //设置网页的配置文件
        WKWebViewConfiguration * Configuration = [[WKWebViewConfiguration alloc]init];
        // 此处一定要做判断，因为是iOS9之后才有的方法，否则在iOS8下会崩溃
        if (@available(iOS 9.0, *)) {
            //允许视频播放
            Configuration.allowsAirPlayForMediaPlayback = YES;
            
            // 允许在线播放
            Configuration.allowsInlineMediaPlayback = YES;
            //开启手势触摸 默认设置就是NO。在ios8系统中会导致手势问题，程序崩溃
            _contentWebView.allowsBackForwardNavigationGestures = YES;
        }
        // 允许可以与网页交互，选择视图
        Configuration.selectionGranularity = YES;
        // web内容处理池
        Configuration.processPool = [[WKProcessPool alloc] init];
        //自定义配置,一般用于 js调用oc方法(OC拦截URL中的数据做自定义操作)
        WKUserContentController * UserContentController = [[WKUserContentController alloc]init];
        // 是否支持记忆读取
        Configuration.suppressesIncrementalRendering = YES;
        // 允许用户更改网页的设置
        Configuration.userContentController = UserContentController;
    }
    return _contentWebView;
}
- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        [_progressView setTrackTintColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0]];
        _progressView.progressTintColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _progressView;
}
// 记得dealloc
- (void)dealloc {
    [self.contentWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
}


@end
