//
//  ZSKNetworking.m
//  AppProgect
//
//  Created by step_zhang on 2021/9/7.
//

#import "ZSKNetworking.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "ZSKCacheManager.h"
#import "ZSKAlertView.h"
#import "ZWDataManager.h"
#import "ZWSaveTool.h"
#import "YJProgressHUD.h"
#import "ZWUserModel.h"
#define ZSK_ERROR [NSError errorWithDomain:@"com.hZSK.ZSKNetworking.ErrorDomain" code:-999 userInfo:@{NSLocalizedDescriptionKey:@"网络出现错误，请检查网络连接"}]

#define ZSK_TIMEOUT 30.f //请求超时时间

static NSMutableArray       * requestTaskPool;  // 请求任务池
static NSDictionary         * headers;          //


@implementation NSURLRequest (decide)

//判断是否是同一个请求（依据是请求url和参数是否相同）
- (BOOL)isTheSameRequest:(NSURLRequest *)request
{
    if ([self.HTTPMethod isEqualToString:request.HTTPMethod])
    {
        if ([self.URL.absoluteString isEqualToString:request.URL.absoluteString])
        {
            if ([self.HTTPMethod isEqualToString:@"GET"] || [self.HTTPBody isEqualToData:request.HTTPBody])
            {
                // 同一个请求还没执行完
                return YES;
            }
        }
    }
    return NO;
}

@end

@interface ZSKNetworking()

@property (nonatomic, strong) AFHTTPSessionManager  * manager;

@end

@implementation ZSKNetworking

+ (instancetype)shaerdInstance
{
    static ZSKNetworking * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance        = [[ZSKNetworking alloc] init];
        requestTaskPool = [NSMutableArray array];
    });
    return instance;
}

