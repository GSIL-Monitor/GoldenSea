//
//  GSDataInit.m
//  GSGoldenSea
//
//  Created by frank weng on 16/5/20.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "GSDataInit.h"

@implementation GSDataInit

SINGLETON_GENERATOR(GSDataInit, shareManager);


-(id)init
{
    if(self = [super init]){
        self.standardDate = 20140101;
    }
    
    return self;
}


-(NSArray*)buildDataWithStkUUID:(NSString*)stkUUID inDir:(NSString*)docsDir
{
      
    NSString* filePath = [self findSourceFileWithStkUUID:stkUUID inDir:docsDir];
    return [self getStkContentArray:filePath];
}


-(NSMutableArray*)findSourcesInDir:(NSString*)docsDir
{
    self.sourceFileArray = [NSMutableArray array];
    
    NSFileManager *localFileManager=[[NSFileManager alloc] init];
    NSDirectoryEnumerator *dirEnum = [localFileManager enumeratorAtPath:docsDir];
    
    NSString *file;
    while ((file = [dirEnum nextObject])) {
        if ([file hasSuffix:@"txt"]) {
            NSString* fullPath = [NSString stringWithFormat:@"%@/%@",docsDir,file];
            [self.sourceFileArray addObject:fullPath];
        }
    }
    
    return self.sourceFileArray;
    
}


-(NSString*)findSourceFileWithStkUUID:(NSString*)stkUUID inDir:(NSString*)docsDir
{
     
    NSFileManager *localFileManager=[[NSFileManager alloc] init];
    NSDirectoryEnumerator *dirEnum = [localFileManager enumeratorAtPath:docsDir];
    
    NSString *file;
    while ((file = [dirEnum nextObject])) {
        if ([file hasSuffix:@"txt"]) { // || [file hasSuffix:@"xls"]
            //            SMLog(@"file:%@",file);
            //            continue;
            
            NSString* fullPath = [NSString stringWithFormat:@"%@/%@",docsDir,file];
            NSRange range = [fullPath rangeOfString:stkUUID];
            if(range.length != 0)
            {
//                self.currStkFilePath = fullPath; //tbd, why servel times?
                return fullPath;
            }
        }
    }
    
    return nil;
    
}


-(NSString*)readFileContent:(NSString*)filePath
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGBK_95);
    
    //    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSError* error;
    NSString* content = [NSString stringWithContentsOfFile:filePath encoding:enc error:&error];
    
    //    NSData* data = [[NSFileManager defaultManager] contentsAtPath:filePath];
    //    content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];;
    
    
    return content;
}


-(NSMutableArray*)getStkContentArray:(NSString*)filePath
{
    
    if(!filePath)
    {
        GSAssert(NO);
        return nil;
    }
    
    self.contentArray = [NSMutableArray array];

    
    long index = 0;
    long lineIndex = 0;
    
    KDataModel* kData;
    NSString* txt = [self readFileContent:filePath] ;
    if(!txt){
        return nil;
    }
    
    NSMutableArray* tmpContentArray = [NSMutableArray array];
    
    NSArray *lines = [txt componentsSeparatedByString:@"\n"];
    for(NSString* oneline in lines){
        
        //        SMLog(@"oneline:%@",oneline);
        
        //skip addtional info
        lineIndex++;
        if(lineIndex <= 2 ){
            continue;
        }
        
        NSArray* tmpArray = [oneline componentsSeparatedByString:@"\t"] ;
        if([tmpArray count] != 7){
            continue;
        }
        
        //        SMLog(@"oneline:%@",oneline);
        
        
        //deal with real data.
        kData = [[KDataModel alloc]init];
        
        for(long i = 0; i<[tmpArray count] ; i++){
            NSString* value = [tmpArray safeObjectAtIndex:i];
            if(!value){
                continue;
            }
            
            switch (i) {
                case 0:
                    //2011/11/02
                    kData.time = value;
                    break;
                    
                case 1:
                    kData.open = [value floatValue];
                    break;
                    
                case 2:
                    kData.high = [value floatValue];
                    break;
                    
                case 3:
                    kData.low = [value floatValue];
                    break;
                    
                case 4:
                    kData.close = [value floatValue];
                    break;
                    
                case 5:
                    kData.volume = [value intValue];
                    break;
                    
                case 6:
                    //no use.
                    break;
                    
                    
                default:
                    break;
            }
        }
        
        if ([self isMeetPeriodCondition:kData]) {
            [tmpContentArray addObject:kData];
        }
        
        
        index++; //just for debug.
    }
    
    self.contentArray = tmpContentArray;
    
//    //calulate value
//    for(long i=6; i<[tmpContentArray count]-3; i++ ){
//
//        KDataModel* kTP1Data  = [tmpContentArray objectAtIndex:(i-1)];
//        KDataModel* kT0Data = [tmpContentArray objectAtIndex:i];
//        KDataModel* kT1Data = [tmpContentArray objectAtIndex:i+1];
//
//        
//        kT0Data.dvTP1 = [self getDVValue:tmpContentArray baseIndex:i-2 destIndex:i-1];
//        kT0Data.dvT0 = [self getDVValue:tmpContentArray baseIndex:i-1 destIndex:i];
//        kT0Data.dvT1 = [self getDVValue:tmpContentArray baseIndex:i destIndex:i+1];
//        kT0Data.dvT2 = [self getDVValue:tmpContentArray baseIndex:i+1 destIndex:i+2];
//
//        
//        //average
//        kT0Data.dvAvgTP1toTP5 = [self getAvgDVValue:5 array:tmpContentArray index:i-1];
//        
//        kT0Data.T1Data = kT1Data;
//        kT0Data.TP1Data = kTP1Data;
//        
//        kT0Data.ma5 = [self getMAValue:5 array:tmpContentArray t0Index:i];
//        kT0Data.ma10 = [self getMAValue:10 array:tmpContentArray t0Index:i];
//        kT0Data.ma20 = [self getMAValue:20 array:tmpContentArray t0Index:i];
//        kT0Data.ma30 = [self getMAValue:30 array:tmpContentArray t0Index:i];
//
//        
//        [self.contentArray addObject:kT0Data];
//    }
    
    return self.contentArray;
}


//get dv value from index and destIndex
-(DVValue*)getDVValue:(NSArray*)tmpContentArray baseIndex:(long)baseIndex destIndex:(long)destIndex
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


-(DVValue*)getAvgDVValue:(NSUInteger)days array:(NSArray*)tmpContentArray index:(long)index
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


-(CGFloat)getMAValue:(NSUInteger)days array:(NSArray*)tmpContentArray t0Index:(long)t0Index
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


-(BOOL)isMeetPeriodCondition:(KDataModel*)kData;
{
    
    int date =  [[kData.time stringByReplacingOccurrencesOfString:@"/" withString:@""]intValue];
    
    //tmp solution
    if(date > self.standardDate){
        return YES;
    }else{
        return NO;
    }
    
}

@end
