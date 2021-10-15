//
//  ZSKMemoryCache.m
//
//  AppProgect
//
//  Created by step_zhang on 2021/9/7.
//

#import "ZSKMemoryCache.h"

static NSCache *shareCache;

@implementation ZSKMemoryCache


+ (NSCache *)shareCache {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (shareCache == nil) {
            shareCache = [[NSCache alloc] init];
        }
        
        //当收到内存警报时，清空内存缓存
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification
                                                          object:nil
                                                           queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
                                                               [shareCache removeAllObjects];
                                                           }];
    });
    return shareCache;
}

+ (void)writeData:(id)data forKey:(NSString *)key {
    assert(data);
    assert(key);
    
    NSCache *cache = [ZSKMemoryCache shareCache];
    [cache setObject:data forKey:key];
}

+ (id)readDataWithKey:(NSString *)key {
    assert(key);
    id data = nil;
    NSCache *cache = [ZSKMemoryCache shareCache];
    data = [cache objectForKey:key];
    return data;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}


@end
