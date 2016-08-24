//
//  GSDataMgr.m
//  GSGoldenSea
//
//  Created by frank weng on 16/5/20.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "GSDataMgr.h"
#import "HYDBManager.h"

@implementation GSDataMgr

SINGLETON_GENERATOR(GSDataMgr, shareInstance);


-(id)init
{
    if(self = [super init]){
        self.startDate = 20100101;
        self.endDate = 20200101;
    }
    
    return self;
}


#pragma mark - db action
//stkid should be such as SH600011
-(NSArray*)getDataFromDB:(NSString*)stkID;
{
    KDataDBService* service = [[HYDBManager defaultManager] dbserviceWithSymbol:stkID];
//    NSArray* array = [service getAllRecords ];
    NSArray* array = [service getRecords:self.startDate end:self.endDate ];

    return array;
}



-(void)updateDataToDB
{
    //tbd.
    //判断当期db最后t日，从网络取t+1到当天数据，
    //然后从db取t-30日数据，算出ma5等值（假如网络能直接拿到ma值则可以忽略此步）
    //最后将数据写回db
}

-(void)writeDataToDB:(NSString*)docsDir;
{
    [self _writeDataToDB:docsDir FromDate:20020101 EndDate:20200101];
}

-(void)writeDataToDB:(NSString*)docsDir FromDate:(int)startDate;
{
    [self _writeDataToDB:docsDir FromDate:startDate EndDate:20200101];
}

-(void)_writeDataToDB:(NSString*)docsDir FromDate:(int)startDate EndDate:(int)endDate;
{
    long dbgNum = 0;
    
    
    NSMutableArray* files = [[GSDataMgr shareInstance]findSourcesInDir:docsDir];
    for(NSString* file in files){
        NSString* stkID = [HelpService stkIDWithFile:file];
        
        self.contentArray = [[GSDataMgr shareInstance] getStkContentArray:file];
        
        KDataDBService* service = [[HYDBManager defaultManager] dbserviceWithSymbol:stkID];

        [self addDataToTable:service];
        
        SMLog(@"%@",stkID);
    }
    
    
    SMLog(@"end of writeDataToDB");
}



-(void)addDataToTable:(KDataDBService*) service
{
    
    if(!service || [self.contentArray count]<30 ){ //skip cixingu.
        return;
    }
    
    NSDictionary* passDict;
    for(long i=1; i<[self.contentArray count]; i++ ){

        
        KDataModel* kTP1Data  = [self.contentArray objectAtIndex:(i-1)];
        KDataModel* kT0Data = [self.contentArray objectAtIndex:i];

        
        kT0Data.ma5 = [[GSDataMgr shareInstance] getMAValue:5 array:self.contentArray t0Index:i];
        kT0Data.ma10 = [[GSDataMgr shareInstance] getMAValue:10 array:self.contentArray t0Index:i];
        kT0Data.ma20 = [[GSDataMgr shareInstance] getMAValue:20 array:self.contentArray t0Index:i];
        kT0Data.ma30 = [[GSDataMgr shareInstance] getMAValue:30 array:self.contentArray t0Index:i];
//        kT0Data.ma60 = [[GSDataMgr shareInstance] getMAValue:60 array:self.contentArray t0Index:i];
//        kT0Data.ma120 = [[GSDataMgr shareInstance] getMAValue:120 array:self.contentArray t0Index:i];

        
        kT0Data.isLimitUp =  [HelpService isLimitUpValue:kTP1Data.close T0Close:kT0Data.close];
        kT0Data.isLimitDown =  [HelpService isLimitDownValue:kTP1Data.close T0Close:kT0Data.close];

        
//        //add record.
//        [service addRecord:kT0Data];
    }
    
    for(long i=1; i<[self.contentArray count]; i++ ){
        KDataModel* kT0Data = [self.contentArray objectAtIndex:i];
       
        //设置为15，考虑到此值比较能反应近期表现.以后可以修正之
        kT0Data.slopema30 = [[GSDataMgr shareInstance] getSlopeMAValue:15 array:self.contentArray t0Index:i];
        
        //add record.
        [service addRecord:kT0Data];
    }
    
}



