//
//  OneDayCondition.h
//  GSGoldenSea
//
//  Created by frank weng on 16/4/27.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KDataModel.h"

@interface OneDayCondition : NSObject

@property (assign) CGFloat open_min;
@property (assign) CGFloat open_max;

@property (assign) CGFloat close_min; //the min value, close vs open, (percent)
@property (assign) CGFloat close_max;

@property (assign) CGFloat high_min;
@property (assign) CGFloat high_max;

@property (assign) CGFloat low_min;
@property (assign) CGFloat low_max;


@property (assign,nonatomic) CGFloat dvRange;


+(void)calulateDVValue:(KDataModel*)kData baseCloseValue:(CGFloat)baseCloseValue;


-(id)initWithKData:(KDataModel*)kData baseData:(KDataModel*)baseData;


-(id)initWithKData:(KDataModel*)kData baseCloseValue:(CGFloat)baseCloseValue;


-(id)initWithKDataDVValue:(DVValue*)baseDVValue;


-(void) logOutCondition;

@end
