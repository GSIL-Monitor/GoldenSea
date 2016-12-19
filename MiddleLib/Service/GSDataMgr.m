//
//  GSDataMgr.m
//  GSGoldenSea
//
//  Created by frank weng on 16/5/20.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "GSDataMgr.h"
#import "HYDayDBManager.h"
#import "YahooDataReq.h"

#import "TSTK.h"
#import "STKModel.h"
#import "TDBInfo.h"

#define Key_Max_Date 21680808

typedef enum {
    DateType_tdx = 0,
    DateType_yahoo
}DateType;


@interface GSDataMgr ()

@property (nonatomic, strong) DBInfoModel* dayDBInfo;
@property (nonatomic, strong) DBInfoModel* weekDBInfo;
@property (nonatomic, strong) DBInfoModel* monthDBInfo;

@property (nonatomic, strong) DBInfoModel* NSTKDayDBInfo;


@end

@implementation GSDataMgr

SINGLETON_GENERATOR(GSDataMgr, shareInstance);


-(id)init
{
    if(self = [super init]){
        self.startDate = 20100101;
        self.endDate = Key_Max_Date;
    }
    
    return self;
}


#pragma mark - db action
//stkid should be such as SH600011
-(NSArray*)getDayDataFromDB:(NSString*)stkID;
{
    TKData* service = [[HYDayDBManager defaultManager] dbserviceWithSymbol:stkID];
    NSArray* array = [service getRecords:self.startDate end:self.endDate ];

    return array;
}

-(NSArray*)getWeekDataFromDB:(NSString*)stkID;
{
    TKData* service = [[HYWeekDBManager defaultManager] dbserviceWithSymbol:stkID];
    NSArray* array = [service getWeekRecords:20020101 end:self.endDate ];
    
    return array;
}

-(NSArray*)getMonthDataFromDB:(NSString*)stkID;
{
    TKData* service = [[HYMonthDBManager defaultManager] dbserviceWithSymbol:stkID];
    NSArray* array = [service getMonthRecords:20020101 end:Key_Max_Date ];
    
    return array;
}


-(NSArray*)getNSTKDayDataFromDB:(NSString*)stkID;
{
    TKData* service = [[HYNewSTKDayDBManager defaultManager] dbserviceWithSymbol:stkID];
    NSArray* array = [service getRecords:self.startDate end:self.endDate ];
    
    return array;
}


-(void)writeDataToDB:(NSString*)docsDir EndDate:(int)dataEndDate;
{
    self.dayDBInfo = [[HYDayDBManager defaultManager].dbInfo getRecord];
    self.weekDBInfo = [[HYWeekDBManager defaultManager].dbInfo getRecord];
    self.monthDBInfo = [[HYMonthDBManager defaultManager].dbInfo getRecord];
    self.NSTKDayDBInfo = [[HYNewSTKDayDBManager defaultManager].dbInfo getRecord];
    
//    DBInfoModel* dbInfo = [[TDBInfo shareInstance]getRecord];
//    if(!dbInfo){ //no result. means first time.
//        [self _writeDataToDB:docsDir FromDate:20020101 EndDate:dataEndDate];
//    }else{
//        //from the lastUpdateTime, in case the lastUpdateTime day date not in db.
//        //Don't! 
//        [self _writeDataToDB:docsDir FromDate:(int)dbInfo.lastUpdateTime EndDate:dataEndDate];
//    }
    
    [self _writeDataToDB:docsDir FromDate:20020101 EndDate:dataEndDate];

    
}

//#define EnalbeDayDB 1
//#define EnalbeWeekDB 1
//#define EnalbeMonthDB 1
#define EnalbeNSTKDayDB 1


