//
//  NSArrayEX.m
//

#import "NSArrayEX.h"
@implementation NSArray (EX)

- (id)safeObjectAtIndex:(NSUInteger)index
{
    if(self && self.count > 0 && index < self.count)
    {
        id obj = [self objectAtIndex:index];
        if (index >= self.count || [obj isKindOfClass:[NSNull class]])
        {
            obj = nil;
        }
        return obj;
    }
    return nil;
}


- (void)safeAddObject:(id)anObject
{
    if ([self isKindOfClass:[NSMutableArray class]] && nil != anObject) {
        [(NSMutableArray *)self addObject:anObject];
    }
}

- (void)safeInsertObject:(id)anObject atIndex:(NSUInteger)index
{
    if ([self isKindOfClass:[NSMutableArray class]] && nil != anObject && index <= self.count) {
        [(NSMutableArray *)self insertObject:anObject atIndex:index];
    }
}

@end


