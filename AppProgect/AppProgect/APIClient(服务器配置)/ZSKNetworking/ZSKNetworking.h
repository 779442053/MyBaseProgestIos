//
//  ZSKNetworking.h
//  AppProgect
//
//  Created by step_zhang on 2021/9/7.
//

#import <Foundation/Foundation.h>
/**
 *  请求任务
 */
typedef NSURLSessionTask ZSKURLSessionTask;

/**
 *  成功回调
 *
 *  @param response 成功后返回的数据
 */
typedef void(^ZSKResponseSuccessBlock)(id _Nonnull response);

/**
 *  失败回调
 *
 *  @param error 失败后返回的错误信息
 */
typedef void(^ZSKResponseFailBlock)(NSError * _Nonnull error);

/**
 *  下载进度
 *
 *  @param bytesRead              已下载的大小
 *  @param totalBytes                总下载大小
 */
typedef void (^ZSKDownloadProgress)(int64_t bytesRead, int64_t totalBytes);

/**
 *  下载成功回调
 *
 *  @param url                       下载存放的路径
 */
typedef void(^ZSKDownloadSuccessBlock)(NSURL * _Nonnull url);

/**
 *  上传进度
 *  @param bytesWritten              已上传的大小
 *  @param totalBytes                总上传大小
 */
typedef void(^ZSKUploadProgressBlock)(int64_t bytesWritten, int64_t totalBytes);

/**
 *  多文件上传成功回调
 *  @param responses 成功后返回的数据
 */
typedef void(^ZSKMultUploadSuccessBlock)(NSArray * _Nonnull responses);

/**
 *  多文件上传失败回调
 *  @param errors 失败后返回的错误信息
 */
typedef void(^ZSKMultUploadFailBlock)(NSArray * _Nonnull errors);
typedef ZSKDownloadProgress ZSKGetProgress;
typedef ZSKDownloadProgress ZSKPostProgress;
typedef ZSKResponseFailBlock ZSKDownloadFailBlock;


NS_ASSUME_NONNULL_BEGIN

@interface ZSKNetworking : NSObject

+ (instancetype)shaerdInstance;

/**
 *  正在运行的网络任务
 *  @return task
 */
- (NSArray *)currentRunningTasks;


/**
 *  配置请求头
 *  @param httpHeader 请求头
 */
- (void)configHttpHeader:(NSDictionary *)httpHeader;

/**
 *  取消GET请求
 */
- (void)cancelRequestWithURL:(NSString *)url;

/**
 *  取消所有请求
 */
- (void)cancleAllRequest;

/**
*  GET请求
*
*  @param url              请求路径
*  @param params           拼接参数
*  @param successBlock     成功回调
*  @param failBlock        失败回调
*
*  @return 返回的对象中可取消请求
*/
- (ZSKURLSessionTask *)getWithUrl:(NSString *)url
                           params:(id)params
                     successBlock:(ZSKResponseSuccessBlock)successBlock
                        failBlock:(ZSKResponseFailBlock)failBlock;

/**
 *  GET请求
 *
 *  @param url              请求路径
 *  @param cache            是否缓存
 *  @param params           拼接参数
 *  @param progressBlock    进度回调
 *  @param successBlock     成功回调
 *  @param failBlock        失败回调
 *
 *  @return 返回的对象中可取消请求
 */
- (ZSKURLSessionTask *)getWithUrl:(NSString *)url cache:(BOOL)cache params:(id)params progressBlock:(ZSKGetProgress)progressBlock successBlock:(ZSKResponseSuccessBlock)successBlock failBlock:(ZSKResponseFailBlock)failBlock;




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
- (ZSKURLSessionTask *)postWithUrl:(NSString *)url params:(id)params successBlock:(ZSKResponseSuccessBlock)successBlock failBlock:(ZSKResponseFailBlock)failBlock;
//- (ZSKURLSessionTask *)postTWOWithUrl:(NSString *)url params:(id)params successBlock:(ZSKResponseSuccessBlock)successBlock failBlock:(ZSKResponseFailBlock)failBlock;
/**
 *  POST请求
 *
 *  @param url              请求路径
 *  @param cache            是否缓存
 *  @param params           拼接参数
 *  @param progressBlock    进度回调
 *  @param successBlock     成功回调
 *  @param failBlock        失败回调
 *
 *  @return 返回的对象中可取消请求
 */
- (ZSKURLSessionTask *)postWithUrl:(NSString *)url cache:(BOOL)cache params:(id)params progressBlock:(ZSKPostProgress)progressBlock successBlock:(ZSKResponseSuccessBlock)successBlock failBlock:(ZSKResponseFailBlock)failBlock;


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
                        failBlock:(ZSKResponseFailBlock)failBlock;

