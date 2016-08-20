//
//  GSFileManager.m
//  GSGoldenSea
//
//  Created by frank weng on 16/4/25.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "GSBaseAnalysisMgr.h"
#import "KDataModel.h"
#import "GSBaseLogout.h"
#import "GSDataMgr.h"
#import "GSBaseAnalysisMgr+ex.h"
#import "GSCondition.h"

@interface GSBaseAnalysisMgr ()


@property (nonatomic, assign) BOOL isWriteToQueryDB;

@end


@implementation GSBaseAnalysisMgr

SINGLETON_GENERATOR(GSBaseAnalysisMgr, shareInstance);


-(id)init
{
    if(self = [super init]){
        
    }
    
    return self;
}

-(void)buildQueryAllDBInDir:(NSString*)docsDir;
{
    self.isWriteToQueryDB = YES;
    
    [self queryAllInDir:docsDir];
}

-(void)queryAllInDir:(NSString*)docsDir;
{
    self.isWriteToQueryDB = NO;
    
    [GSDataMgr shareInstance].startDate = 20160717;
    
    long dbgNum = 0;
    
    NSMutableArray* files = [[GSDataMgr shareInstance]findSourcesInDir:docsDir];
    for(NSString* file in files){
        [self resetForOne];
        self.stkID = [HelpService stkIDWithFile:file];
        
        if(![self isInRange:self.stkID]){
            continue;
        }
        
        self.contentArray = [[GSDataMgr shareInstance] getStkContentArray:file];
   
        [self queryRaisingLimit];
    }
    
    SMLog(@"end of queryAllInDir");

}



-(void)analysisAllInDir:(NSString*)docsDir;
{
    NSMutableArray* files = [[GSDataMgr shareInstance]findSourcesInDir:docsDir];
    for(NSString* file in files){
        [self resetForOne];
        self.stkID = [HelpService stkIDWithFile:file];
        
        if(![self isInRange:self.stkID]){
            continue;
        }
        
        self.contentArray = [[GSDataMgr shareInstance]getDataFromDB:self.stkID];

        [self analysis];
        
    }
    
    
//    [[GSBaseLogout shareInstance]logOutAllResult];
    
//    SMLog(@"end of analysisAll");
}


-(void)queryRaisingLimit
{
    //skip new stk.
    if([self.contentArray count]<20){
        return;
    }
    
    NSMutableArray* queryArray = [NSMutableArray array];
    
//    SMLog(@"stkID:%@",self.stkID);
    long lastIndex = [self.contentArray count]-1;
    for(long i=[self.contentArray count]-11; i<[self.contentArray count]-1; i++ ){
        KDataModel* kTP1Data  = [self.contentArray objectAtIndex:(i-1)];
        KDataModel* kT0Data = [self.contentArray objectAtIndex:i];
        kT0Data.isLimitUp =  [HelpService isLimitUpValue:kTP1Data.close T0Close:kT0Data.close];


        
        if(kT0Data.isLimitUp){
            
            kTP1Data.ma5 = [[GSDataMgr shareInstance] getMAValue:5 array:self.contentArray t0Index:i-1];
            kTP1Data.ma10 = [[GSDataMgr shareInstance] getMAValue:10 array:self.contentArray t0Index:i-1];


            //filter raise much in shorttime
            if([self.param isMapRasingLimitAvgConditon:kTP1Data]){
                if(kT0Data.time >= 20160814){ // && kT0Data.time <= 20160816
                    KDataModel* kTLastData = [self.contentArray objectAtIndex:lastIndex];
                    CGFloat dvLast2kTP1DataMA5 = [[GSDataMgr shareInstance]getDVValueWithBaseValue:kTP1Data.ma5 destValue:kTLastData.close];
                    
//                    KDataModel* kT1Data = [self.contentArray objectAtIndex:i+1];
//                    KDataModel* kT2Data = [self.contentArray objectAtIndex:i+2];

                    if (dvLast2kTP1DataMA5 < 5.f) {
                        SMLog(@"%@ kT0Data: %ld.  dvLast2kTP1DataMA5(%.2f)",[self.stkID substringFromIndex:2],kT0Data.time, dvLast2kTP1DataMA5);
                    }
                    
                    
                    //write to queryDB if need.
                    if(self.isWriteToQueryDB){
                        QueryResModel* model = [[QueryResModel alloc]init];
                        model.stkID = self.stkID;
                        model.time = kT0Data.time;
                        [[QueryDBManager defaultManager].qREsDBService addRecord:model];
                    }
                }
            }else{
                
            }
        }
    }
    
    
    
    [[LimitLogout shareInstance] SimpleLogOutResult:NO];

    
}






