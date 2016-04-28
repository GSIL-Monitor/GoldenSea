//
//  OneDayCondition.m
//  GSGoldenSea
//
//  Created by frank weng on 16/4/27.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "OneDayCondition.h"

#define KDV_Range 1.f

@interface OneDayCondition()

@property (strong) KDataModel* kData;
@property (assign) CGFloat baseCloseValue;

@end

@implementation OneDayCondition

-(id)init
{
    self = [super init];
    if(self){
        [self _initData];
    }
    
    return self;
}


-(id)initWithKData:(KDataModel*)kData baseData:(KDataModel*)baseData;
{
    self = [super init];
    if(self){
        [self _initData];

        [self _initData:kData baseCloseValue:baseData.close];

    }
    
    return self;
}


-(id)initWithKData:(KDataModel*)kData baseCloseValue:(CGFloat)baseCloseValue;
{
    self = [super init];
    if(self){
        [self _initData];
        
        [self _initData:kData baseCloseValue:baseCloseValue];
        
    }
    
    return self;
}

-(void)_initData
{
    CGFloat maxValue = 100.f;
    
    self.open_max = maxValue;
    self.open_min = -maxValue;
    
    self.close_max = maxValue;
    self.close_min = -maxValue;
    
    self.high_max = maxValue;
    self.high_min = maxValue;
    
    self.low_max = maxValue;
    self.low_min = -maxValue;
    
    _dvRange = KDV_Range;
}

-(void)_initData:(KDataModel*)kData baseCloseValue:(CGFloat)baseCloseValue;
{
    self.kData = kData;
    self.baseCloseValue = baseCloseValue;
    
    if(kData == nil
       || baseCloseValue >= kInvalidData_Base){
        //do nothing
    }else{
        if (kData.open < kInvalidData_Base) {
            CGFloat dvOpen = (kData.open - baseCloseValue)*100.f/baseCloseValue;
            
            self.open_max = dvOpen+_dvRange;
            self.open_min = dvOpen-_dvRange;
        }
        
        if(kData.high < kInvalidData_Base){
            CGFloat dvHigh = (kData.high - baseCloseValue)*100.f/baseCloseValue;
            self.high_max = dvHigh+_dvRange;
            self.high_min = dvHigh-_dvRange;
        }
        
        if(kData.low < kInvalidData_Base){
            CGFloat dvLow = (kData.low - baseCloseValue)*100.f/baseCloseValue;
            self.low_max = dvLow+_dvRange;
            self.low_min = dvLow-_dvRange;
        }
        
        
        if(kData.close < kInvalidData_Base){
            CGFloat dvClose = (kData.close - baseCloseValue)*100.f/baseCloseValue;
            self.close_max = dvClose+_dvRange;
            self.close_min = dvClose-_dvRange;
        }
        
    }
}

-(void) logOutCondition;
{
    SMLog(@"Condition Open:%.2f,High:%.2f,Low:%.2f,Close:%.2f,  ",self.open_max-_dvRange,self.high_max-_dvRange,self.low_max-_dvRange,self.close_max-_dvRange);

}


-(void)setDvRange:(CGFloat)dvRange
{
    _dvRange = dvRange;
    
    [self _initData:self.kData baseCloseValue:self.baseCloseValue];
}

@end
