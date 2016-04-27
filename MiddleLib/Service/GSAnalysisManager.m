//
//  GSFileManager.m
//  GSGoldenSea
//
//  Created by frank weng on 16/4/25.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "GSAnalysisManager.h"
#import "KDataModel.h"



@interface GSAnalysisManager ()

@property (nonatomic,strong) NSString* currStkUUID;
@property (nonatomic,strong) NSString* currStkFilePath;
@property (nonatomic,strong) NSMutableArray* contentArray;
@property (nonatomic,strong) NSMutableArray* resultArray;

@property (assign) int currDate;
@property (assign) int totalCount;

@end


@implementation GSAnalysisManager

SINGLETON_GENERATOR(GSAnalysisManager, shareManager);


-(id)init
{
    if(self = [super init]){
        //1,get date
        NSDate * date = [NSDate date];
        NSTimeInterval sec = [date timeIntervalSinceNow];
        NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
        
        NSDateFormatter * df = [[NSDateFormatter alloc] init ];
//        [df setDateFormat:@"yyyy-MM-dd HH.mm.ss"];
        [df setDateFormat:@"yyyyMMdd"];
        NSString * dString = [df stringFromDate:currentDate];
        
        self.currDate = [dString intValue];
        self.DVUnitValue = 0.5f;
    }
    
    return self;
}


-(void)parseFile:(NSString*)stkUUID inDir:(NSString*)docsDir
{
    //reset content when every time read file.
    [self reset];
    
    self.currStkUUID = stkUUID;
    
    [self findSourceFileWithStkUUID:stkUUID inDir:docsDir];
    [self getStkContentArray];
    
    [self analysis];
}


-(void)analysis
{
    self.totalCount=0;
    
    if(! [self isValidDataPassedIn]){
        return;
    }
    
    
    for(long i=1; i<[self.contentArray count]-1; i++ ){
        KDataModel* kTP2Data  = [self.contentArray objectAtIndex:(i-1)];
        KDataModel* kTP1Data  = [self.contentArray objectAtIndex:i];
        KDataModel* kT0Data = [self.contentArray objectAtIndex:i+1];
        
        kT0Data.dvTP1Open = (kTP1Data.open - kTP2Data.close)*100.f/kTP2Data.close;
        kT0Data.dvTP1High = (kTP1Data.high - kTP2Data.close)*100.f/kTP2Data.close;
        kT0Data.dvTP1Close = (kTP1Data.close - kTP2Data.close)*100.f/kTP2Data.close;
        kT0Data.dvTP1Low = (kTP1Data.low - kTP2Data.close)*100.f/kTP2Data.close;

        kT0Data.dvHigh = (kT0Data.high - kTP1Data.close)*100.f/kTP1Data.close;
        kT0Data.dvClose = (kT0Data.close - kTP1Data.close)*100.f/kTP1Data.close;
        kT0Data.dvOpen = (kT0Data.open - kTP1Data.close)*100.f/kTP1Data.close;
        kT0Data.dvLow = (kT0Data.low - kTP1Data.close)*100.f/kTP1Data.close;

        if(![self isMeetConditon:self.tp1dayCond PrevData:kTP2Data NextData:kTP1Data]){
            continue;
        }
        
        
        if(![self isMeetConditon:self.t0dayCond PrevData:kTP1Data NextData:kT0Data]){
            continue;
        }
        
        
        [self dispatchResult2Array:kT0Data];
        
        self.totalCount++;
    }
    
    [self logOutResult];
    
    SMLog(@"end analysis. totalCount(%d)",self.totalCount);
    

}


#pragma mark - internal funcs


-(void)logOutResult
{
    //logOut which loss item
    NSMutableArray* tmpArray;
    CGFloat percent = 0.f;
    
    for(long i=0; i<[self.resultArray count]; i++){
        tmpArray = [self.resultArray objectAtIndex:i];
        
        percent = [tmpArray count]*100.f/self.totalCount;
        
        if(i <= 3){
            SMLog(@"win itme array :%ld, percent(%.2f)",i,percent);
        }else{
            SMLog(@"--loss itme array :%ld, percent(%.2f)",i,percent);
        }
        
        for (KDataModel* kData in tmpArray) {
            SMLog(@"%@  TP1High:%.2f, TP1Close:%.2f,  T0Open:%.2f, T0High:%.2f , T0Close:%.2f, T0Low:%.2f",kData.time, kData.dvTP1High,kData.dvTP1Close,kData.dvOpen,kData.dvHigh,kData.dvClose,kData.dvLow);
        }
    }
    
    
}

-(void)reset
{
    self.totalCount = 0;
    self.currStkUUID = nil;
    self.currStkFilePath = nil;
    self.contentArray = [NSMutableArray array];
    self.resultArray = [NSMutableArray array];
    
    /*
     Sndday high vs fstday close
     >3%
     >2%
     >1%
     >0%
     >-1%
     >-2%
     >-10%
     */
    for(long i=0; i<6; i++){
        [self.resultArray addObject:[NSMutableArray array]];
    }
}

