//
//  GSFileManager.m
//  GSGoldenSea
//
//  Created by frank weng on 16/4/25.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "GSAnalysisManager.h"
#import "KDataModel.h"
#import "GSLogout.h"
#import "GSDataInit.h"
#import "GSAnalysisManager+ex.h"
#import "GSCondition.h"

@interface GSAnalysisManager ()


@end


@implementation GSAnalysisManager

SINGLETON_GENERATOR(GSAnalysisManager, shareManager);


-(id)init
{
    if(self = [super init]){
    }
    
    return self;
}


-(void)analysisFile:(NSString*)stkUUID inDir:(NSString*)docsDir
{
    //reset content when every time read file.
    [self reset];
    
    
    self.contentArray = [[GSDataInit shareManager] buildDataWithStkUUID:stkUUID inDir:docsDir];
    
    [self analysis];
}

-(void)analysis
{
    self.totalCount=0;
    
    if(! [self isValidDataPassedIn]){
        return;
    }
    
    
//    for(long i=0; i<[self.contentArray count]-1; i++ ){
    
    NSDictionary* passDict;
    for(long i=6; i<[self.contentArray count]-3; i++ ){
        KDataModel* kTP6Data  = [self.contentArray objectAtIndex:(i-6)];
        KDataModel* kTP5Data  = [self.contentArray objectAtIndex:(i-5)];
        KDataModel* kTP4Data  = [self.contentArray objectAtIndex:(i-4)];
        KDataModel* kTP3Data  = [self.contentArray objectAtIndex:(i-3)];
        KDataModel* kTP2Data  = [self.contentArray objectAtIndex:(i-2)];
        KDataModel* kTP1Data  = [self.contentArray objectAtIndex:(i-1)];
        KDataModel* kT0Data = [self.contentArray objectAtIndex:i];
        KDataModel* kT1Data = [self.contentArray objectAtIndex:i+1];
        KDataModel* kT2Data = [self.contentArray objectAtIndex:i+2];

        passDict = @{@"kTP6Data":kTP6Data, @"kTP5Data":kTP5Data, @"kTP4Data":kTP4Data,@"kTP3Data":kTP3Data, @"kTP2Data":kTP2Data, @"kTP1Data":kTP1Data,@"kT0Data":kT0Data, @"kT1Data":kT1Data};
        
        
        //dv condintoon
        if(![self isMeetDVConditon:self.tp1dayCond DVValue:kT0Data.dvTP1]){
            continue;
        }
        
        if(![self isMeetDVConditon:self.t0dayCond DVValue:kT0Data.dvT0]){
            continue;
        }
        
        if(![self isMeetDVConditon:self.t1dayCond DVValue:kT0Data.dvT1]){
            continue;
        }
        
        if(![self isMeetDVConditon:self.tp2dayCond DVValue:kT0Data.dvT2]){
            continue;
        }
        
        
        //shape condition
        if(![self isMeetShapeCond:passDict]){
            continue;
        }
        
        //t0 condition
        if(![self isMeetT0Condition:passDict]){
            continue;
        }
        
        if(![self isMeetAddtionCond:passDict]){
            continue;
        }

        //pt
//        [self dispatchResult2Array:kT0Data buy:kT1Data.close sell:kT2Data.high];
        
        //jh
        [self dispatchResult2Array:kT0Data buy:kT0Data.close sell:kT1Data.high];

//        [self dispatchResult2Array:kT0Data buy:kTP1Data.low sell:kT1Data.close];
        
//        [self dispatchResult2Array:kT0Data buy:kTP1Data.low sell:kT0Data.low];

//        [self dispatchResult2Array:kT0Data buy:kTP1Data.low sell:kT1Data.close];

        
//        [self dispatchResult2Array:kT0Data buy:kT0Data.low sell:kT1Data.high];

//        [self dispatchResult2Array:kT0Data buy:kT0Data.open sell:kT1Data.high];
        
        self.totalCount++;
    }
    
    [[GSLogout shareManager] logOutResult];
    
    
}


-(BOOL)isMeetAddtionCond:(NSDictionary*)passDict
{
    if(!passDict)
        return YES;
    
    KDataModel* kTP2Data  = [passDict objectForKey:@"kTP2Data"];
    KDataModel* kTP1Data  = [passDict objectForKey:@"kTP1Data"];
    KDataModel* kT0Data = [passDict objectForKey:@"kT0Data"];
    KDataModel* kT1Data = [passDict objectForKey:@"kT1Data"];
    
    
    if((kTP2Data.open > kTP2Data.close)
        &&(kTP1Data.open > kTP1Data.close)
       &&(kT0Data.open < kT0Data.close)){
        if(kTP2Data.dvT0.dvClose > -2.f
           && kTP1Data.dvT0.dvClose > -2.f
           && fabsf(kT0Data.open - kT0Data.close) < 0.15f
           && kT0Data.dvT0.dvClose < 1.f)
        return YES;
    }
    
//    if((kT0Data.low - kT1Data.low > -0.1)
//    && (kT0Data.close - kT0Data.low < 0.1)){
//        return YES;
//    }
    
//    if(kT0Data.close - kT0Data.low < 0.1){
//        return YES;
//    }

    //        CGFloat wantBuy = kT0Data.close*0.97;
    //        if(wantBuy < kT1Data.low){
    //            continue;
    //        }
    //
//    if(kT1Data.dvT0.dvClose - kT1Data.dvT0.dvLow > 1.f){
//        return NO;
//    }
//    
//    if(!(kT1Data.dvT0.dvLow < -1 && kT1Data.dvT0.dvLow > -2)){
//        return NO;
//    }
    
    return NO;
}




#pragma mark - condition


-(BOOL)isMeetShapeCond:(NSDictionary*)passDict
{
    if(!passDict)
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
            
            
        default:
            return YES;
            break;
    }
    
    return NO;
}


-(BOOL)isMeetT0Condition:(NSDictionary*)passDict
{
    if(!passDict)
        return YES;

    KDataModel* kT0Data = [passDict objectForKey:@"kT0Data"];
    
    switch ([GSCondition shareManager].t0Cond) {
        case T0Condition_Up:
        {
            if(kT0Data.open < kT0Data.close){
                return YES;
            }
        }
            break;
            
        case T0Condition_Down:
        {
            if(kT0Data.open > kT0Data.close){
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


-(BOOL)isMeetDVConditon:(OneDayCondition*)cond DVValue:(DVValue*)dv;
{
    if(!cond){
        return YES;
    }
    
    
    if(!(dv.dvOpen > cond.open_min
         && dv.dvOpen < cond.open_max)){
        return NO;
    }
    
    if(!(dv.dvHigh > cond.high_min
         && dv.dvHigh < cond.high_max)){
        return NO;
    }
    
    if(!(dv.dvLow > cond.low_min
         && dv.dvLow < cond.low_max)){
        return NO;
    }
    
    if(!(dv.dvClose > cond.close_min
         && dv.dvClose < cond.close_max)){
        return NO;
    }
    
    return YES;
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



@end
