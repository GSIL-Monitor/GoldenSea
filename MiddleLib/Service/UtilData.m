//
//  UtilData.m
//  GSGoldenSea
//
//  Created by frank weng on 16/9/21.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "UtilData.h"

@implementation UtilData

#if 0
#pragma mark - tech data
//macd, kdj
//di(demand index),
+(CGFloat)getDI:(KDataModel*)kData
{
    CGFloat val = (kData.high+kData.low+kData.close*2)/4;
    return val;
}

//平滑系数
+(CGFloat)getSL:(long)days
{
    CGFloat val;
    
    val = 2.0/(days+1);
    
    return val;
}

+(void)setEMA:(NSArray*)tmpContentArray baseIndex:(long)baseIndex  fstdays:(long)fstdays snddays:(long)snddays
{
    CGFloat val;
    
    KDataModel* kT0Data = [tmpContentArray safeObjectAtIndex:baseIndex];
    if(!kT0Data){
        return;
    }
    
    if(baseIndex == 0){ //第一天的EMA取di值
        kT0Data.ema1 = [UtilData getDI:kT0Data];
        kT0Data.ema2 = kT0Data.ema1;
        return ;
    }
    
    KDataModel* kTP1Data = [tmpContentArray objectAtIndex:(baseIndex-1)];
    
    CGFloat lastDayEMA = kTP1Data.ema1; //[UtilData getEMA:tmpContentArray baseIndex:baseIndex days:tmpDays];
    kT0Data.ema1 = [UtilData getSL:fstdays]*([UtilData getDI:kT0Data]-lastDayEMA)+lastDayEMA;
    lastDayEMA = kTP1Data.ema2;
    kT0Data.ema2 = [UtilData getSL:snddays]*([UtilData getDI:kT0Data]-lastDayEMA)+lastDayEMA;
    
    
}

//such as:fst-12, snd-26
+(CGFloat)getDiff:(NSArray*)tmpContentArray baseIndex:(long)baseIndex  fstdays:(long)fstdays snddays:(long)snddays
{
    CGFloat val;
    
    [UtilData setEMA:tmpContentArray baseIndex:baseIndex fstdays:fstdays snddays:snddays];
    
    KDataModel* kT0Data = [tmpContentArray safeObjectAtIndex:(baseIndex)];

    val = kT0Data.ema1 - kT0Data.ema2;

    return val;
}


/*
 EMA（12）= 前一日EMA（12）×11/13＋今日收盘价×2/13
 EMA（26）= 前一日EMA（26）×25/27＋今日收盘价×2/27
 DIFF=今日EMA（12）- 今日EMA（26）
 DEA（MACD）= 前一日DEA×8/10＋今日DIF×2/10
 BAR=2×(DIFF－DEA)
 */
+(void)setMACD:(NSArray*)tmpContentArray baseIndex:(long)baseIndex  fstdays:(long)fstdays snddays:(long)snddays trddays:(long)trddays
{
    KDataModel* kT0Data = [tmpContentArray objectAtIndex:(baseIndex)];

    
    if(baseIndex < trddays){ //9日之内
        CGFloat totaldiff = 0.f;
        for (long i=0; i<trddays; i++) {
            totaldiff += [UtilData getDiff:tmpContentArray baseIndex:i fstdays:fstdays snddays:snddays];
        }
        kT0Data.macd = totaldiff/trddays;
    }else{
        KDataModel* kTP1Data = [tmpContentArray objectAtIndex:(baseIndex-1)];
        CGFloat todayDiff = [UtilData getDiff:tmpContentArray baseIndex:baseIndex fstdays:fstdays snddays:snddays];
        kT0Data.macd = kTP1Data.macd*(trddays-1)/(trddays+1) + todayDiff*2/(trddays+1);
    }
    
}


//xueqiu: 12,26,9
//baseIndex: 基准日(周..)
+(void)setMACDBar:(NSArray*)tmpContentArray baseIndex:(long)baseIndex fstdays:(long)fstdays snddays:(long)snddays trddays:(long)trddays
{
    return; //don't use macd value.
    
    //bar = 2*(diff-dea);

    
    KDataModel* kT0Data = [tmpContentArray objectAtIndex:(baseIndex)];
    CGFloat todayDiff = [UtilData getDiff:tmpContentArray baseIndex:baseIndex fstdays:fstdays snddays:snddays];
    
    [UtilData setMACD:tmpContentArray baseIndex:baseIndex fstdays:fstdays snddays:snddays trddays:trddays];
    
    kT0Data.macdbar = 2.0*(todayDiff-kT0Data.macd);
    
}
#endif


#pragma mark - util
+(CGFloat)getDVValueWithBaseValue:(CGFloat)baseValue destValue:(CGFloat)destValue;
{
    CGFloat val = 0.f;
    
    val = (destValue-baseValue)*100.f/baseValue;
    
    return val;
}


//get dv value from index and destIndex
+(DVValue*)getDVValue:(NSArray*)tmpContentArray baseIndex:(long)baseIndex destIndex:(long)destIndex
{
    if(!tmpContentArray || baseIndex<0 || destIndex<0){
        return nil;
    }
    
    
    
    KDataModel* kBaseTData  = [tmpContentArray objectAtIndex:baseIndex];
    KDataModel* kDestTData  = [tmpContentArray objectAtIndex:destIndex];
    DVValue* dvValue = [[DVValue alloc]init];
    
    
    
    dvValue.dvOpen = (kDestTData.open-kBaseTData.close)*100.f/kBaseTData.close;
    dvValue.dvClose = (kDestTData.close-kBaseTData.close)*100.f/kBaseTData.close;
    dvValue.dvHigh = (kDestTData.high-kBaseTData.close)*100.f/kBaseTData.close;
    dvValue.dvLow = (kDestTData.low-kBaseTData.close)*100.f/kBaseTData.close;
    
    return dvValue;
}