-(void)_writeDataToDB:(NSString*)docsDir FromDate:(int)startDate EndDate:(int)endDate;
{
    long dbgNum = 0;
    
    
    NSMutableArray* files = [[GSDataMgr shareInstance]findSourcesInDir:docsDir];
    for(NSString* file in files){
        NSString* stkID = [HelpService stkIDWithFile:file];
        
        if(![[GSObjMgr shareInstance].mgr isInRange:stkID]){
            continue;
        }
        
        
        NSMutableArray* contentArray = [[GSDataMgr shareInstance] getStkContentArray:file];
        
        
        if(self.isJustWriteNSTK){
            BOOL isNSTK=YES;
            KDataModel* kT0Data = [contentArray safeObjectAtIndex:0];
            if(kT0Data.time >= 20160101){
                for(long i =0; i<4; i++){
                    KDataModel* kT0Data = [contentArray safeObjectAtIndex:i];
                    if(![HelpService isEqual:kT0Data.high with:kT0Data.low]){ //it's seem wrong.
                        isNSTK = NO;
                        continue;
                    }
                }
            }else{
                continue;
            }
            
            if(!isNSTK){
                continue;
            }
        }
        

        [self addDataToTable:stkID contentArray:contentArray fromDate:startDate EndDate:endDate];
        
        SMLog(@"%@",stkID);
    }
    
#ifdef EnalbeDayDB
    [[HYDayDBManager defaultManager].dbInfo updateTime:endDate];
#endif
#ifdef EnalbeWeekDB
    [[HYWeekDBManager defaultManager].dbInfo updateTime:endDate];
#endif
#ifdef EnalbeMonthDB
    [[HYMonthDBManager defaultManager].dbInfo updateTime:endDate];
#endif
    
#ifdef EnalbeNSTKDayDB
    [[HYNewSTKDayDBManager defaultManager].dbInfo updateTime:endDate];
#endif
    
    SMLog(@"end of writeDataToDB");
}


