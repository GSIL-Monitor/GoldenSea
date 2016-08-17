//
//  HelpService.m
//  GSGoldenSea
//
//  Created by frank weng on 16/3/3.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "HelpService.h"
#import "HYLog.h"

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
        
        [[HYLog shareManager]logToFile:message];
        
        va_end(args);
    }
}

+(CGFloat)raisingLimitValue:(CGFloat)lastClose
{
    //1.1倍再四舍五入
    CGFloat val = (int)((lastClose*1.1)*100+0.5)/100.f;
    return val;
}

+(CGFloat)downLimitValue:(CGFloat)lastClose
{
    //0.9倍再四舍五入
    CGFloat val = (int)((lastClose*0.9)*100+0.5)/100.f;
    return val;
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


+(long)indexOfValueSmallThan:(CGFloat)theValue Array:(NSArray*)array start:(long)startIndex stop:(long)stopIndex  kT0data:(KDataModel*)kT0Data;
{
    long index = -1;
    
    
    
    for(long j=startIndex; j<=stopIndex; j++){
        KDataModel* tempData = [array objectAtIndex:j];
        
        if(tempData.low <= theValue){
            
            index = j-startIndex;
        }
    }
    
    return index;
}

+(long)indexOfValueGreatThan:(CGFloat)theValue Array:(NSArray*)array start:(long)startIndex stop:(long)stopIndex  kT0data:(KDataModel*)kT0Data;
{
    long index = -1;
    
    
    
    for(long j=startIndex; j<=stopIndex; j++){
        KDataModel* tempData = [array objectAtIndex:j];
        
        if(tempData.high >= theValue){
            
            index = j-startIndex;
        }
    }
    
    return index;
}


+(CGFloat)minValueInArray:(NSArray*)array start:(long)startIndex stop:(long)stopIndex kT0data:(KDataModel*)kT0Data;
{
    CGFloat theLowestValue = 1000.f;
    CGFloat theHighestValue = 0.f;
    
    
    for(long j=startIndex; j<=stopIndex; j++){
        KDataModel* tempData = [array objectAtIndex:j];
//        if(tempData.high >= theHighestValue){
//            theHighestValue = tempData.high;
//            kT0Data.highValDayIndex = j-startIndex;
//        }
        
        if(tempData.low <= theLowestValue){
            theLowestValue = tempData.low;
            kT0Data.lowValDayIndex = j-startIndex;
        }
    }
    
    return theLowestValue;
}

+(CGFloat)maxValueInArray:(NSArray*)array start:(long)startIndex stop:(long)stopIndex kT0data:(KDataModel*)kT0Data;
{
    CGFloat theLowestValue = 1000.f;
    CGFloat theHighestValue = 0.f;
    
    
    for(long j=startIndex; j<=stopIndex; j++){
        KDataModel* tempData = [array objectAtIndex:j];
        if(tempData.high >= theHighestValue){
            theHighestValue = tempData.high;
            kT0Data.highValDayIndex = j-startIndex;
        }
        
//        if(tempData.low <= theLowestValue){
//            theLowestValue = tempData.low;
//            kT0Data.lowValDayIndex = j-startIndex;
//        }
    }
    
    return theHighestValue;
}



@end
