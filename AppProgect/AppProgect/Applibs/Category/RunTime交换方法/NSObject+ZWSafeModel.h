//
//  NSObject+ZWSafeModel.h
//  Kuaizhu2
//
//  Created by step_zhang on 2019/11/29.
//  Copyright © 2019 step_zhang. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ZWSafeModel)
+ (void)safe;
+ (void)exchangeOriginalMethod:(Method)originalMethod withNewMethod:(Method)newMethod;
@end
@interface NSArray (Safe)
+ (Method)__NSArrayI:(SEL)selector;
+ (Method)__NSArray0:(SEL)selector;
+ (Method)__NSSingleObjectArrayI:(SEL)selector;
+ (Method)__NSArrayM:(SEL)selector;


- (id)__NSArrayIobjectAtIndex:(NSUInteger)index;
- (id)__NSArray0objectAtIndex:(NSUInteger)index;

- (id)__NSSingleObjectArrayIobjectAtIndex:(NSUInteger)index;
- (id)objectAtAnyIndexedSubscript:(NSUInteger)idx;

- (void)replaceAnyObjectAtIndex:(NSUInteger)index withObject:(id)anObject;
- (void)addAnyObject:(id)anObject;
- (void)insertAnyObject:(id)anObject atIndex:(NSUInteger)index;
- (id)m_objectAtAnyIndex:(NSUInteger)index;
- (id)m_objectAtAnyIndexedSubscript:(NSUInteger)idx;

@end
@interface NSMutableDictionary (Safe)
+ (Method)methodOfSelector:(SEL)selector;
- (void)setAnyObject:(id)anObject forKey:(id<NSCopying>)aKey;
@end

NS_ASSUME_NONNULL_END
