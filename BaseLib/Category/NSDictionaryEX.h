//
//  NSDictionaryEX.h
//

#import <Foundation/Foundation.h>

@interface NSDictionary (EX)

+ (id)dictionaryWithArray:(NSArray *)array;
- (BOOL)arrayIsKeys:(NSArray *)array;

- (id)safeValueForKey:(NSString *)key;

- (id)safeObjectForKey:(NSString *)key;

- (NSString*)skuDictionaryToDescription;


- (void)safeSetObject:(id)anObject forKey:(id <NSCopying>)aKey;

- (void)safeSetValue:(id)value forKey:(NSString *)key;

@end

/************************************************分割线*****************************************/

