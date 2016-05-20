//
//  NSObject+Addtiion.m
//
//
//  Created by l on 16/5/20.
//  Copyright © 2016年 l. All rights reserved.
//

#import "NSObject+Addtiion.h"

@implementation NSObject (Addtiion)

@end

@interface NSObject (MRC)

- (NSInteger)objc_retainCount;

@end

@implementation NSObject (MRC)

- (NSInteger)objc_retainCount {
    return [[self valueForKey:@"retainCount"] unsignedIntegerValue];
}

@end

typedef id (^TranformWeakObject)(void);

TranformWeakObject tranformWeakReference(id object) {
    __weak id weakref = object;
    return ^{
        return weakref;
    };
}

id returnWeakObject(TranformWeakObject tranform) {
    return tranform ? tranform() : nil;
}

@interface NSMutableDictionary (WeakDic)

@end

@implementation NSMutableDictionary (WeakDic)

- (void)weak_setObject:(id)anObject forKey:(NSString *)aKey {
    [self setObject:tranformWeakReference(anObject) forKey:aKey];
}

- (void)weak_setObjectWithDictionary:(NSDictionary *)dic {
    for (NSString *key in dic.allKeys) {
        [self setObject:tranformWeakReference(dic[key]) forKey:key];
    }
}

- (id)weak_getObjectForKey:(NSString *)key {
    return returnWeakObject(self[key]);
}

@end

@interface NSMutableArray (WeakArr)

@end

@implementation NSMutableArray (WeakArr)

- (void)weak_addObject:(id)anyObject {
    
    [self addObject:tranformWeakReference(anyObject)];
}

- (id)weak_getObjectAtIndex:(NSInteger)index {
    
    return returnWeakObject(self[index]);
}

@end