/**
 *  put请求
 *
 *  @param url              请求路径
 *  @param cache            是否缓存
 *  @param params           拼接参数
 *  @param progressBlock    进度回调
 *  @param successBlock     成功回调
 *  @param failBlock        失败回调
 *
 *  @return 返回的对象中可取消请求
 */
- (ZSKURLSessionTask *)putWithUrl:(NSString *)url cache:(BOOL)cache params:(id)params successBlock:(ZSKResponseSuccessBlock)successBlock failBlock:(ZSKResponseFailBlock)failBlock;



- (ZSKURLSessionTask *)uploadImageWithUrl:(NSString *)url parameters:(NSDictionary *)paramers image:(UIImage *)image  successBlock:(ZSKResponseSuccessBlock)successBlock failBlock:(ZSKResponseFailBlock)failBlock;

/**
 *  文件上传
 *
 *  @param url              上传文件接口地址
 *  @param data             上传文件数据
 *  @param fileName         上传文件名
 *  @param name             上传文件服务器文件夹名
 *  @param mimeType         mimeType
 *  @param progressBlock    上传文件路径
 *    @param successBlock     成功回调
 *    @param failBlock        失败回调
 *
 *  @return 返回的对象中可取消请求
 */
- (ZSKURLSessionTask *)uploadFileWithUrl:(NSString *)url parameters:(NSDictionary *)paramers fileData:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType progressBlock:(ZSKUploadProgressBlock)progressBlock successBlock:(ZSKResponseSuccessBlock)successBlock failBlock:(ZSKResponseFailBlock)failBlock;


/**
 *  多文件上传
 *
 *  @param url           上传文件地址
 *  @param datas         数据集合
 *  @param name          服务器文件夹名
 *  @param fileName      上传文件名
 *  @param mimeTypes      mimeTypes
 *  @param progressBlock 上传进度
 *  @param successBlock  成功回调
 *  @param failBlock     失败回调
 *
 *  @return 任务集合
 */
- (NSArray *)uploadMultFileWithUrl:(NSString *)url fileDatas:(NSArray *)datas name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeTypes progressBlock:(ZSKUploadProgressBlock)progressBlock successBlock:(ZSKMultUploadSuccessBlock)successBlock failBlock:(ZSKMultUploadFailBlock)failBlock;

/**
 多图上传
 */
- (ZSKURLSessionTask *)uploadMultFileWithUrl:(NSString *)url parameters:(NSDictionary *)paramers FileDataARR:(NSMutableArray*)fileDataARR nameARR:(NSMutableArray*)nameARR fileName:(NSString *)fileName mimeType:(NSString *)mimeType progressBlock:(ZSKUploadProgressBlock)progressBlock successBlock:(ZSKResponseSuccessBlock)successBlock failBlock:(ZSKResponseFailBlock)failBlock;
/**
 *  文件下载
 *
 *  @param url           下载文件接口地址
 *  @param progressBlock 下载进度
 *  @param successBlock  成功回调
 *  @param failBlock     下载回调
 *
 *  @return 返回的对象可取消请求
 */
- (ZSKURLSessionTask *)downloadWithUrl:(NSString *)url progressBlock:(ZSKDownloadProgress)progressBlock successBlock:(ZSKDownloadSuccessBlock)successBlock failBlock:(ZSKDownloadFailBlock)failBlock;

//DELETE 请求
- (ZSKURLSessionTask *)DELETEWithUrl:(NSString *)url
      params:(id)params
successBlock:(ZSKResponseSuccessBlock)successBlock
   failBlock:(ZSKResponseFailBlock)failBlock;



@end



@interface ZSKNetworking (cache)

/**
 *  获取缓存目录路径
 *
 *  @return 缓存目录路径
 */
- (NSString *)getCacheDiretoryPath;

/**
 *  获取下载目录路径
 *
 *  @return 下载目录路径
 */
- (NSString *)getDownDirectoryPath;

/**
 *  获取缓存大小
 *
 *  @return 缓存大小
 */
- (NSUInteger)totalCacheSize;

/**
 *  获取所有下载数据大小
 *
 *  @return 下载数据大小
 */
- (NSUInteger)totalDownloadDataSize;

/**
 *  清除下载数据
 */
- (void)clearDownloadData;

/**
 *  清除所有缓存
 */
- (void)clearTotalCache;

@end

NS_ASSUME_NONNULL_END
