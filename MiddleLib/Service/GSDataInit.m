//
//  GSDataInit.m
//  GSGoldenSea
//
//  Created by frank weng on 16/5/20.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "GSDataInit.h"
#import "KDataModel.h"

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
    //reset.
    self.currStkUUID = nil;
    self.currStkFilePath = nil;
    self.contentArray = [NSMutableArray array];

    
    [self findSourceFileWithStkUUID:stkUUID inDir:docsDir];
    return [self getStkContentArray];
}


-(NSString*)findSourceFileWithStkUUID:(NSString*)stkUUID inDir:(NSString*)docsDir
{
 
    self.currStkUUID = stkUUID;
    
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
//            if([file containsString:stkUUID])
            {
                self.currStkFilePath = fullPath; //tbd, why servel times?
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


-(NSMutableArray*)getStkContentArray
{
    
    if(!self.currStkFilePath) // || ![self.currStkFilePath containsString:self.currStkUUID]){
    {
        GSAssert(NO);
        return nil;
    }
    
    //    SMLog(@"getStkContentArray:%@",self.currStkFilePath);
    
    long index = 0;
    long lineIndex = 0;
    
    KDataModel* kData;
    NSString* txt = [self readFileContent:self.currStkFilePath] ;
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
    
    
    
    //calulate value
    for(long i=6; i<[tmpContentArray count]-3; i++ ){
        KDataModel* kTP6Data  = [tmpContentArray objectAtIndex:(i-6)];
        KDataModel* kTP5Data  = [tmpContentArray objectAtIndex:(i-5)];
        KDataModel* kTP4Data  = [tmpContentArray objectAtIndex:(i-4)];
        KDataModel* kTP3Data  = [tmpContentArray objectAtIndex:(i-3)];
        KDataModel* kTP2Data  = [tmpContentArray objectAtIndex:(i-2)];
        KDataModel* kTP1Data  = [tmpContentArray objectAtIndex:(i-1)];
        KDataModel* kT0Data = [tmpContentArray objectAtIndex:i];
        KDataModel* kT1Data = [tmpContentArray objectAtIndex:i+1];
        KDataModel* kT2Data = [tmpContentArray objectAtIndex:i+2];

        
        kT0Data.dvTP1.dvOpen = (kTP1Data.open - kTP2Data.close)*100.f/kTP2Data.close;
        kT0Data.dvTP1.dvHigh = (kTP1Data.high - kTP2Data.close)*100.f/kTP2Data.close;
        kT0Data.dvTP1.dvLow = (kTP1Data.low - kTP2Data.close)*100.f/kTP2Data.close;
        kT0Data.dvTP1.dvClose = (kTP1Data.close - kTP2Data.close)*100.f/kTP2Data.close;
        
        kT0Data.dvT0.dvOpen = (kT0Data.open - kTP1Data.close)*100.f/kTP1Data.close;
        kT0Data.dvT0.dvHigh = (kT0Data.high - kTP1Data.close)*100.f/kTP1Data.close;
        kT0Data.dvT0.dvLow = (kT0Data.low - kTP1Data.close)*100.f/kTP1Data.close;
        kT0Data.dvT0.dvClose = (kT0Data.close - kTP1Data.close)*100.f/kTP1Data.close;
        
        kT0Data.dvT1.dvOpen = (kT1Data.open - kT0Data.close)*100.f/kT0Data.close;
        kT0Data.dvT1.dvHigh = (kT1Data.high - kT0Data.close)*100.f/kT0Data.close;
        kT0Data.dvT1.dvLow = (kT1Data.low - kT0Data.close)*100.f/kT0Data.close;
        kT0Data.dvT1.dvClose = (kT1Data.close - kT0Data.close)*100.f/kT0Data.close;
        
        kT0Data.dvT2.dvOpen = (kT2Data.open - kT1Data.close)*100.f/kT1Data.close;
        kT0Data.dvT2.dvHigh = (kT2Data.high - kT1Data.close)*100.f/kT1Data.close;
        kT0Data.dvT2.dvLow = (kT2Data.low - kT1Data.close)*100.f/kT1Data.close;
        kT0Data.dvT2.dvClose = (kT2Data.close - kT1Data.close)*100.f/kT1Data.close;
        
        //avaerage
        kT0Data.dvAvgTP1toTP5.dvOpen = ((kTP5Data.open+kTP4Data.open+kTP3Data.open+kTP2Data.open+kTP6Data.open)-5*kTP1Data.close)*100.f/kTP1Data.close;
        kT0Data.dvAvgTP1toTP5.dvHigh = ((kTP5Data.high+kTP4Data.high+kTP3Data.high+kTP2Data.high+kTP6Data.high)-5*kTP1Data.close)*100.f/kTP1Data.close;
        kT0Data.dvAvgTP1toTP5.dvLow = ((kTP5Data.low+kTP4Data.low+kTP3Data.low+kTP2Data.low+kTP6Data.low)-5*kTP1Data.close)*100.f/kTP1Data.close;
        kT0Data.dvAvgTP1toTP5.dvClose = ((kTP5Data.close+kTP4Data.close+kTP3Data.close+kTP2Data.close+kTP6Data.close)-5*kTP1Data.close)*100.f/kTP1Data.close;
        
        kT0Data.T1Data = kT1Data;
        kT0Data.TP1Data = kTP1Data;
        
        [self.contentArray addObject:kT0Data];
    }
    
    return self.contentArray;
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