#pragma mark - manager
- (AFHTTPSessionManager *)manager{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    if (!_manager)
    {
        AFHTTPSessionManager *manager               = [AFHTTPSessionManager manager];
        //默认解析模式
        manager.requestSerializer                   = [AFJSONRequestSerializer serializer];
        manager.responseSerializer                  = [AFJSONResponseSerializer serializer];
        manager.requestSerializer.stringEncoding    = NSUTF8StringEncoding;
        manager.requestSerializer.timeoutInterval   = ZSK_TIMEOUT;
        //配置响应序列化
        manager.responseSerializer.acceptableContentTypes   = [NSSet setWithArray:@[@"application/json",
                                                                                    @"text/html",
                                                                                    @"text/json",
                                                                                    @"text/plain",
                                                                                    @"text/javascript",
                                                                                    @"text/xml",
                                                                                    @"image/*",
                                                                                    @"application/octet-stream",
                                                                                    @"application/zip"]];
        _manager    = manager;
    }
    for (NSString *key in headers.allKeys)
    {
        if (headers[key] != nil)
        {
            [_manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    //每次网络请求的时候，检查此时磁盘中的缓存大小，阈值默认是40MB，如果超过阈值，则清理LRU缓存,同时也会清理过期缓存，缓存默认SSL是7天，磁盘缓存的大小和SSL的设置可以通过该方法[ZBCacheManager shareManager] setCacheTime: diskCapacity:]设置
    [[ZSKCacheManager shareManager] clearLRUCache];
    return _manager;
}
#pragma mark - get 请求
- (ZSKURLSessionTask *)getWithUrl:(NSString *)url
                           params:(id)params
                     successBlock:(ZSKResponseSuccessBlock)successBlock
                        failBlock:(ZSKResponseFailBlock)failBlock{
    return [self getWithUrl:url cache:NO params:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
    } successBlock:successBlock failBlock:failBlock];
}
#pragma mark - get 请求
- (ZSKURLSessionTask *)getWithUrl:(NSString *)url
                            cache:(BOOL)cache
                           params:(id)params
                    progressBlock:(ZSKGetProgress)progressBlock
                     successBlock:(ZSKResponseSuccessBlock)successBlock
                        failBlock:(ZSKResponseFailBlock)failBlock{
    __block ZSKURLSessionTask * sessionTask = nil;
    ZWWLog(@"请求参数 = %@",params);
    ZWWLog(@"请求地址 = %@",url);
    // 设置请求头
    NSString * token = [ZWSaveTool objectForKey:@"token"];
    if (!token) {
        token = [ZWUserModel currentUser].token;
    }
    ZWWLog(@"请求token = %@",token);
    if (token) {
        [self configHttpHeader:@{@"content-type":@"application/json;charset=UTF-8",
                                 @"Cookie":[NSString stringWithFormat:@"msid=%@",token]}];
    }else{
        [self configHttpHeader:@{@"content-type":@"application/json;charset=UTF-8"}];
    }
    NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    version = [@"ios-v" stringByAppendingString:version];
    [self configHttpHeader:@{@"nb-version":version}];
    // 无网
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable)
    {
        if (failBlock)
        {
            failBlock(ZSK_ERROR);
        }
        return sessionTask;
    }
    // 本地缓存
    id responseObj = [[ZSKCacheManager shareManager] getCacheResponseObjectWithRequestUrl:url params:params];
    if (responseObj && cache) {
        if (successBlock) {
            successBlock(responseObj);
        }
        return sessionTask;
    }
    AFHTTPSessionManager * manager  = [self manager];
    sessionTask = [manager GET:url parameters:params headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progressBlock) {
            progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *allHeaders = response.allHeaderFields;
        if (allHeaders[@"JSESSIONID"] && !ZWWOBJECT_IS_EMPYT(allHeaders[@"JSESSIONID"])) {
            ZWWLog(@"获取最新的cookit = %@",allHeaders[@"JSESSIONID"])
            NSString *token = allHeaders[@"JSESSIONID"];
            [ZWSaveTool setObject:token forKey:@"token"];
            ZWUserModel *usermodel = [ZWUserModel currentUser];
            usermodel.token = token;
            [ZWDataManager saveUserData];
        }
        
        BOOL isValid = [self networkResponseManage:responseObject];
        ZWWLog(@"请求成功 = %@",responseObject)
        if (successBlock && isValid)
        {
            successBlock(responseObject);
        }
        if (cache)
        {
            // 缓存处理
            [[ZSKCacheManager shareManager] cacheResponseObject:responseObject requestUrl:url params:params];
        }
        [requestTaskPool removeObject:sessionTask];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code == -1001) {
            ZWWLog(@"请求超时处理")
            [ZSKAlertView showWithTitle:@"温馨提示" message:@"请求超时,请重新登录" btnTitle:@"确定" completeBlock:^(NSInteger index) {
                [[NSNotificationCenter defaultCenter] postNotificationName:ZSKUserLoginFails object:nil];
            }];
            
        }else{
            ZWWLog(@"请求失败 = %@",error);
            failBlock(error);
        }
        [YJProgressHUD hideHUD];
        [requestTaskPool removeObject:sessionTask];
    }];
    // 判断重复请求。如有重复请求，取消新请求
    if ([self haveSameRequestInTasksPool:sessionTask])
    {
        [sessionTask cancel];
        return sessionTask;
    }
    else
    {
        if(sessionTask)
        {
            [requestTaskPool addObject:sessionTask];
            [sessionTask resume];
        }
        
        return sessionTask;
    }
}

/**
 *  POST请求
 *
 *  @param url              请求路径
 *  @param params           拼接参数
 *  @param successBlock     成功回调
 *  @param failBlock        失败回调
 *
 *  @return 返回的对象中可取消请求
 */