//fromDate should be lastUpdate time
-(void)addDataToTable:(NSString*) stkID  contentArray:(NSArray*)contentArray fromDate:(long)noUsefromDate EndDate:(int)endDate
{
    TKData* dayService = [[HYDayDBManager defaultManager] dbserviceWithSymbol:stkID];
    TKData* weekService = [[HYWeekDBManager defaultManager] dbserviceWithSymbol:stkID];
    TKData* monthService = [[HYMonthDBManager defaultManager] dbserviceWithSymbol:stkID];
    TKData* NSTKdayService = [[HYNewSTKDayDBManager defaultManager] dbserviceWithSymbol:stkID];

    if(!dayService || !weekService || !monthService ||!NSTKdayService){
        return;
    }
    
    if([contentArray count]<5 ){
//        GSAssert(NO,@"contentArray count is < 30!");
        return;
    }
    
    NSMutableArray* weekArray = [NSMutableArray array];
    NSMutableArray* monthArray = [NSMutableArray array];
    KDataModel* kTLastEndData; //last update end data. the data is always existed in week&month db.
    KDataModel* kEndData; //this end data.
    long fromDate = self.dayDBInfo.lastUpdateTime > 0 ? self.dayDBInfo.lastUpdateTime:20020101;
    long fromWeekDate = self.weekDBInfo.lastUpdateTime > 0 ? self.weekDBInfo.lastUpdateTime:20020101;
    long fromMonthDate = self.monthDBInfo.lastUpdateTime > 0 ? self.monthDBInfo.lastUpdateTime:20020101;
    fromDate = fromDate<fromWeekDate?fromDate:fromWeekDate;
    fromDate = fromDate<fromMonthDate?fromDate:fromMonthDate;
    

    BOOL isFirstData = YES;
    for(long i=1; i<[contentArray count]; i++ ){
        KDataModel* kTP2Data  = [contentArray safeObjectAtIndex:(i-2)];
        KDataModel* kTP1Data  = [contentArray objectAtIndex:(i-1)];
        KDataModel* kT0Data = [contentArray objectAtIndex:i];
        
        if(kT0Data.time == fromDate) //fromdate = lastUpdatDate
        {
            kTLastEndData = kT0Data;
        }
        
        //skip fromdate for update db case. because fromDate is lastUpdate time
        if(kT0Data.time < fromDate || kT0Data.time > endDate){
            continue;
        }
        
        if(isFirstData){
            kT0Data.unitDbg.monthOpen = kT0Data.open;
            kT0Data.unitDbg.weekOpen = kT0Data.open;
            isFirstData = NO;
        }
        

        
        [self setCanlendarInfo:kT0Data];
        [self setRealEndInfo:kT0Data kTP1Data:kTP1Data];
        
        if(kTP1Data.unitDbg.isWeekEnd){
            [weekArray addObject:kTP1Data];
        }
        
        if(kTP1Data.unitDbg.isMonthEnd){
            [monthArray addObject:kTP1Data];
        }

        kEndData = kT0Data;
        
    }
    
    if(![weekArray containsObject:kEndData]){
        [weekArray safeAddObject:kEndData];
    }
    
    if(![monthArray containsObject:kEndData]){
        [monthArray safeAddObject:kEndData];
    }
    
    
    //1,deal with day data
#ifdef EnalbeDayDB
    fromDate = self.dayDBInfo.lastUpdateTime > 0 ? self.dayDBInfo.lastUpdateTime:20020101;
    for(long i=0; i<[contentArray count]; i++ ){
        [UtilData setMACDBar:contentArray baseIndex:i fstdays:12 snddays:26 trddays:9];

        KDataModel* kT0Data = [contentArray objectAtIndex:i];
        if(kT0Data.time <= fromDate  || kT0Data.time > endDate){
            continue;
        }
        
        kT0Data.ma5 = [UtilData getMAValue:5 array:contentArray t0Index:i];
        kT0Data.ma10 = [UtilData getMAValue:10 array:contentArray t0Index:i];
        kT0Data.ma20 = [UtilData getMAValue:20 array:contentArray t0Index:i];
        kT0Data.ma30 = [UtilData getMAValue:30 array:contentArray t0Index:i];
        kT0Data.ma60 = [UtilData getMAValue:60 array:contentArray t0Index:i];
        kT0Data.ma120 = [UtilData getMAValue:120 array:contentArray t0Index:i];
        
        if(i>=1){
            KDataModel* kTP1Data  = [contentArray objectAtIndex:(i-1)];
            kT0Data.isLimitUp =  [HelpService isLimitUpValue:kTP1Data.close T0Close:kT0Data.close];
            kT0Data.isLimitDown =  [HelpService isLimitDownValue:kTP1Data.close T0Close:kT0Data.close];
        }
        
        [dayService addRecord:kT0Data];
        
    }
    
#endif

    
    CGFloat tmpVolume;

#ifdef EnalbeWeekDB
    //2, deal with week data
    fromDate = self.weekDBInfo.lastUpdateTime > 0 ? self.weekDBInfo.lastUpdateTime:20020101;
    for(long i=0; i<[weekArray count]; i++ ){
        [UtilData setMACDBar:weekArray baseIndex:i fstdays:12 snddays:26 trddays:9];

        KDataModel* kT0Data = [weekArray objectAtIndex:i];
        if(kT0Data.time <= fromDate  || kT0Data.time > endDate){
            continue;
        }
        
        kT0Data.ma5 = [UtilData getMAValue:5 array:weekArray t0Index:i];
        kT0Data.ma10 = [UtilData getMAValue:10 array:weekArray t0Index:i];
        kT0Data.ma20 = [UtilData getMAValue:20 array:weekArray t0Index:i];
        kT0Data.ma30 = [UtilData getMAValue:30 array:weekArray t0Index:i];
        
        
        [self addRecordByExchangeData:kT0Data service:weekService period:Period_week];
    }
    
    if(![weekArray containsObject:kTLastEndData]){
        [weekService deleteRecordWithTime:kTLastEndData.time];
    }
    

#endif
    
#ifdef EnalbeMonthDB
    //3, deal with month data
    fromDate = self.monthDBInfo.lastUpdateTime > 0 ? self.monthDBInfo.lastUpdateTime:20020101;
    for(long i=0; i<[monthArray count]; i++ ){
        [UtilData setMACDBar:monthArray baseIndex:i fstdays:12 snddays:26 trddays:9];

        KDataModel* kT0Data = [monthArray objectAtIndex:i];
        if(kT0Data.time <= fromDate  || kT0Data.time > endDate){
            continue;
        }
        
        kT0Data.ma5 = [UtilData getMAValue:5 array:monthArray t0Index:i];
        kT0Data.ma10 = [UtilData getMAValue:10 array:monthArray t0Index:i];
        kT0Data.ma20 = [UtilData getMAValue:20 array:monthArray t0Index:i];
        kT0Data.ma30 = [UtilData getMAValue:30 array:monthArray t0Index:i];
        
        [self addRecordByExchangeData:kT0Data service:monthService period:Period_month];

    }
    
    if(![monthArray containsObject:kTLastEndData]){
        [monthService deleteRecordWithTime:kTLastEndData.time];
    }
    

#endif
    
    
    
#ifdef EnalbeNSTKDayDB
    fromDate = self.NSTKDayDBInfo.lastUpdateTime > 0 ? self.NSTKDayDBInfo.lastUpdateTime:20020101;
    for(long i=0; i<[contentArray count]; i++ ){
        [UtilData setMACDBar:contentArray baseIndex:i fstdays:12 snddays:26 trddays:9];
        
        KDataModel* kT0Data = [contentArray objectAtIndex:i];
        if(kT0Data.time <= fromDate  || kT0Data.time > endDate){
            continue;
        }
        
        kT0Data.ma5 = [UtilData getMAValue:5 array:contentArray t0Index:i];
        kT0Data.ma10 = [UtilData getMAValue:10 array:contentArray t0Index:i];
        kT0Data.ma20 = [UtilData getMAValue:20 array:contentArray t0Index:i];
        kT0Data.ma30 = [UtilData getMAValue:30 array:contentArray t0Index:i];
        kT0Data.ma60 = [UtilData getMAValue:60 array:contentArray t0Index:i];
        kT0Data.ma120 = [UtilData getMAValue:120 array:contentArray t0Index:i];
        
        if(i>=1){
            KDataModel* kTP1Data  = [contentArray objectAtIndex:(i-1)];
            kT0Data.isLimitUp =  [HelpService isLimitUpValue:kTP1Data.close T0Close:kT0Data.close];
            kT0Data.isLimitDown =  [HelpService isLimitDownValue:kTP1Data.close T0Close:kT0Data.close];
        }
        
        [NSTKdayService addRecord:kT0Data];
        
    }
    
#endif
    
}

