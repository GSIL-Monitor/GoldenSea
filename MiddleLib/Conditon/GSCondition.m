//
//  GSCondition.m
//  GSGoldenSea
//
//  Created by frank weng on 16/5/23.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "GSCondition.h"

#import "OneDayCondition.h"
#import "GSAnalysisManager.h"


@interface GSCondition(){
    CGFloat _diffOfLowAndClose;
    CGFloat _diffOfHighAndClose;
}

@end

@implementation GSCondition

SINGLETON_GENERATOR(GSCondition, shareManager);


-(id)init
{
    if(self = [super init]){
        _diffOfHighAndClose = 1.5;
        _diffOfLowAndClose = 1.5;

    }
    
    return self;
}


//small T line and close red
-(OneDayCondition*)setCodintionCase1
{
    DVValue* dvValue = [[DVValue alloc]init];
    dvValue.dvClose = 0.5;
    dvValue.dvHigh = dvValue.dvClose;
    dvValue.dvLow = dvValue.dvClose-_diffOfLowAndClose;
    
    OneDayCondition* tp0con = [[OneDayCondition alloc]initWithKDataDVValue:dvValue];
    tp0con.dvRange = 0.8f;
    
    [GSAnalysisManager shareManager].tp1dayCond = tp0con;
    [tp0con logOutCondition];
    
    
    return tp0con;
}

//small T line and close green
-(OneDayCondition*)setCodintionCase2
{
    DVValue* dvValue = [[DVValue alloc]init];
    dvValue.dvClose = -0.5;
    dvValue.dvLow = dvValue.dvClose-_diffOfLowAndClose;
    
    OneDayCondition* tp0con = [[OneDayCondition alloc]initWithKDataDVValue:dvValue];
    tp0con.dvRange = 0.5;
    
    [GSAnalysisManager shareManager].tp1dayCond = tp0con;
    [tp0con logOutCondition];
    
    
    return tp0con;
}


//small opp-T line and close red
-(OneDayCondition*)setCodintionCase3
{
    DVValue* dvValue = [[DVValue alloc]init];
    dvValue.dvClose = 0.5;
    dvValue.dvHigh = dvValue.dvClose+_diffOfHighAndClose;
    
    OneDayCondition* tp0con = [[OneDayCondition alloc]initWithKDataDVValue:dvValue];
    tp0con.dvRange = 0.5;
    
    [GSAnalysisManager shareManager].tp1dayCond = tp0con;
    [tp0con logOutCondition];
    
    
    return tp0con;
}


//small opp-T line and close green
-(OneDayCondition*)setCodintionCase4
{
    DVValue* dvValue = [[DVValue alloc]init];
    dvValue.dvClose = -0.5;
    dvValue.dvHigh = dvValue.dvClose+_diffOfHighAndClose;
    
    OneDayCondition* tp0con = [[OneDayCondition alloc]initWithKDataDVValue:dvValue];
    tp0con.dvRange = 0.5;
    
    [GSAnalysisManager shareManager].tp1dayCond = tp0con;
    [tp0con logOutCondition];
    
    
    return tp0con;
}


@end
