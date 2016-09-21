//
//  UtilData.h
//  GSGoldenSea
//
//  Created by frank weng on 16/9/21.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilData : NSObject

+(BOOL)isSimlarValue:(CGFloat)destValue baseValue:(CGFloat)baseValue Offset:(CGFloat)offset;


+(CGFloat)getDVValueWithBaseValue:(CGFloat)baseValue destValue:(CGFloat)destValue;

+(DVValue*)getDVValue:(NSArray*)tmpContentArray baseIndex:(long)baseIndex destIndex:(long)destIndex;
+(DVValue*)getAvgDVValue:(NSUInteger)days array:(NSArray*)tmpContentArray index:(long)index;
+(CGFloat)getMAValue:(NSUInteger)days array:(NSArray*)tmpContentArray t0Index:(long)t0Index;

@end