-(void)addRecordByExchangeData:(KDataModel*) kT0Data service:(TKData* )service period:(Period)period
{
    CGFloat tmpVolume;
    CGFloat tmpOpen;
    CGFloat tmpHigh;
    CGFloat tmpLow;
    
    
    switch (period) {
            
        case Period_week:
        {
            tmpVolume = kT0Data.volume;
            kT0Data.volume = kT0Data.unitDbg.weekVolume;
            
            tmpOpen = kT0Data.open;
            kT0Data.open = kT0Data.unitDbg.weekOpen;
            
            tmpHigh = kT0Data.high;
            kT0Data.high = kT0Data.unitDbg.weekHigh;
            
            tmpLow = kT0Data.low;
            kT0Data.low = kT0Data.unitDbg.weekLow;
            
        }
            break;
            
        case Period_month:
        {
            tmpVolume = kT0Data.volume;
            kT0Data.volume = kT0Data.unitDbg.monthVolume;
            
            tmpOpen = kT0Data.open;
            kT0Data.open = kT0Data.unitDbg.monthOpen;
            
            tmpHigh = kT0Data.high;
            kT0Data.high = kT0Data.unitDbg.monthHigh;
            
            tmpLow = kT0Data.low;
            kT0Data.low = kT0Data.unitDbg.monthLow;
  
        }
            break;
            
            
            
        default:
            break;
    }
    
    [service addRecord:kT0Data];
    
    kT0Data.volume = tmpVolume;
    kT0Data.open = tmpOpen;
    kT0Data.high = tmpHigh;
    kT0Data.low = tmpLow;

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
    
    
    NSString* txt = [self readFileContent:filePath] ;
    if(!txt){
        return nil;
    }
    
    
    NSArray *contentlines = [txt componentsSeparatedByString:@"\n"];
    NSRange range = {2,[contentlines count]-2 }; //dbg, need check.
    NSArray *lines = [contentlines subarrayWithRange:range];
    NSMutableArray* contentArray = [self parseData:lines dataType:DateType_tdx];
    
    return contentArray;
}