- (ZSKURLSessionTask *)postWithUrl:(NSString *)url params:(id)params successBlock:(ZSKResponseSuccessBlock)successBlock failBlock:(ZSKResponseFailBlock)failBlock{
    return [self postWithUrl:url cache:NO params:params progressBlock:^(int64_t bytesRead, int64_t totalBytes) {} successBlock:successBlock failBlock:failBlock];
}
#pragma mark - post 请求
- (ZSKURLSessionTask *)postWithUrl:(NSString *)url
                             cache:(BOOL)cache
                            params:(id)params
                     progressBlock:(ZSKPostProgress)progressBlock
                      successBlock:(ZSKResponseSuccessBlock)successBlock
                         failBlock:(ZSKResponseFailBlock)failBlock{
    ZWWLog(@"请求地址URL:= %@", url);
    ZWWLog(@"请求参数Params:= %@", params);
    // 设置请求头
    NSString * token = [ZWSaveTool objectForKey:@"token"];
    if (!token) {
        token = [ZWUserModel currentUser].token;
    }
    ZWWLog(@"post请求参数token = %@",token)
    if (token && token.length) {
        [ZWUserModel currentUser].token = token;
        [self configHttpHeader:@{@"content-type":@"application/json;charset=UTF-8",
                                 @"Cookie":[NSString stringWithFormat:@"msid=%@",token]}];
    }else{
        [self configHttpHeader:@{@"content-type":@"application/json;charset=UTF-8"}];
    }
    NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    version = [@"ios-v" stringByAppendingString:version];
    [self configHttpHeader:@{@"nb-version":version}];
    __block ZSKURLSessionTask * sessionTask = nil;
    AFHTTPSessionManager * manager = [self manager];
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable)
    {
        !failBlock ? :failBlock(ZSK_ERROR);
        return sessionTask;
    }
    ZWWLog(@"请求头部Params:= %@", manager.requestSerializer.HTTPRequestHeaders);
    sessionTask = [manager POST:url parameters:params headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        !progressBlock ? : progressBlock(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //取出来响应头的SessionID
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *allHeaders = response.allHeaderFields;
        if (allHeaders[@"JSESSIONID"] && !ZWWOBJECT_IS_EMPYT(allHeaders[@"JSESSIONID"])) {
            ZWWLog(@"获取最新的cookit = %@",allHeaders[@"JSESSIONID"])
            NSString *token = allHeaders[@"JSESSIONID"];
            [ZWSaveTool setObject:token forKey:@"token"];
            ZWUserModel *usermodel = [ZWUserModel currentUser];
            usermodel.token = token;
            [ZWDataManager saveUserData];
        }
        BOOL isValid = [self networkResponseManage:responseObject];
        ZWWLog(@"请求结果 = %@",responseObject)
        if (successBlock && isValid) successBlock(responseObject);
        if (cache) [[ZSKCacheManager shareManager] cacheResponseObject:responseObject requestUrl:url params:params];
        if ([requestTaskPool containsObject:sessionTask])
        {
            [requestTaskPool removeObject:sessionTask];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code == -1001) {
            ZWWLog(@"请求超时处理")
            [ZSKAlertView showWithTitle:@"温馨提示" message:@"请求超时,请重新登录" btnTitle:@"确定" completeBlock:^(NSInteger index) {
                [[NSNotificationCenter defaultCenter] postNotificationName:ZSKUserLoginFails object:nil];
            }];
        }else{
            ZWWLog(@"请求失败 = %@",error);
            failBlock(error);
        }
        [requestTaskPool removeObject:sessionTask];
    }];
    //判断重复请求，如果有重复请求，取消新请求
    if ([self haveSameRequestInTasksPool:sessionTask])
    {
        [sessionTask cancel];
        return sessionTask;
    }
    else
    {
        if(sessionTask)
        {
            [requestTaskPool addObject:sessionTask];
            [sessionTask resume];
        }
        
        return sessionTask;
    }
}

/**
 *  PUT请求
 *
 *  @param url              请求路径
 *  @param params           拼接参数
 *  @param successBlock     成功回调
 *  @param failBlock        失败回调
 *
 *  @return 返回的对象中可取消请求
 */