-(NSArray*)getStkRangeFromQueryDB;
{
    NSMutableArray* array = [NSMutableArray array];
    
    NSArray* qesArray = [[QueryDBManager defaultManager].qREsDBService getAllRecords];
    for(long i=0; i<[qesArray count]; i++){
        QueryResModel* qModel = [qesArray objectAtIndex:i];
        [array addObject:qModel.stkID];
    }
    
    return array;
}



#pragma mark - file action

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
            
            BOOL isMapMarket = NO;
            switch (self.marketType) {
                case marketType_All:
                    isMapMarket = YES;
                    break;
                    
                case marketType_ShangHai:
                    if([file hasPrefix:@"SH"]){
                        isMapMarket = YES;
                    }
                    break;
                    
                case marketType_ShenZhenAll:
                    if([file hasPrefix:@"SZ"]){
                        isMapMarket = YES;
                    }
                    break;
                    
                case marketType_ShenZhenMainAndZhenXiaoBan:
                    if([file hasPrefix:@"SZ"] && ![file hasPrefix:@"SZ#300"]){
                        isMapMarket = YES;
                    }
                    break;
                    
                case marketType_ShenZhenChuanYeBan:
                    if([file hasPrefix:@"SZ#300"]){
                        isMapMarket = YES;
                    }
                    break;
                    
                default:
                    isMapMarket = YES;
                    break;
            }

            
            if(isMapMarket){
                NSString* fullPath = [NSString stringWithFormat:@"%@/%@",docsDir,file];
                [self.sourceFileArray addObject:fullPath];
            }
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
    long tIndex = 0;
    
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
//                    kData.time = value;
                    kData.time = [[value stringByReplacingOccurrencesOfString:@"/" withString:@""]intValue];
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
            kData.tIndex = tIndex++;
        }
        
        
        index++; //just for debug.
    }
    
    self.contentArray = tmpContentArray;
    
    
    return self.contentArray;
}


#pragma mark - util function

-(CGFloat)getDVValueWithBaseValue:(CGFloat)baseValue destValue:(CGFloat)destValue;
{
    CGFloat val = 0.f;
    
    val = (destValue-baseValue)*100.f/baseValue;
    
    return val;
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


-(CGFloat)getDegree:(CGFloat)duibian lingBian:(CGFloat)lingbian
{
//    CGFloat duibian , lingbian;
    //角度=对边/邻边
    CGFloat td = atan2f(duibian, lingbian);   //atan2f(4, 6.92);
    return td*180/3.1415926; //atan等三角函数是弧度，需要转换成角度
}

-(CGFloat)getSlopeMAValue:(NSUInteger)days array:(NSArray*)tmpContentArray t0Index:(long)t0Index
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
    }
    
    kSlopeStartData = [tmpContentArray objectAtIndex:t0Index-realDays];
    CGFloat dvValue = [self getDVValueWithBaseValue:kSlopeStartData.ma30 destValue:kT0Data.ma30];
//    dvValue = kT0Data.ma30-kSlopeStartData.ma30;
    
    //need factor number fix?
    slopemaValue = [self getDegree:dvValue lingBian:realDays];

    
    
    
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

-(BOOL)isMeetPeriodCondition:(KDataModel*)kData;
{
    long date =  kData.time; // [[kData.time stringByReplacingOccurrencesOfString:@"/" withString:@""]intValue];
    
    if(date > self.startDate
       && date < self.endDate){
        return YES;
    }else{
        return NO;
    }
    
}


-(BOOL)isSimlarValue:(CGFloat)destValue baseValue:(CGFloat)baseValue Offset:(CGFloat)offset;
{
    CGFloat dv = (destValue-baseValue)*100.f/baseValue;
    if(fabs(dv) > offset){
        return NO;
    }else{
        return YES;
    }
}

@end