+(DVValue*)getAvgDVValue:(NSUInteger)days array:(NSArray*)tmpContentArray index:(long)index
{
    if(days == 0 || !tmpContentArray || index<0){
        return nil;
    }
    
    
    CGFloat totalOpenValue = 0.f;
    CGFloat totalCloseValue = 0.f;
    CGFloat totalHighValue = 0.f;
    CGFloat totalLowValue = 0.f;
    
    NSUInteger realDays = 0;
    
    KDataModel* kBaseTData  = [tmpContentArray objectAtIndex:index];
    DVValue* dvAvgValue = [[DVValue alloc]init];
    
    for(long i = index; i>=0; i--){
        KDataModel* kData  = [tmpContentArray objectAtIndex:i];
        totalOpenValue += kData.open;
        totalCloseValue += kData.close;
        totalHighValue += kData.high;
        totalLowValue += kData.low;
        
        realDays++;
        
        if(realDays == days){
            break;
        }
    }
    
    dvAvgValue.dvOpen = (totalOpenValue-realDays*kBaseTData.close)*100.f/kBaseTData.close;
    dvAvgValue.dvClose = (totalCloseValue-realDays*kBaseTData.close)*100.f/kBaseTData.close;
    dvAvgValue.dvHigh = (totalHighValue-realDays*kBaseTData.close)*100.f/kBaseTData.close;
    dvAvgValue.dvLow = (totalLowValue-realDays*kBaseTData.close)*100.f/kBaseTData.close;
    
    return dvAvgValue;
}


+(CGFloat)getMAValue:(NSUInteger)days array:(NSArray*)tmpContentArray t0Index:(long)t0Index
{
    if(days == 0 || !tmpContentArray){
        return 0.f;
    }
    
    CGFloat maValue = 0.f;
    CGFloat totalValue = 0.f;
    NSUInteger realDays = 0;
    
    for(long i = t0Index; i>=0; i--){
        KDataModel* kData  = [tmpContentArray objectAtIndex:i];
        totalValue += kData.close;
        realDays++;
        
        if(realDays == days){
            break;
        }
    }
    
    maValue = totalValue/realDays;
    
    return maValue;
}

+(BOOL)isSimlarValue:(CGFloat)destValue baseValue:(CGFloat)baseValue Offset:(CGFloat)offset;
{
    CGFloat dv = (destValue-baseValue)*100.f/baseValue;
    if(fabs(dv) > offset){
        return NO;
    }else{
        return YES;
    }
}


+(CGFloat)getDegree:(CGFloat)duibian lingBian:(CGFloat)lingbian
{
    //    CGFloat duibian , lingbian;
    //角度=对边/邻边
    CGFloat td = atan2f(duibian, lingbian);   //atan2f(4, 6.92);
    return td*180/3.1415926; //atan等三角函数是弧度，需要转换成角度
}

+(CGFloat)getSlopeMAValue:(NSUInteger)days array:(NSArray*)tmpContentArray t0Index:(long)t0Index
{
    if(days == 0 || !tmpContentArray){
        return 0.f;
    }
    
    CGFloat slopemaValue = 0.f;
    KDataModel* kT0Data  = [tmpContentArray objectAtIndex:t0Index];
    KDataModel* kSlopeStartData;
    NSUInteger realDays = 0;
    
    //简单以两点之间直线计算
    if(t0Index <= days){
        realDays = t0Index;
    }else{
        realDays = days;
    }
    
    kSlopeStartData = [tmpContentArray objectAtIndex:t0Index-realDays];
    if(kSlopeStartData.ma30 < 0.5f){
        return 0.f;
    }
    CGFloat dvValue = [self getDVValueWithBaseValue:kSlopeStartData.ma30 destValue:kT0Data.ma30];
    CGFloat diff = kT0Data.ma30 - kSlopeStartData.ma30;
    CGFloat roc = dvValue*realDays;
    //    dvValue = kT0Data.ma30-kSlopeStartData.ma30;
    
    //need factor number fix?
    slopemaValue = atanf((dvValue+100)/realDays); //;[self getDegree:dvValue lingBian:realDays];
    slopemaValue = atanf(dvValue)*180/3.1415926;
    
    //    SMLog(@"%d: roc:%.2f, slopemaValue:%.2f",kT0Data.time,dvValue,slopemaValue);
    
    
    //
    //    NSUInteger realDays = 0;
    //    CGFloat minMAValue = kInvalidData_Base, maxMAValue=0.f;
    //    NSUInteger minDay = 0, maxDay = 0;
    //
    //    for(long i = t0Index; i>=0; i--){
    //        KDataModel* kData  = [tmpContentArray objectAtIndex:i];
    //        CGFloat tmpMAVal = kData.ma30;
    //
    //        if(tmpMAVal > maxMAValue){
    //            maxMAValue = tmpMAVal;
    //            maxDay = i;
    //        }
    //
    //        if(tmpMAVal < minMAValue){
    //            minMAValue = tmpMAVal;
    //            minDay = i;
    //        }
    //
    //        realDays++;
    //        if(realDays == days){
    //            break;
    //        }
    //    }
    //
    ////    //以中间为准
    ////    if((t0Index-minDay) > realDays/2){
    ////
    ////    }
    //
    //
    //    if(minDay < maxDay){ //minday在maxDay之前,采用maxday
    //        kSlopeStartData = [tmpContentArray objectAtIndex:t0Index-maxDay];
    //        slopemaValue = (kT0Data.ma30 - kSlopeStartData.ma30)/(t0Index-maxDay);
    //    }
    
    
    return slopemaValue;
}




@end
