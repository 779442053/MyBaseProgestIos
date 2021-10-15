//
//  NSObject+ZWSafeModel.m
//  Kuaizhu2
//
//  Created by step_zhang on 2019/11/29.
//  Copyright © 2019 step_zhang. All rights reserved.
//

#import "NSObject+ZWSafeModel.h"
#import "ZWMessage.h"
@implementation NSObject (ZWSafeModel)
+ (void)safe{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       //nsarray
        [self exchangeOriginalMethod:[NSArray __NSArrayI:@selector(objectAtIndex:)] withNewMethod:[NSArray __NSArrayI:@selector(__NSArrayIobjectAtIndex:)]];//不可变数组

        [self exchangeOriginalMethod:[NSArray __NSArray0:@selector(objectAtIndex:)] withNewMethod:[NSArray __NSArray0:@selector(__NSArray0objectAtIndex:)]];//空数组

        [self exchangeOriginalMethod:[NSArray __NSSingleObjectArrayI:@selector(objectAtIndex:)] withNewMethod:[NSArray __NSSingleObjectArrayI:@selector(__NSSingleObjectArrayIobjectAtIndex:)]];//单元数数组

        [self exchangeOriginalMethod:[NSArray __NSArrayI:@selector(objectAtIndexedSubscript:)] withNewMethod:[NSArray __NSArrayI:@selector(objectAtAnyIndexedSubscript:)]];

      //nsmutableArray
        [self exchangeOriginalMethod:[NSMutableArray __NSArrayM:@selector(objectAtIndex:)] withNewMethod:[NSMutableArray __NSArrayM:@selector(m_objectAtAnyIndex:)]];
        
         [self exchangeOriginalMethod:[NSMutableArray __NSArrayM:@selector(objectAtIndexedSubscript:)] withNewMethod:[NSMutableArray __NSArrayM:@selector(m_objectAtAnyIndexedSubscript:)]];
        
        [self exchangeOriginalMethod:[NSMutableArray __NSArrayM:@selector(replaceObjectAtIndex:withObject:)] withNewMethod:[NSMutableArray __NSArrayM:@selector(replaceAnyObjectAtIndex:withObject:)]];
        
        [self exchangeOriginalMethod:[NSMutableArray __NSArrayM:@selector(addObject:)] withNewMethod:[NSMutableArray __NSArrayM:@selector(addAnyObject:)]];
        
        [self exchangeOriginalMethod:[NSMutableArray __NSArrayM:@selector(insertObject:atIndex:)] withNewMethod:[NSMutableArray __NSArrayM:@selector(insertAnyObject:atIndex:)]];
//
        
        //nsmutableDictionary
        [self exchangeOriginalMethod:[NSMutableDictionary methodOfSelector:@selector(setObject:forKey:)] withNewMethod:[NSMutableDictionary methodOfSelector:@selector(setAnyObject:forKey:)]];
    });
}

+ (void)exchangeOriginalMethod:(Method)originalMethod withNewMethod:(Method)newMethod{
    method_exchangeImplementations(originalMethod, newMethod);
}

@end
@implementation NSArray (Safe)

+ (Method)__NSArrayI:(SEL)selector{
     return class_getInstanceMethod(NSClassFromString(@"__NSArrayI"),selector);
}
+ (Method)__NSArray0:(SEL)selector{
    return class_getInstanceMethod(NSClassFromString(@"__NSArray0"),selector);
}
+ (Method)__NSSingleObjectArrayI:(SEL)selector{
    return class_getInstanceMethod(NSClassFromString(@"__NSSingleObjectArrayI"),selector);
}
+ (Method)__NSArrayM:(SEL)selector{
    return class_getInstanceMethod(NSClassFromString(@"__NSArrayM"),selector);
}

- (id)__NSArrayIobjectAtIndex:(NSUInteger)index{
    if (index >= self.count) {
        [ZWMessage error:@"不可变数组此对不存在" title:@"温馨提示"];
        NSLog(@"-------不可变数组此对不存在");
        return @"";
    }
    return [self __NSArrayIobjectAtIndex:index];
}
- (id)__NSArray0objectAtIndex:(NSUInteger)index{
    if (index >= self.count) {
        [ZWMessage error:@"空数组此对不存在" title:@"温馨提示"];
        NSLog(@"-------空数组此对不存在");
        return @"";
    }
    return [self __NSArray0objectAtIndex:index];
}
- (id)__NSSingleObjectArrayIobjectAtIndex:(NSUInteger)index{
    if (index >= self.count) {
        [ZWMessage error:@"单元数数组此对不存在" title:@"温馨提示"];
        NSLog(@"-------单元数数组此对不存在");
        return @"";
    }
    return [self __NSSingleObjectArrayIobjectAtIndex:index];
}
- (id)objectAtAnyIndexedSubscript:(NSUInteger)idx{
    
    if (idx >= self.count) {
        [ZWMessage error:@"-------[]此对不存在" title:@"温馨提示"];
        NSLog(@"-------[]此对不存在");
        return @"";
    }
    return [self objectAtAnyIndexedSubscript:idx];
}
- (id)m_objectAtAnyIndexedSubscript:(NSUInteger)idx{
    
    if (idx >= self.count) {
        [ZWMessage error:@"-------[]可变数组此对不存在" title:@"温馨提示"];
        NSLog(@"-------[]可变数组此对不存在");
        return @"";
    }
    return [self m_objectAtAnyIndexedSubscript:idx];
}

- (void)replaceAnyObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if ((index < [self count])&&anObject) {
        [self replaceAnyObjectAtIndex:index withObject:anObject];
    }
}
- (void)addAnyObject:(id)anObject{
    if (anObject) {
        [self addAnyObject:anObject];
    }else{
        [ZWMessage Warning:@"数组不能添加空对象" title:@"温馨提示"];
        NSLog(@"-------数组不能添加空对象----");
    }
}
- (void)insertAnyObject:(id)anObject atIndex:(NSUInteger)index{
    if (anObject){
        [self insertAnyObject:anObject atIndex:index];
    }else{
        [ZWMessage Warning:@"数组不能插入空对象" title:@"温馨提示"];
        NSLog(@"-------数组不能插入空对象----");
    }
}
- (id)m_objectAtAnyIndex:(NSUInteger)index{
    if (index >= self.count) {
        [ZWMessage error:@"可变数组此对不存在" title:@"温馨提示"];
        NSLog(@"-------可变数组此对不存在");
        return @"";
    }
    return [self m_objectAtAnyIndex:index];
}
@end
@implementation NSMutableDictionary (Safe)

+ (Method)methodOfSelector:(SEL)selector
{
    return class_getInstanceMethod(NSClassFromString(@"__NSDictionaryM"),selector);
}
- (void)setAnyObject:(id)anObject forKey:(id<NSCopying>)aKey{
    if (anObject&&aKey) {
        [self setAnyObject:anObject forKey:aKey];
    }else{
        [ZWMessage error:@"键值对不能为空" title:@"温馨提示"];
        NSLog(@"-----键值对不能为空---");
    }
}
@end

