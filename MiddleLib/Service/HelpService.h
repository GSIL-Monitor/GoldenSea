//
//  HelpService.h
//  GSGoldenSea
//
//  Created by frank weng on 16/3/3.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KDataModel.h"


#define SMLog(frmt, ...) \
[HelpService log: (frmt), ## __VA_ARGS__]

@interface HelpService : NSObject
+(NSString*)savePath:(NSString*)fileName;
+(BOOL)saveContent:(NSString*)content withName:(NSString*)fileName;

//+ (void)log:(BOOL)asynchronous
//     format:(NSString *)format, ...

+ (void)log:(NSString *)format, ... ;


+(BOOL)isLimitUpValue:(CGFloat)TP1Close T0Close:(CGFloat)T0Close;
+(BOOL)isLimitDownValue:(CGFloat)TP1Close T0Close:(CGFloat)T0Close;

+(NSString*)stkIDWithFile:(NSString*)file;


+(CGFloat)minValueInArray:(NSArray*)array start:(long)startIndex stop:(long)stopIndex kT0data:(KDataModel*)kT0Data;
+(CGFloat)maxCloseValueInArray:(NSArray*)array start:(long)startIndex stop:(long)stopIndex kT0data:(KDataModel*)kT0Data;
+(CGFloat)maxHighValueInArray:(NSArray*)array start:(long)startIndex stop:(long)stopIndex kT0data:(KDataModel*)kT0Data;

//find the index of first day(from start to stop) which value is samll than the give "theValue"
//if not find, return -1
+(long)indexOfValueSmallThan:(CGFloat)theValue Array:(NSArray*)array start:(long)startIndex stop:(long)stopIndex  kT0data:(KDataModel*)kT0Data;

//simaler as indexOfValueSmallThan, just this is great than.
+(long)indexOfValueGreatThan:(CGFloat)theValue Array:(NSArray*)array start:(long)startIndex stop:(long)stopIndex  kT0data:(KDataModel*)kT0Data;


@end
