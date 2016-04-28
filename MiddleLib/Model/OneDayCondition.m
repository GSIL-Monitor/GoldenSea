//
//  OneDayCondition.m
//  GSGoldenSea
//
//  Created by frank weng on 16/4/27.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "OneDayCondition.h"

#define KDV_Range 1.f

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

        if(kData == nil
           || baseData.close > kInvalidData_Base){
            //do nothing
        }else{
            if (kData.open < kInvalidData_Base) {
                CGFloat dvOpen = (kData.open - baseData.close)*100.f/baseData.close;
                
                self.open_max = dvOpen+KDV_Range;
                self.open_min = dvOpen-KDV_Range;
            }
            
            if(kData.high < kInvalidData_Base){
                CGFloat dvHigh = (kData.high - baseData.close)*100.f/baseData.close;
                self.high_max = dvHigh+KDV_Range;
                self.high_min = dvHigh-KDV_Range;
            }
            
            if(kData.low < kInvalidData_Base){
                CGFloat dvLow = (kData.low - baseData.close)*100.f/baseData.close;
                self.low_max = dvLow+KDV_Range;
                self.low_min = dvLow-KDV_Range;
            }
            
            
            if(kData.close < kInvalidData_Base){
                CGFloat dvClose = (kData.close - baseData.close)*100.f/baseData.close;
                self.close_max = dvClose+KDV_Range;
                self.close_min = dvClose-KDV_Range;
            }
            
        }
        
    }
    
    return self;
}


-(id)initWithKData:(KDataModel*)kData baseCloseValue:(CGFloat)baseCloseValue;
{
    self = [super init];
    if(self){
        [self _initData];
        
        if(kData == nil
           || baseCloseValue > kInvalidData_Base){
            //do nothing
        }else{
            if (kData.open < kInvalidData_Base) {
                CGFloat dvOpen = (kData.open - baseCloseValue)*100.f/baseCloseValue;
                
                self.open_max = dvOpen+KDV_Range;
                self.open_min = dvOpen-KDV_Range;
            }
            
            if(kData.high < kInvalidData_Base){
                CGFloat dvHigh = (kData.high - baseCloseValue)*100.f/baseCloseValue;
                self.high_max = dvHigh+KDV_Range;
                self.high_min = dvHigh-KDV_Range;
            }
            
            if(kData.low < kInvalidData_Base){
                CGFloat dvLow = (kData.low - baseCloseValue)*100.f/baseCloseValue;
                self.low_max = dvLow+KDV_Range;
                self.low_min = dvLow-KDV_Range;
            }
            
            
            if(kData.close < kInvalidData_Base){
                CGFloat dvClose = (kData.close - baseCloseValue)*100.f/baseCloseValue;
                self.close_max = dvClose+KDV_Range;
                self.close_min = dvClose-KDV_Range;
            }
            
        }
        
    }
    
    return self;
}

-(void)_initData
{
    self.open_max = 11.f;
    self.open_min = -11.f;
    
    self.close_max = 11.f;
    self.close_min = -11.f;
    
    self.high_max = 11.f;
    self.high_min = -11.f;
    
    self.low_max = 11.f;
    self.low_min = -11.f;
}

@end
