//
//  NSArrayEX.h
//

#import <Foundation/Foundation.h>
@interface NSArray (EX)

- (id)safeObjectAtIndex:(NSUInteger)index;


- (void)safeAddObject:(id)anObject;

- (void)safeInsertObject:(id)anObject atIndex:(NSUInteger)index;

@end