- (ZSKURLSessionTask *)putWithUrl:(NSString *)url
                           params:(id)params
                     successBlock:(ZSKResponseSuccessBlock)successBlock
                        failBlock:(ZSKResponseFailBlock)failBlock{
    return [self putWithUrl:url cache:NO params:params successBlock:successBlock failBlock:failBlock];
}

/**
 *  PUT请求
 *
 *  @param url              请求路径
 *  @param cache            是否缓存
 *  @param params           拼接参数
 *  @param successBlock     成功回调
 *  @param failBlock        失败回调
 *
 *  @return 返回的对象中可取消请求
 */
- (ZSKURLSessionTask *)putWithUrl:(NSString *)url cache:(BOOL)cache params:(id)params successBlock:(ZSKResponseSuccessBlock)successBlock failBlock:(ZSKResponseFailBlock)failBlock{
    ZWWLog(@"URL: %@", url);
    ZWWLog(@"Params: %@", params);
    
    // 设置请求头
    NSString * token = [ZWUserModel currentUser].token;
    if (!token) {
        token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        [ZWUserModel currentUser].token = token;
    }
    
    if (token) {//需要修改token
        [self configHttpHeader:@{@"content-type":@"application/json;charset=UTF-8",
                                 @"X-Access-Token":token}];
    }else{
        [self configHttpHeader:@{@"content-type":@"application/json;charset=UTF-8"}];
    }
    
    __block ZSKURLSessionTask * sessionTask = nil;
    AFHTTPSessionManager * manager = [self manager];
    
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable)
    {
        !failBlock ? :failBlock(ZSK_ERROR);
        return sessionTask;
    }
    
    ZWWLog(@"Params: %@", manager.requestSerializer.HTTPRequestHeaders);
    sessionTask = [manager PUT:url parameters:params headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BOOL isValid = [self networkResponseManage:responseObject];
        if (successBlock && isValid) successBlock(responseObject);
        if (cache) [[ZSKCacheManager shareManager] cacheResponseObject:responseObject requestUrl:url params:params];
        if ([requestTaskPool containsObject:sessionTask]){
            [requestTaskPool removeObject:sessionTask];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code == -1001) {
            ZWWLog(@"请求超时处理")
            [ZSKAlertView showWithTitle:@"温馨提示" message:@"请求超时,请重新登录" btnTitle:@"确定" completeBlock:^(NSInteger index) {
                [[NSNotificationCenter defaultCenter] postNotificationName:ZSKUserLoginFails object:nil];
            }];
            
        }else{
            ZWWLog(@"请求失败 = %@",error);
            failBlock(error);
        }
        [YJProgressHUD hideHUD];
        [requestTaskPool removeObject:sessionTask];
    }];
    //判断重复请求，如果有重复请求，取消新请求
    if ([self haveSameRequestInTasksPool:sessionTask])
    {
        [sessionTask cancel];
        return sessionTask;
    }
    else
    {
        if(sessionTask)
        {
            [requestTaskPool addObject:sessionTask];
            [sessionTask resume];
        }
        return sessionTask;
    }
}
- (ZSKURLSessionTask *)DELETEWithUrl:(NSString *)url
      params:(id)params