-(NSMutableArray*)parseData:(NSArray*)lines dataType:(long)dataType
{
    long index = 0;
    KDataModel* kData;
    NSMutableArray* tmpContentArray = [NSMutableArray array];

    
    for(NSString* oneline in lines){
        //tdx: 2011/10/10	5.22	5.25	5.12	5.13	32428434	274365568.00
        //yahoo: 2016-08-24,6.81,6.92,6.80,6.85,9806100,6.85
        
        //        SMLog(@"oneline:%@",oneline);
    
        NSArray* tmpArray;
        if(dataType == DateType_tdx){
            tmpArray = [oneline componentsSeparatedByString:@"\t"] ;
        }else{ //yahoo
            tmpArray = [oneline componentsSeparatedByString:@","] ;
        }
        
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
                    if(dataType == DateType_tdx){
                        kData.time = [[value stringByReplacingOccurrencesOfString:@"/" withString:@""]intValue];
                    }else{
                        kData.time = [[value stringByReplacingOccurrencesOfString:@"-" withString:@""]intValue];
                    }
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
                    kData.volume = [value floatValue]/100/10000; //[value intValue];
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
    
    return tmpContentArray;
}


#pragma mark - yahoo
//implement but not used. because found the network data has mistake .
-(void)updateDataToDBFromNet
{
    //判断当期db最后t日，从网络取t+1到当天数据，
    //然后从db取t-1Y日数据，算出ma5等值（假如网络能直接拿到ma值则可以忽略此步）
    //最后将数据写回db
    
//    NSArray* stkArray = [[TSTK shareInstance]getAllRecords];
//    if(![stkArray count]){
//        GSAssert(NO,@"no existed stk in table STKDB!");
//    }
//    
//    for(STKModel* ele in stkArray){
//        
//        if(![[GSObjMgr shareInstance].mgr isInRange:ele.stkID]){
//            continue;
//        }
//        
//        [self queryYahooData:ele];
//    }
}

//query data must start with 指定日期-30 以保证ma的计算
-(void)queryYahooData:(STKModel*)stkModel
{
//    KDataReqModel* reqModel = [[KDataReqModel alloc]init];
//    
//    reqModel.symbol = stkModel.stkID; // @"SH000001";
//    reqModel.period = @"1day";
//    reqModel.begin = stkModel.lastUpdateTime;
//    reqModel.end = Key_Max_Date;
    
    YahooDataReq* kdataReq = [YahooDataReq requestWith:stkModel];
    
    [kdataReq startWithSuccess:^(HYBaseRequest *request, HYBaseResponse *response) {
        
        NSString *content = [request responseString];
        NSArray *contentlines = [content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        
        SMLog(@"%@ success!", stkModel.stkID);
    } failure:^(HYBaseRequest *request, HYBaseResponse *response) {
        SMLog(@"%@ failed",stkModel.stkID);
    }];
}


-(void)saveYahooDataToDB:(NSArray*)contentlines stkModel:(STKModel*)stkModel
{
//    NSRange range = {1,[contentlines count]-1 }; //dbg, need check.
//    NSArray *lines = [contentlines subarrayWithRange:range];
//    
//    NSMutableArray* dataArray = [self parseData:lines dataType:DateType_yahoo];
//    
//    
//    TKData* service = [[HYDayDBManager defaultManager] dbserviceWithSymbol:stkModel.stkID];
//    
//    //假如网络取到的数据是从我们指定的日期开始,则从数据库里拿之前的数据
//    //考虑到停牌因素，将当前日期-1年，保证拿到数据
//    NSArray* oldDataArray = [service getRecords:(stkModel.lastUpdateTime-10000) end:stkModel.lastUpdateTime];
//    
//    NSMutableArray* contentArray = [NSMutableArray arrayWithArray: [oldDataArray arrayByAddingObjectsFromArray:dataArray]];
//    [self addDataToTable:service contentArray:contentArray fromDate:stkModel.lastUpdateTime EndDate:Key_Max_Date];
//    
//    stkModel.lastUpdateTime = [HelpService getCurrDate];
//    [[TSTK shareInstance]updateRecord:stkModel];
}

#pragma mark - util function




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







#pragma mark - dates
static const unsigned componentFlags = (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSCalendarUnitWeekOfYear);
static NSCalendar *sharedCalendar = nil;
+ (NSCalendar *) currentCalendar
{
    if (!sharedCalendar){
//        sharedCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierChinese];//农历
        sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
    }
    return sharedCalendar;
}

-(void)setCanlendarInfo:(KDataModel*)kData
{
    NSString* str = [NSString stringWithFormat:@"%ld",kData.time]; // @"20160914 ";

    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *date = [formatter dateFromString:str];
    
//    NSDateFormatter *weekday = [[NSDateFormatter alloc] init] ;
//    [weekday setDateFormat: @"EEEE"];
    
    NSDateComponents *components = [[GSDataMgr currentCalendar] components:componentFlags fromDate:date];
    components.weekday--; //because orginal component from 周日 as 1
    
    kData.unitDbg.month = components.month;
    kData.unitDbg.monthday = components.day;
    kData.unitDbg.week = components.weekOfYear;
    kData.unitDbg.weekday = components.weekday;
    
    kData.unitDbg.isMonthEnd = YES;
    kData.unitDbg.isWeekEnd = YES;
    
}


-(void)setRealEndInfo:(KDataModel*)kData  kTP1Data:(KDataModel*)kTP1Data
{
    if(kTP1Data){
        if(kData.unitDbg.month == kTP1Data.unitDbg.month){
            kTP1Data.unitDbg.isMonthEnd = NO;
        }
        if(kData.unitDbg.week == kTP1Data.unitDbg.week){
            kTP1Data.unitDbg.isWeekEnd = NO;
        }
    }
    
    //0801: 16.1, 8082
//    
//    if(kTP1Data.time == 20160801){
//        NSLog(@"");
//    }
    
    if(kTP1Data.unitDbg.isMonthEnd){
        kData.unitDbg.monthVolume = kData.volume;
        
        kData.unitDbg.monthOpen = kData.open;
        kData.unitDbg.monthHigh = kData.high;
        kData.unitDbg.monthLow = kData.low;
    }else{
        kData.unitDbg.monthVolume = kTP1Data.unitDbg.monthVolume+kData.volume;
        
        kData.unitDbg.monthLow = (kData.low < kTP1Data.unitDbg.monthLow )? kData.low : kTP1Data.unitDbg.monthLow;
        kData.unitDbg.monthHigh = (kData.high > kTP1Data.unitDbg.monthHigh ) ? kData.high: kTP1Data.unitDbg.monthHigh;
        kData.unitDbg.monthOpen = kTP1Data.unitDbg.monthOpen;
    }
    
    if(kTP1Data.unitDbg.isWeekEnd ){
        kData.unitDbg.weekVolume = kData.volume;
        
        kData.unitDbg.weekOpen = kData.open;
        kData.unitDbg.weekHigh = kData.high;
        kData.unitDbg.weekLow = kData.low;
    }else{
        kData.unitDbg.weekVolume = kTP1Data.unitDbg.weekVolume+kData.volume;
        
        kData.unitDbg.weekLow = (kData.low < kTP1Data.unitDbg.weekLow )? kData.low : kTP1Data.unitDbg.weekLow;
        kData.unitDbg.weekHigh = (kData.high > kTP1Data.unitDbg.weekHigh ) ? kData.high: kTP1Data.unitDbg.weekHigh;
        kData.unitDbg.weekOpen = kTP1Data.unitDbg.weekOpen;

    }

}


@end
