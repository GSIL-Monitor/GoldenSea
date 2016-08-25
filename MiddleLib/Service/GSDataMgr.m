//
//  GSDataMgr.m
//  GSGoldenSea
//
//  Created by frank weng on 16/5/20.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "GSDataMgr.h"
#import "HYDBManager.h"
#import "YahooDataReq.h"

#import "STKDBService.h"
#import "STKModel.h"


#define Key_Max_Date 21680808

typedef enum {
    DateType_tdx = 0,
    DateType_yahoo
}DateType;

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
    //然后从db取t-1Y日数据，算出ma5等值（假如网络能直接拿到ma值则可以忽略此步）
    //最后将数据写回db
    
    
    NSArray* stkArray = [[STKDBService shareInstance]getAllRecords];
    if(![stkArray count]){
        GSAssert(NO,@"no existed stk in table STKDB!");
    }
    
    for(STKModel* ele in stkArray){
        
        if(![[GSObjMgr shareInstance].mgr isInRange:ele.stkID]){
            continue;
        }
        
       
        
        [self queryYahooData:ele];
    }
}

-(void)writeDataToDB:(NSString*)docsDir;
{
    [self _writeDataToDB:docsDir FromDate:20020101 EndDate:Key_Max_Date];
}

-(void)writeDataToDB:(NSString*)docsDir FromDate:(int)startDate;
{
    [self _writeDataToDB:docsDir FromDate:startDate EndDate:Key_Max_Date];
}

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
        
        KDataDBService* service = [[HYDBManager defaultManager] dbserviceWithSymbol:stkID];

        [self addDataToTable:service contentArray:contentArray fromDate:startDate];
        
        SMLog(@"%@",stkID);
    }
    
    
    SMLog(@"end of writeDataToDB");
}


//fromDate should be lastUpdate time
-(void)addDataToTable:(KDataDBService*) service  contentArray:(NSArray*)contentArray fromDate:(long)fromDate
{
    
    if(!service ){
        return;
    }
    
    if([contentArray count]<30 ){
        GSAssert(NO,@"contentArray count is < 30!");
        return;
    }
    
    NSDictionary* passDict;
    for(long i=1; i<[contentArray count]; i++ ){

        
        KDataModel* kTP1Data  = [contentArray objectAtIndex:(i-1)];
        KDataModel* kT0Data = [contentArray objectAtIndex:i];
        
        if(kT0Data.time <= fromDate){ //skip fromdate for update db case. because fromDate is lastUpdate time
            continue;
        }

        
        kT0Data.ma5 = [[GSDataMgr shareInstance] getMAValue:5 array:contentArray t0Index:i];
        kT0Data.ma10 = [[GSDataMgr shareInstance] getMAValue:10 array:contentArray t0Index:i];
        kT0Data.ma20 = [[GSDataMgr shareInstance] getMAValue:20 array:contentArray t0Index:i];
        kT0Data.ma30 = [[GSDataMgr shareInstance] getMAValue:30 array:contentArray t0Index:i];
//        kT0Data.ma60 = [[GSDataMgr shareInstance] getMAValue:60 array:contentArray t0Index:i];
//        kT0Data.ma120 = [[GSDataMgr shareInstance] getMAValue:120 array:contentArray t0Index:i];

        
        kT0Data.isLimitUp =  [HelpService isLimitUpValue:kTP1Data.close T0Close:kT0Data.close];
        kT0Data.isLimitDown =  [HelpService isLimitDownValue:kTP1Data.close T0Close:kT0Data.close];

    }
    
    for(long i=1; i<[contentArray count]; i++ ){
        KDataModel* kT0Data = [contentArray objectAtIndex:i];
        if(kT0Data.time < fromDate){
            continue;
        }
       
        //设置为15，考虑到此值比较能反应近期表现.以后可以修正之
        kT0Data.slopema30 = [[GSDataMgr shareInstance] getSlopeMAValue:10 array:contentArray t0Index:i];
        
        //add record.
        kT0Data.tdIndex = i;
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
    
    return tmpContentArray;
}


#pragma mark - yahoo
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
        
        
        SMLog(@"%@ success!", reqModel.symbol);
    } failure:^(HYBaseRequest *request, HYBaseResponse *response) {
        SMLog(@"%@ failed",reqModel.symbol);
    }];
}


-(void)saveYahooDataToDB:(NSArray*)contentlines stkModel:(STKModel*)stkModel
{
    NSRange range = {1,[contentlines count]-1 }; //dbg, need check.
    NSArray *lines = [contentlines subarrayWithRange:range];
    
    NSMutableArray* dataArray = [self parseData:lines dataType:DateType_yahoo];
    
    
    KDataDBService* service = [[HYDBManager defaultManager] dbserviceWithSymbol:stkModel.stkID];
    
    //假如网络取到的数据是从我们指定的日期开始,则从数据库里拿之前的数据
    //考虑到停牌因素，将当前日期-1年，保证拿到数据
    NSArray* oldDataArray = [service getRecords:(stkModel.lastUpdateTime-10000) end:stkModel.lastUpdateTime];
    
    NSMutableArray* contentArray = [NSMutableArray arrayWithArray: [oldDataArray arrayByAddingObjectsFromArray:dataArray]];
    [self addDataToTable:service contentArray:contentArray fromDate:stkModel.lastUpdateTime];
    
    stkModel.lastUpdateTime = [HelpService getCurrDate];
    [[STKDBService shareInstance]updateRecord:stkModel];
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
    
    SMLog(@"%d: roc:%.2f, slopemaValue:%.2f",kT0Data.time,dvValue,slopemaValue);
    
    
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
