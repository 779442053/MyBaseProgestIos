//
//  ZWDataManager.m
//  NBJKCardHome
//
//  Created by step_zhang on 2020/11/20.
//

#import "ZWDataManager.h"
#import <objc/runtime.h>
#import "ZWUserModel.h"
/**
 *用户数据路径
 */
NSString * const kUserPath = @"Documents/user.plist";
@implementation ZWDataManager
+ (void)saveUserData
{
    if([NSKeyedArchiver archiveRootObject:[ZWUserModel currentUser] toFile:[NSHomeDirectory() stringByAppendingPathComponent:kUserPath]])
    {
        ZWWLog(@"用户数据保存成功");
    }else{
        ZWWLog(@"用户数据保存失败失败");
    }
}
///删除
+ (void)removeUserData
{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    //文件名
    NSString *uniquePath = [NSHomeDirectory() stringByAppendingPathComponent:kUserPath];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        ZWWLog(@"没有这个文件");
        return ;
    }else {
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDele) {
            ZWWLog(@"删除用户数据成功");
        }else {
            ZWWLog(@"删除用户数据失败");
        }

    }
}

///读取数据
+ (void)readUserData
{
    @weakify(self);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @strongify(self);
        NSString *userPath = [NSHomeDirectory() stringByAppendingPathComponent:kUserPath];
        NSError *userError;
        NSData *userData = [NSData dataWithContentsOfFile:userPath options:NSDataReadingMappedIfSafe error:&userError];
        if (!userError)
        {
            ZWUserModel *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
            [self setObj:[ZWUserModel currentUser] fromObj:user];
            //发出下面的通知,是为了让tabbaritem上面显示bagevual
//            [[NSNotificationCenter defaultCenter] postNotificationName:READ_USER_DATA_FINISH object:nil];
            ZWWLog(@"读取用户数据成功");
            ZWWLog(@"读取用户数据成功token = %@",[ZWUserModel currentUser].token);
            
        }
    });

}
/**
 NSUserDefaults  会占用太多系统内存和系统线程. 容易造成取字符串取错的现象,
 
 2021-01-19   obj1所有属性赋值给obj2   利用runtime
 不采用 NSUserDefaults  进行缓存, 转而采用 runtime .代码易懂且高效
  
 */
+ (void)setObj:(id)toObj
       fromObj:(id)fromObj
{
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList([toObj class], &count);
    for (int i = 0; i < count; i++)
    {
        objc_property_t pro = propertyList[i];
        const char *name = property_getName(pro);
        NSString *key = [NSString stringWithUTF8String:name];
        if ([fromObj valueForKey:key])
        {
            [toObj setValue:[fromObj valueForKey:key] forKey:key];
        }
    }
}
@end