successBlock:(ZSKResponseSuccessBlock)successBlock
                           failBlock:(ZSKResponseFailBlock)failBlock{
    ZWWLog(@"URL: %@", url);
    ZWWLog(@"Params: %@", params);
    
    // 设置请求头
    NSString * token = [ZWUserModel currentUser].token;
    if (!token) {
        token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        [ZWUserModel currentUser].token = token;
    }
    if (token) {
        [self configHttpHeader:@{@"content-type":@"application/json;charset=UTF-8",
                                 @"X-Access-Token":token}];
    }else{
        [self configHttpHeader:@{@"content-type":@"application/json;charset=UTF-8"}];
    }
    __block ZSKURLSessionTask * sessionTask = nil;
    AFHTTPSessionManager * manager = [self manager];
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable)
    {
        !failBlock ? :failBlock(ZSK_ERROR);
        return sessionTask;
    }
    //ZWWLog(@"Params: %@", manager.requestSerializer.HTTPRequestHeaders);
    sessionTask = [manager DELETE:url parameters:params headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BOOL isValid = [self networkResponseManage:responseObject];
        if (successBlock && isValid) successBlock(responseObject);
        if ([requestTaskPool containsObject:sessionTask]){
            [requestTaskPool removeObject:sessionTask];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code == -1001) {
            ZWWLog(@"请求超时处理")
            [ZSKAlertView showWithTitle:@"温馨提示" message:@"请求超时,请重新登录" btnTitle:@"确定" completeBlock:^(NSInteger index) {
                [[NSNotificationCenter defaultCenter] postNotificationName:ZSKUserLoginFails object:nil];
            }];
        }else{
            ZWWLog(@"请求失败 = %@",error);
            failBlock(error);
        }
        [YJProgressHUD hideHUD];
        [requestTaskPool removeObject:sessionTask];
    }];
    
    //判断重复请求，如果有重复请求，取消新请求
    if ([self haveSameRequestInTasksPool:sessionTask])
    {
        [sessionTask cancel];
        return sessionTask;
    }
    else
    {
        if(sessionTask)
        {
            [requestTaskPool addObject:sessionTask];
            [sessionTask resume];
        }
        return sessionTask;
    }
}
#pragma mark - 上传图片
- (ZSKURLSessionTask *)uploadImageWithUrl:(NSString *)url parameters:(NSDictionary *)paramers image:(UIImage *)image  successBlock:(ZSKResponseSuccessBlock)successBlock failBlock:(ZSKResponseFailBlock)failBlock{
    NSData * imgData = [ObjectTools compressImage:image toByte:500*1024];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat   = @"YYYY-MM-dd-hh:mm:ss:SSS";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
    return [self uploadFileWithUrl:url parameters:paramers fileData:imgData name:@"file" fileName:fileName mimeType:@"image/png" progressBlock:^(int64_t bytesWritten, int64_t totalBytes) {
        ZWWLog(@"%0.2f",bytesWritten*1.0 / totalBytes);
    } successBlock:successBlock failBlock:failBlock];
}

#pragma mark - 文件上传
- (ZSKURLSessionTask *)uploadFileWithUrl:(NSString *)url
                              parameters:(NSDictionary *)paramers
                                fileData:(NSData *)data
                                    name:(NSString *)name
                                fileName:(NSString *)fileName
                                mimeType:(NSString *)mimeType
                           progressBlock:(ZSKUploadProgressBlock)progressBlock
                            successBlock:(ZSKResponseSuccessBlock)successBlock
                               failBlock:(ZSKResponseFailBlock)failBlock
{
    __block ZSKURLSessionTask * sessionTask     = nil;
    AFHTTPSessionManager *manager               = [self manager];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    NSString * token = [ZWSaveTool objectForKey:@"token"];
    if (!token) {
        token = [ZWUserModel currentUser].token;
    }
    ZWWLog(@"请求token = %@",token);
    if (token) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"msid=%@",token] forHTTPHeaderField:@"Cookie"];
    }

    NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    version = [@"ios-v" stringByAppendingString:version];
    [self configHttpHeader:@{@"nb-version":version}];
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        !failBlock ? :failBlock(ZSK_ERROR);
        return sessionTask;
    }
    sessionTask = [manager POST:url parameters:paramers headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        !progressBlock ? :progressBlock (uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        !successBlock ? : successBlock(responseObject);
        [requestTaskPool removeObject:sessionTask];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code == -1001) {
            ZWWLog(@"请求超时处理")
            [ZSKAlertView showWithTitle:@"温馨提示" message:@"请求超时,请重新登录" btnTitle:@"确定" completeBlock:^(NSInteger index) {
                [[NSNotificationCenter defaultCenter] postNotificationName:ZSKUserLoginFails object:nil];
            }];
        }else{
            ZWWLog(@"请求失败 = %@",error);
            failBlock(error);
        }
        [YJProgressHUD hideHUD];
        [requestTaskPool removeObject:sessionTask];
    }];
    if(sessionTask)
    {
        [requestTaskPool addObject:sessionTask];
        [sessionTask resume];
    }
    return sessionTask;
}

