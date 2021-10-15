//
//  ZWSaveTool.m
//  NBJKCardHome
//
//  Created by step_zhang on 2020/11/20.
//

#import "ZWSaveTool.h"

@implementation ZWSaveTool
+ (id)objectForKey:(NSString *)defaultName{
    return  [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
}
+ (BOOL)BoolForKey:(NSString *)defaultName{
    return  [[NSUserDefaults standardUserDefaults] boolForKey:defaultName];
}
+ (void)setObject:(id)value forKey:(NSString *)defaultName
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)setBool:(BOOL)value forKey:(NSString *)defaultName{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