-(void)dispatchResult2Array:(KDataModel*)kSndData
{
    CGFloat dvValue = kSndData.dvHigh;
//    CGFloat dvUnit = 1.f;
    NSMutableArray* tmpArray;
    if(dvValue > 3.f){
        tmpArray = [self.resultArray objectAtIndex:0];
    }else if (dvValue > 2.f){
        tmpArray = [self.resultArray objectAtIndex:1];
    }else if (dvValue > 1.f){
        tmpArray = [self.resultArray objectAtIndex:2];
    }else if (dvValue > 0.f){
        tmpArray = [self.resultArray objectAtIndex:3];
    }else if (dvValue > -1.5f){
        tmpArray = [self.resultArray objectAtIndex:4];
    }else if (dvValue > -11.f){
        tmpArray = [self.resultArray objectAtIndex:5];
    }
    
    [tmpArray addObject:kSndData];
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
            if([file containsString:stkUUID]){
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


-(void)getStkContentArray
{
    
    if(!self.currStkFilePath || ![self.currStkFilePath containsString:self.currStkUUID]){
        GSAssert(NO);
        return;
    }
    
    SMLog(@"getStkContentArray:%@",self.currStkFilePath);
    
    long index = 0;
    long lineIndex = 0;
    
    KDataModel* kData;
    NSString* txt = [self readFileContent:self.currStkFilePath] ;
    if(!txt){
        return;
    }
    
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
            [self.contentArray addObject:kData];
        }

        
        index++; //just for debug.
    }
    
}

#pragma mark - condition
-(BOOL)isMeetPeriodCondition:(KDataModel*)kData;
{
    
    int date =  [[kData.time stringByReplacingOccurrencesOfString:@"/" withString:@""]intValue];
    
    
    //tmp solution
    if(date > 20150101){
        return YES;
    }else{
        return NO;
    }
    
    
    //tbd.
    int pdtime = self.currDate - date;
    
    switch (self.period) {
        case Period_3m:
            
            break;
            
        case Period_1y:
            
            break;
            
        case Period_2y:
            
            break;
            
        default:
            break;
    }
    
    
    return YES;
}

-(BOOL)isMeetConditon:(OneDayCondition*)cond PrevData:(KDataModel*)kPrevData NextData:(KDataModel*)kNextData;
{
    if(!cond){
        return YES;
    }
    
    CGFloat dv = 0.f;
    
    dv = (kNextData.open - kPrevData.close)*100.f/kPrevData.close;
    if(!(dv > self.tp1dayCond.open_min
       && dv < self.tp1dayCond.open_max)){
        return NO;
    }
    
    dv = (kNextData.close - kPrevData.close)*100.f/kPrevData.close;
    if(!(dv > self.tp1dayCond.close_min
         && dv < self.tp1dayCond.close_max)){
        return NO;
    }
    
    dv = (kNextData.high - kPrevData.close)*100.f/kPrevData.close;
    if(!(dv > self.tp1dayCond.high_min
         && dv < self.tp1dayCond.high_max)){
        return NO;
    }
    
    dv = (kNextData.low - kPrevData.close)*100.f/kPrevData.close;
    if(!(dv > self.tp1dayCond.low_min
         && dv < self.tp1dayCond.low_max)){
        return NO;
    }
    
    return YES;
}


//
//-(BOOL)isMeetTP1dayConditon:(KDataModel*)kSndData FstData:(KDataModel*)kFstDat;
//{
//    
//    CGFloat dv = (kSndData.close - kFstDat.close)*100.f/kSndData.close;
//
//   if(dv > self.tp1dayCond.close_min
//      && dv < self.tp1dayCond.close_max){
//       return YES;
//   }
//    
//    return NO;
//}
//
//
//
//-(BOOL)isMeetT0DayConditon:(KDataModel*)kSndData FstData:(KDataModel*)kFstData;
//{
//    
//    if(self.DVUnitOfT0DayOpenAndTP1DayClose >= 99){ //skip limit
//        return YES;
//    }
//    
//    BOOL res = NO;
//   
//    
//    CGFloat dv = (kSndData.open - kFstData.close)*100/kFstData.close;
//    
//    CGFloat judgeDvCond = self.DVUnitOfT0DayOpenAndTP1DayClose*self.DVUnitValue;
//    {
//        if(dv >= judgeDvCond
//           &&  dv<(self.DVUnitOfT0DayOpenAndTP1DayClose+1)*self.DVUnitValue){
//            res = YES;
//        }
//    }
//   
//    
//    if(res == YES){
//        kSndData.isMeetT0DayConditonOpen = YES;
//    }
//    
//    return res;
//}


-(BOOL)isValidDataPassedIn
{
    BOOL res = YES;
    
    if(self.currT0KData){
        if(!self.currTP1KData || !self.currTP2KData){
            res = NO;
        }
        
        if(self.currT0KData.open > kInvalidData_Base
           || self.currT0KData.close > kInvalidData_Base
           || self.currT0KData.high > kInvalidData_Base
           || self.currT0KData.low > kInvalidData_Base){
            res = NO;
        }
        
        if(self.currTP1KData.open > kInvalidData_Base
           || self.currTP1KData.close > kInvalidData_Base
           || self.currTP1KData.high > kInvalidData_Base
           || self.currTP1KData.low > kInvalidData_Base){
            res = NO;
        }

        
        if(self.currTP2KData.open > kInvalidData_Base
           || self.currTP2KData.close > kInvalidData_Base
           || self.currTP2KData.high > kInvalidData_Base
           || self.currTP2KData.low > kInvalidData_Base){
            res = NO;
        }

    }
    
    if(!res){
        SMLog(@"the data is imcompleted!!!");
    }
    
    return res;
}




@end