#pragma mark - 多文件上传
-(NSArray *)uploadMultFileWithUrl:(NSString *)url fileDatas:(NSArray *)datas name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeTypes progressBlock:(ZSKUploadProgressBlock)progressBlock successBlock:(ZSKMultUploadSuccessBlock)successBlock failBlock:(ZSKMultUploadFailBlock)failBlock
{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        if (failBlock) failBlock(@[ZSK_ERROR]);
        return nil;
    }
    __block NSMutableArray *sessions = [NSMutableArray array];
    __block NSMutableArray *responses = [NSMutableArray array];
    __block NSMutableArray *failResponse = [NSMutableArray array];
    dispatch_group_t uploadGroup = dispatch_group_create();
    NSInteger count = datas.count;
    for (int i = 0; i < count; i++) {
        __block ZSKURLSessionTask *session = nil;
        dispatch_group_enter(uploadGroup);
        session = [self uploadFileWithUrl:url parameters:nil fileData:datas[i] name:name fileName:fileName mimeType:mimeTypes progressBlock:^(int64_t bytesWritten, int64_t totalBytes) {
            if (progressBlock) progressBlock(bytesWritten, totalBytes);
        } successBlock:^(id response) {
            [responses addObject:response];
            dispatch_group_leave(uploadGroup);
            [sessions removeObject:session];
        } failBlock:^(NSError *error) {
            NSError *Error = [NSError errorWithDomain:url code:-999 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"第%d次上传失败",i]}];
            [failResponse addObject:Error];
            dispatch_group_leave(uploadGroup);
            [sessions removeObject:session];
        }];
        [session resume];
        if (session) [sessions addObject:session];
    }
    [requestTaskPool addObjectsFromArray:sessions];
    dispatch_group_notify(uploadGroup, dispatch_get_main_queue(), ^{
        if (responses.count > 0) {
            if (successBlock) {
                successBlock([responses copy]);
                if (sessions.count > 0) {
                    [requestTaskPool removeObjectsInArray:sessions];
                }
            }
        }
        if (failResponse.count > 0) {
            if (failBlock) {
                failBlock([failResponse copy]);
                if (sessions.count > 0) {
                    [requestTaskPool removeObjectsInArray:sessions];
                }
            }
        }
    });
    return [sessions copy];
}
#pragma 多文件上传
- (ZSKURLSessionTask *)uploadMultFileWithUrl:(NSString *)url parameters:(NSDictionary *)paramers FileDataARR:(NSMutableArray*)fileDataARR nameARR:(NSMutableArray*)nameARR fileName:(NSString *)fileName mimeType:(NSString *)mimeType progressBlock:(ZSKUploadProgressBlock)progressBlock successBlock:(ZSKResponseSuccessBlock)successBlock failBlock:(ZSKResponseFailBlock)failBlock{
    __block ZSKURLSessionTask * sessionTask     = nil;
    //AFHTTPSessionManager *manager               = [self manager];
    AFHTTPSessionManager *manager               = [AFHTTPSessionManager manager];
    //默认解析模式
    manager.requestSerializer                   = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer                  = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.stringEncoding    = NSUTF8StringEncoding;
    manager.requestSerializer.timeoutInterval   = ZSK_TIMEOUT;
    //配置响应序列化
    manager.responseSerializer.acceptableContentTypes   = [NSSet setWithArray:@[@"application/json",
                                                                                @"text/html",
                                                                                @"text/json",
                                                                                @"text/plain",
                                                                                @"text/javascript",
                                                                                @"text/xml",
                                                                                @"image/*",
                                                                                @"application/octet-stream",
                                                                                @"application/zip"]];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    NSString * token = [ZWSaveTool objectForKey:@"token"];
    if (!token) {
        token = [ZWUserModel currentUser].token;
    }
    ZWWLog(@"请求token = %@",token);
    ZWWLog(@"请求地址URL:= %@", url);
    ZWWLog(@"请求参数Params:= %@", paramers);
    if (token) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"msid=%@",token] forHTTPHeaderField:@"Cookie"];
    }

    NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    version = [@"ios-v" stringByAppendingString:version];
    [self configHttpHeader:@{@"nb-version":version}];
    ZWWLog(@"Params: %@", manager.requestSerializer.HTTPRequestHeaders);
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        !failBlock ? :failBlock(ZSK_ERROR);
        return sessionTask;
    }
    sessionTask = [manager POST:url parameters:paramers headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < fileDataARR.count; i++){
            [formData appendPartWithFileData:fileDataARR[i] name:fileName fileName:nameARR[i] mimeType:mimeType];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        !progressBlock ? :progressBlock (uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZWWLog(@"上传成功 上传成功 上传成功 = %@",responseObject)
        !successBlock ? : successBlock(responseObject);
        [requestTaskPool removeObject:sessionTask];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code == -1001) {
            ZWWLog(@"请求超时处理")
            [ZSKAlertView showWithTitle:@"温馨提示" message:@"请求超时,请重新登录" btnTitle:@"确定" completeBlock:^(NSInteger index) {
                [[NSNotificationCenter defaultCenter] postNotificationName:ZSKUserLoginFails object:nil];
            }];
        }else{
            ZWWLog(@"请求失败 = %@",error);
            failBlock(error);
        }
        [YJProgressHUD hideHUD];
        [requestTaskPool removeObject:sessionTask];
    }];
    if(sessionTask)
    {
        [requestTaskPool addObject:sessionTask];
        [sessionTask resume];
    }
    return sessionTask;
}
#pragma mark - 下载
- (ZSKURLSessionTask *)downloadWithUrl:(NSString *)url
                         progressBlock:(ZSKDownloadProgress)progressBlock
                          successBlock:(ZSKDownloadSuccessBlock)successBlock
                             failBlock:(ZSKDownloadFailBlock)failBlock
{
    __block ZSKURLSessionTask *sessionTask = nil;
    
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        !failBlock ? :failBlock(ZSK_ERROR);
        return sessionTask;
    }
    
    //    NSURL *fileUrl = [[ZSKCacheManager shareManager] getDownloadDataFromCacheWithRequestUrl:url];
    //    if (fileUrl) {
    //        if (successBlock) successBlock(fileUrl);
    //        return nil;
    //    }
    
    //    if (url) {
    //        subStringArr = [url componentsSeparatedByString:@"."];
    //        if (subStringArr.count > 0) {
    //            type = subStringArr[subStringArr.count - 1];
    //        }
    //    }
    
    AFHTTPSessionManager *manager = [self manager];
    //响应内容序列化为二进制
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    sessionTask = [manager GET:url parameters:nil headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progressBlock) progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            NSData *dataObj = (NSData *)responseObject;
            [[ZSKCacheManager shareManager] storeDownloadData:dataObj requestUrl:url];
            NSURL *downFileUrl = [[ZSKCacheManager shareManager] getDownloadDataFromCacheWithRequestUrl:url];
            successBlock(downFileUrl);
        }
        [requestTaskPool removeObject:sessionTask];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failBlock) {
            failBlock (error);
        }
        [requestTaskPool removeObject:sessionTask];
    }];
    [sessionTask resume];
    if (sessionTask) [requestTaskPool addObject:sessionTask];
    return sessionTask;
}