-(void)analysis
{
    if(! [self isValidDataPassedIn] || [self.contentArray count]<20){
        return;
    }
    
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
        
        
        
        kT0Data.T1Data = kT1Data;
        kT0Data.TP1Data = kTP1Data;
        
        kT0Data.dvTP2 = [[GSDataMgr shareInstance] getDVValue:self.contentArray baseIndex:i-3 destIndex:i-2];
        kT0Data.dvTP1 = [[GSDataMgr shareInstance] getDVValue:self.contentArray baseIndex:i-2 destIndex:i-1];
        kT0Data.dvT0 = [[GSDataMgr shareInstance] getDVValue:self.contentArray baseIndex:i-1 destIndex:i];
        kT0Data.dvT1 = [[GSDataMgr shareInstance] getDVValue:self.contentArray baseIndex:i destIndex:i+1];
        kT0Data.dvT2 = [[GSDataMgr shareInstance] getDVValue:self.contentArray baseIndex:i+1 destIndex:i+2];
        
        kT0Data.dvAvgTP1toTP5 = [[GSDataMgr shareInstance] getAvgDVValue:5 array:self.contentArray index:i-1];
        
        
        passDict = @{@"kTP6Data":kTP6Data, @"kTP5Data":kTP5Data, @"kTP4Data":kTP4Data,@"kTP3Data":kTP3Data, @"kTP2Data":kTP2Data, @"kTP1Data":kTP1Data,@"kT0Data":kT0Data, @"kT1Data":kT1Data};
        
        
        //dv condintoon
        if(![self isMeetDVConditon:self.tp2dayCond DVValue:kT0Data.dvTP2]){
            continue;
        }
        
        if(![self isMeetDVConditon:self.tp1dayCond DVValue:kT0Data.dvTP1]){
            continue;
        }
        
        if(![self isMeetDVConditon:self.t0dayCond DVValue:kT0Data.dvT0]){
            continue;
        }
        
        if(![self isMeetDVConditon:self.t1dayCond DVValue:kT0Data.dvT1]){
            continue;
        }
        
        
        
        
        //shape condition
        if(![[GSCondition shareInstance] isMeetShapeCond:passDict]){
            continue;
        }
        
        //t0 condition
        if(![self isMeetT0Condition:passDict]){
            continue;
        }
        
        //        if(![self isMeetAddtionCond:passDict]){
        //            continue;
        //        }
        
        [self dispatchResult2Array:kT0Data buyIndex:i sellIndex:i+1];
        
    }
    
    
    
    [[GSBaseLogout shareInstance] logOutResult];

    
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
           && fabs(kT0Data.open - kT0Data.close) < 0.15f
           && kT0Data.dvT0.dvClose < 1.f)
        return YES;
    }
    
    
    return NO;
}




#pragma mark - condition




-(BOOL)isMeetT0Condition:(NSDictionary*)passDict
{
    if(!passDict)
        return YES;

    KDataModel* kT0Data = [passDict objectForKey:@"kT0Data"];
    
    switch ([GSCondition shareInstance].t0Cond) {
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




#pragma mark - common
-(CGFloat)getSellValue:(CGFloat)buyValue bIndexInArray:(NSUInteger)bIndexInArray kT0data:(KDataModel*)kT0Data;
{
    CGFloat sellValue;
    
    GSBaseAnalysisMgr* man = [GSBaseAnalysisMgr shareInstance];
    CGFloat destValue = (1+man.param.destDVValue/100.f)*buyValue;
    long durationAfterBuy = self.param.durationAfterBuy;
    long sIndex = [HelpService indexOfValueGreatThan:destValue Array:man.contentArray start:bIndexInArray+1 stop:bIndexInArray+durationAfterBuy kT0data:kT0Data];
    if(sIndex != -1){ //find
        sellValue = (1+man.param.destDVValue/100.f)*buyValue;
    }else{
        kT0Data.TSellData = [man.contentArray safeObjectAtIndex:(bIndexInArray+durationAfterBuy)];
        if(kT0Data.TSellData){ //if had data in that day.
            sellValue = kT0Data.TSellData.close;
        }else{
            sellValue = buyValue;
        }
    }
    
    
    return sellValue;
}



@end
