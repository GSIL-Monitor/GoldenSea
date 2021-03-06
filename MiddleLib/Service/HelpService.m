//
//  HelpService.m
//  GSGoldenSea
//
//  Created by frank weng on 16/3/3.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "HelpService.h"
#import "HYLog.h"
#import "GSBaseAnalysisMgr.h"

@implementation HelpService

+(NSString*)savePath:(NSString*)fileName
{
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    NSString* serverDir = [NSString stringWithFormat:@"%@/GoldenDoc",paths];
    NSString* filePath = [NSString stringWithFormat:@"%@/GoldenDoc/%@",paths,fileName];

    NSFileManager* defaultManager = [NSFileManager defaultManager];
    BOOL isDirectory;
    if(![defaultManager fileExistsAtPath: serverDir isDirectory:&isDirectory] || !isDirectory)
        [defaultManager createDirectoryAtPath:serverDir withIntermediateDirectories:YES attributes:NULL error:NULL];
    
    
    return filePath;
}


+(BOOL)saveContent:(NSString*)content withName:(NSString*)fileName;
{
    BOOL res;
    NSError* error;
    
    res = [content writeToFile:[HelpService savePath:fileName]
                              atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (!res){
        NSLog(@"%@",error.description);
    }
    
    GSAssert(res);

    
    return res;
}


+ (void)log:(NSString *)format, ... {
    va_list args;
    
    if (format) {
        va_start(args, format);
        
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        
        message = [NSString stringWithFormat:@"%@\n",message];
 
        printf("%s",[message UTF8String]);
        
        [[HYLog shareInstance]logToFile:message];
        
        va_end(args);
    }
}

+(CGFloat)raisingLimitValue:(CGFloat)lastClose
{
    //1.1倍再四舍五入
//    CGFloat val = (int)((lastClose*1.1)*100+0.5)/100.f;
    CGFloat val1 = (int)((int)(lastClose*100+0.5)*1.1+0.5)/100.f;

    return val1;
}

+(CGFloat)downLimitValue:(CGFloat)lastClose
{
    //0.9倍再四舍五入
//    CGFloat val = (int)((lastClose*0.9)*100+0.5)/100.f;
    CGFloat val1 = (int)((int)(lastClose*100+0.5)*0.9+0.5)/100.f;
    return val1;
}


+(BOOL)isLimitUpValue:(CGFloat)TP1Close T0Close:(CGFloat)T0Close
{
    CGFloat val  = [HelpService raisingLimitValue:TP1Close];
    if(fabs((val - T0Close)) < 0.01){
        return YES;
    }
    
    return NO;
}

+(BOOL)isLimitDownValue:(CGFloat)TP1Close T0Close:(CGFloat)T0Close
{
    CGFloat val  = [HelpService downLimitValue:TP1Close];
    if(fabs((val - T0Close)) < 0.01){
        return YES;
    }
    
    return NO;
}


+(NSString*)stkIDWithFile:(NSString*)file;
{
    NSString* stkID = [file lastPathComponent];
    stkID = [stkID stringByDeletingPathExtension];
    stkID = [stkID stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    return stkID;
}


+(long)getCurrDate
{
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:@"yyyyMMdd HH.mm.ss"];
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    NSString * strNowDateTime = [df stringFromDate:currentDate];
    NSString *strNowDate= [strNowDateTime substringToIndex:8];
    
    return [strNowDate intValue];
}


+(long)indexOfValueSmallThan:(CGFloat)theValue Array:(NSArray*)array start:(long)startIndex stop:(long)stopIndex  kT0data:(KDataModel*)kT0Data;
{
    long index = -1;
    
    CGFloat maxpvHi2Op = 0.f;
    
    for(long j=startIndex; j<=stopIndex; j++){
        KDataModel* tempData = [array safeObjectAtIndex:j];
        
        if(tempData && j!=startIndex && j!=stopIndex){
            CGFloat tmp = tempData.high/tempData.open;
            if(tmp > maxpvHi2Op){
                maxpvHi2Op = tmp;
            }
        }
        
        if(tempData &&  (tempData.low <= theValue)){
            
            index = j-startIndex;
//            kT0Data.lowValDayIndex = index;
            
            
            kT0Data.tradeDbg.TBuyData = tempData;
            
            kT0Data.tradeDbg.pvHi2Op = maxpvHi2Op;
            break; //NOTICE: check the case not break!
        }
    }
    
    return index;
}

+(long)indexOfValueGreatThan:(CGFloat)theValue Array:(NSArray*)array start:(long)startIndex stop:(long)stopIndex  kT0data:(KDataModel*)kT0Data;
{
    long index = -1;
    
    
    for(long j=startIndex; j<=stopIndex; j++){
        KDataModel* tempData = [array safeObjectAtIndex:j];
        
        //假如之后无数据，则为空，则会返回-1
        if(tempData.high >= theValue){
            
            index = j-startIndex;
            kT0Data.tradeDbg.TSellDataIndex = j;
            kT0Data.tradeDbg.TSellData = tempData;
            
            break;
        }
    }
    
    return index;
}


+(CGFloat)minValueInArray:(NSArray*)array start:(long)startIndex stop:(long)stopIndex kT0data:(KDataModel*)kT0Data;
{
    CGFloat theLowestValue = 1000.f;
    CGFloat theHighestValue = 0.f;
    
    
    for(long j=startIndex; j<=stopIndex; j++){
        KDataModel* tempData = [array safeObjectAtIndex:j];
//        if(tempData.high >= theHighestValue){
//            theHighestValue = tempData.high;
//            kT0Data.highValDayIndex = j-startIndex;
//        }
        
        if(tempData.low <= theLowestValue){
            theLowestValue = tempData.low;
            kT0Data.tradeDbg.lowValDayIndex = j-startIndex;
        }
    }
    
    return theLowestValue;
}

+(CGFloat)maxHighValueInArray:(NSArray*)array start:(long)startIndex stop:(long)stopIndex kT0data:(KDataModel*)kT0Data;
{
    CGFloat theLowestValue = 1000.f;
    CGFloat theHighestValue = 0.f;
    
    
    for(long j=startIndex; j<=stopIndex; j++){
        KDataModel* tempData = [array safeObjectAtIndex:j];
        if(tempData.high >= theHighestValue){
            theHighestValue = tempData.high;
            kT0Data.tradeDbg.highValDayIndex = j-startIndex;
        }
        
//        if(tempData.low <= theLowestValue){
//            theLowestValue = tempData.low;
//            kT0Data.lowValDayIndex = j-startIndex;
//        }
    }
    
    return theHighestValue;
}

+(CGFloat)maxCloseValueInArray:(NSArray*)array start:(long)startIndex stop:(long)stopIndex kT0data:(KDataModel*)kT0Data;
{
    CGFloat theLowestValue = 1000.f;
    CGFloat theHighestValue = 0.f;
    
    
    for(long j=startIndex; j<=stopIndex; j++){
        KDataModel* tempData = [array safeObjectAtIndex:j];
        if(tempData.close >= theHighestValue){
            theHighestValue = tempData.close;
            kT0Data.tradeDbg.highValDayIndex = j-startIndex;
        }
        
        //        if(tempData.low <= theLowestValue){
        //            theLowestValue = tempData.low;
        //            kT0Data.lowValDayIndex = j-startIndex;
        //        }
    }
    
    return theHighestValue;
}

+(BOOL)isEqual:(CGFloat)f1 with:(CGFloat)f2;
{
    if(fabs(f1-f2)<0.01){
        return YES;
    }
    
    return NO;
}

+(long)findIndexInArray:(NSArray*)array kT0Data:(KDataModel*)kT0Data;
{
    
    BOOL find=NO;
    long units = 8; //8周振幅
    long findIndex = -1;

    
    for(long i=[array count]-1; i>=0; i--){
        KDataModel* tmpData = [array safeObjectAtIndex:i];
        if(!find && ( tmpData.time <= kT0Data.time)){ //means find in the week(or month).
            find = YES;
            if(tmpData.time < kT0Data.time){
                findIndex = i+1;
            }else{ //==
                findIndex = i;
            }
            
            break;
        }
        
//        if(find){
//            if(high < tmpData.high){
//                high = tmpData.high;
//            }
//            
//            if(low > tmpData.low){
//                low = tmpData.low;
//            }
//            units--;
//        }
//        
//        if(units==3){
//            recentLow = low;
//        }
//        
//        if(units <=0){
//            break;
//        }
    }
    
    
    return findIndex;
}




@end
