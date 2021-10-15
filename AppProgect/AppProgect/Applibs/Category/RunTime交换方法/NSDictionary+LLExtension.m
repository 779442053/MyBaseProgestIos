//
//  NSDictionary+LLExtension.m
//  LeLiaoAPP
//
//  Created by step_zhang on 2020/2/19.
//  Copyright © 2020 step_zhang. All rights reserved.
//

#import "NSDictionary+LLExtension.h"




@implementation NSDictionary (LLExtension)
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonStr
{
    if (jsonStr == nil) {
        return nil;
    }
    NSData* jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if (err) {
//        ICLog(@"json serialize failue");
        return nil;
    }
    return dic;
}

- (NSString*)jsonString
{
    NSData* infoJsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    NSString* json = [[NSString alloc] initWithData:infoJsonData encoding:NSUTF8StringEncoding];
    return json;
}

@end
