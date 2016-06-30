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



-(BOOL)isMeetShapeCond:(NSDictionary*)passDict
{
    if(!passDict || [GSCondition shareManager].shapeCond==ShapeCondition_Null)
        return YES;
    
    
    KDataModel* kTP6Data  = [passDict objectForKey:@"kTP6Data"];
    KDataModel* kTP5Data  = [passDict objectForKey:@"kTP5Data"];
    KDataModel* kTP4Data  = [passDict objectForKey:@"kTP4Data"];
    KDataModel* kTP3Data  = [passDict objectForKey:@"kTP3Data"];
    KDataModel* kTP2Data  = [passDict objectForKey:@"kTP2Data"];
    KDataModel* kTP1Data  = [passDict objectForKey:@"kTP1Data"];
    KDataModel* kT0Data = [passDict objectForKey:@"kT0Data"];
    KDataModel* kT1Data = [passDict objectForKey:@"kT1Data"];
    
    
    switch ([GSCondition shareManager].shapeCond) {
        case ShapeCondition_WaiBaoRi_Down:
        {
            if(kT0Data.high > kTP1Data.high
               && kT0Data.low < kTP1Data.low
               && kT0Data.open > kT0Data.close){
                return YES;
            }
        }
            
            break;
            
        case ShapeCondition_WaiBaoRi_Up:
        {
            if(kT0Data.high > kTP1Data.high
               && kT0Data.low < kTP1Data.low
               && kT0Data.open < kT0Data.close){
                return YES;
            }
        }
            
            break;
            
            
        case ShapeCondition_FanZhuanRi_Down:
        {
            if(kT0Data.open < kTP1Data.low){
                if(kT0Data.high > kTP1Data.low
                   //                   && GetDVValue(kT0Data.close, kT0Data.low)>2.f
                   //                   && kT1Data.dvT0.dvOpen > 0.2f
                   && kT1Data.low < kTP1Data.low
                   ){
                    return YES;
                }
            }
        }
            
            break;
            
        case ShapeCondition_FanZhuanRi_Up:
        {
            if(kT0Data.open > kTP1Data.high){
                return YES;
            }
        }
            break;
            
            
        case ShapeCondition_HengPan_6Day:
        {
            long hengpanDays = [self isHengPan:kTP6Data base:kT0Data] + [self isHengPan:kTP5Data base:kT0Data] + [self isHengPan:kTP4Data base:kT0Data]
            +[self isHengPan:kTP3Data base:kT0Data] + [self isHengPan:kTP2Data base:kT0Data] + [self isHengPan:kTP1Data base:kT0Data];
            if(hengpanDays == 5){
                return YES;
            }
        }
            break;
            
            
        case ShapeCondition_ZhengDang:
        {
            
        }
            break;
            
            
        case ShapeCondition_UpShadow:
        {
            if(kT0Data.dvT0.dvHigh - kT0Data.dvT0.dvClose > 2.5f){
                return YES;
            }
        }
            break;
            
        case ShapeCondition_DownShadow:
        {
            if(kT0Data.dvT0.dvLow - kT0Data.dvT0.dvClose < -2.5f){
                return YES;
            }
        }
            break;
            
        case ShapeCondition_MA5UpMA10:
        {
            if((kT0Data.ma5 - kT0Data.ma10 >= 0.f)
               &&(kTP1Data.ma5 - kTP1Data.ma10 < 0.f)){
//                SMLog(@"kT0Data.ma5:");
                return YES;
            }
        }
            break;
            
        default:
            return YES;
            break;
    }
    
    return NO;
}


-(int)isHengPan:(KDataModel*)kData base:(KDataModel*)kBaseData
{
    CGFloat baseValue = (kBaseData.high+kBaseData.low)/2;
    
    CGFloat waveDVValue = 2.f;
    
    if(fabs((kData.high-baseValue)*100/baseValue) < waveDVValue
       && fabs((kData.low-baseValue)*100/baseValue) < waveDVValue){
        return 1;
    }
    
    return 0;
}

-(CGFloat)buyZhenDangValue:(KDataModel*)kData
{
    return  kData.high - kData.open;
    
//    return 0.f;
}

-(CGFloat)sellZhenDangValue:(KDataModel*)kData
{
    return  kData.low - kData.open;

//    return 0.f;
}


//small T line and close red
-(OneDayCondition*)setCodintionCase1
{
    DVValue* dvValue = [[DVValue alloc]init];
    dvValue.dvClose = 0.5;
    dvValue.dvHigh = dvValue.dvClose;
    dvValue.dvLow = dvValue.dvClose-_diffOfLowAndClose;
    
    OneDayCondition* theCond = [[OneDayCondition alloc]initWithKDataDVValue:dvValue];
    theCond.dvRange = 0.8f;
    
    [GSAnalysisManager shareManager].t0dayCond = theCond;
    [theCond logOutCondition];
    
    
    return theCond;
}

//small T line and close green
-(OneDayCondition*)setCodintionCase2
{
    DVValue* dvValue = [[DVValue alloc]init];
    dvValue.dvClose = -0.5;
    dvValue.dvLow = dvValue.dvClose-_diffOfLowAndClose;
    
    OneDayCondition* theCond = [[OneDayCondition alloc]initWithKDataDVValue:dvValue];
    theCond.dvRange = 0.5;
    
    [GSAnalysisManager shareManager].t0dayCond = theCond;
    [theCond logOutCondition];
    
    
    return theCond;
}


//small opp-T line and close red
-(OneDayCondition*)setCodintionCase3
{
    DVValue* dvValue = [[DVValue alloc]init];
    dvValue.dvClose = 0.5;
    dvValue.dvHigh = dvValue.dvClose+_diffOfHighAndClose;
    
    OneDayCondition* theCond = [[OneDayCondition alloc]initWithKDataDVValue:dvValue];
    theCond.dvRange = 0.5;
    
    [GSAnalysisManager shareManager].t0dayCond = theCond;
    [theCond logOutCondition];
    
    
    return theCond;
}


//small opp-T line and close green
-(OneDayCondition*)setCodintionCase4
{
    DVValue* dvValue = [[DVValue alloc]init];
    dvValue.dvClose = -0.5;
    dvValue.dvHigh = dvValue.dvClose+_diffOfHighAndClose;
    
    OneDayCondition* theCond = [[OneDayCondition alloc]initWithKDataDVValue:dvValue];
    theCond.dvRange = 0.5;
    
    [GSAnalysisManager shareManager].t0dayCond = theCond;
    [theCond logOutCondition];
    
    
    return theCond;
}


@end