#pragma mark - other method
- (void)cancleAllRequest {
    @synchronized (self) {
        [requestTaskPool enumerateObjectsUsingBlock:^(ZSKURLSessionTask  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[ZSKURLSessionTask class]]) {
                [obj cancel];
            }
        }];
        [requestTaskPool removeAllObjects];
    }
}
#pragma mark - 取消请求
- (void)cancelRequestWithURL:(NSString *)url {
    if (!url) return;
    @synchronized (self) {
        [requestTaskPool enumerateObjectsUsingBlock:^(ZSKURLSessionTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[ZSKURLSessionTask class]]) {
                if ([obj.currentRequest.URL.absoluteString hasSuffix:url]) {
                    [obj cancel];
                    *stop = YES;
                }
            }
        }];
    }
}
- (void)configHttpHeader:(NSDictionary *)httpHeader {
    headers = httpHeader;
}
- (NSArray *)currentRunningTasks {
    return [requestTaskPool copy];
}
#pragma mark - 如果有旧的请求 取消旧请求
- (ZSKURLSessionTask *)cancleSameRequestInTasksPool:(ZSKURLSessionTask *)task
{
    __block ZSKURLSessionTask * oldTask = nil;
    [[self currentRunningTasks] enumerateObjectsUsingBlock:^(ZSKURLSessionTask * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([task.originalRequest isTheSameRequest:obj.originalRequest])
        {
            if (obj.state == NSURLSessionTaskStateRunning)
            {
                [obj cancel];
                oldTask = obj;
            }
            *stop   = YES;
        }
    }];
    return oldTask;
}
#pragma mark - 判断是否有重复请求
- (BOOL)haveSameRequestInTasksPool:(ZSKURLSessionTask *)task{
    __block BOOL isSame = NO;
    [[self currentRunningTasks] enumerateObjectsUsingBlock:^(ZSKURLSessionTask * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([task.originalRequest isTheSameRequest:obj.originalRequest])
        {
            isSame   = YES;
            *stop    = YES;
        }
    }];
    return isSame;
}
#pragma mark - 网络回调统一处理（如果需要，需单独处理）
- (BOOL)networkResponseManage:(id)responseObject{
    NSData *data    = nil;
    NSError *error  = nil;
    if ([responseObject isKindOfClass:[NSData class]])
    {
        data = responseObject;
    }
    else if ([responseObject isKindOfClass:[NSDictionary class]])
    {
        data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&error];
    }
    //    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    //    NSLog(@"%@",json);
    
    //统一判断所有请求返回状态，例如：强制更新为6，若为6就返回YES，
    int stat = 0;
    switch (stat) {
        case -1:{//强制退出
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                NSLog(@"点击了取消");
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSLog(@"点击了确定");
            }]];
            
            UIViewController *rootViewController = [[[UIApplication sharedApplication] windows].lastObject rootViewController];
            [rootViewController presentViewController:alert animated:YES completion:^{
                
            }];
            return NO;
        }
            break;
        case -2:{//强制更新
            return NO;
        }
            break;
        case -3:{//弹出对话框
            return NO;
        }
            break;
        default:
            break;
    }
    return YES;
}

@end



#pragma mark -
@implementation ZSKNetworking (cache)

- (NSString *)getDownDirectoryPath {
    return [[ZSKCacheManager shareManager] getDownDirectoryPath];
}

- (NSString *)getCacheDiretoryPath {
    return [[ZSKCacheManager shareManager] getCacheDiretoryPath];
}

- (NSUInteger)totalCacheSize {
    return [[ZSKCacheManager shareManager] totalCacheSize];
}

- (NSUInteger)totalDownloadDataSize {
    return [[ZSKCacheManager shareManager] totalDownloadDataSize];
}

- (void)clearDownloadData {
    [[ZSKCacheManager shareManager] clearDownloadData];
}

- (void)clearTotalCache {
    [[ZSKCacheManager shareManager] clearTotalCache];
}

@end

