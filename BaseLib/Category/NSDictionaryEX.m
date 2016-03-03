//
//  NSDictionaryEX.m
//

#import "NSDictionaryEX.h"

@implementation NSDictionary (EX)

+ (id)dictionaryWithArray:(NSArray *)array{
    NSMutableDictionary * mapDic = [[NSMutableDictionary alloc] init];
    for(NSString * map in array){
        [mapDic setValue:[NSNumber numberWithBool:YES] forKey:map];
    }
    return mapDic;
}



- (BOOL)arrayIsKeys:(NSArray *)array{
    BOOL allIn = YES;
    for(NSString * item in array){
        if(nil == [self valueForKey:item]){//只要出现一个key不存在，说明这个不是allKeys的一个子集
            allIn = NO;
            break;
        }
    }
    return allIn;
}
- (id)safeValueForKey:(NSString *)key{
    
    // 不用valueForKey的原因
    // http://blog.sina.com.cn/s/blog_4aacd7af01012b1o.html
    id value = [self objectForKey:key];
    if([value isKindOfClass:[NSNull class]]){
        value = nil;
    }
    return value;
}

- (id)safeObjectForKey:(NSString *)key{
    id value = [self objectForKey:key];
    if([value isKindOfClass:[NSNull class]]){
        value = nil;
    }
    return value;
}

- (NSString*)skuDictionaryToDescription
{
    NSArray* allKeys = [self allKeys];
    
    NSMutableString* result = [NSMutableString stringWithCapacity:60];
    for (int i = 0; i < [allKeys count]; i ++)
    {
        [result appendFormat:@"%@：%@", allKeys[i], [self objectForKey:allKeys[i]]];
        if (i < [allKeys count] - 1)
        {
            [result appendString:@"，"];
        }
    }
    return result;
}

- (void)safeSetObject:(id)anObject forKey:(id <NSCopying>)aKey
{
    if ([self isKindOfClass:[NSMutableDictionary class]] && nil != aKey && nil != anObject) {
        [(NSMutableDictionary *)self setObject:anObject forKey:aKey];
    }
}

- (void)safeSetValue:(id)value forKey:(NSString *)key
{
    if (key && [key isKindOfClass:[NSString class]]) {
        [self setValue:value forKey:key];
    }
}

@end

/************************************************分割线*****************************************/
