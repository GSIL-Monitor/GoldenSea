//
//  STKManager.m
//  GSGoldenSea
//
//  Created by frank weng on 16/3/4.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "STKManager.h"
#import "KDataRequest.h"
#import "KDataDBService.h"
#import "HYDatabaseHelper.h"


@interface STKManager ()

@property (strong) NSMutableDictionary* stkdbDict;

@end

@implementation STKManager

SINGLETON_GENERATOR(STKManager, shareManager);



-(id)init
{
    self = [super init];
    if(self){
        _stkdbDict = [NSMutableDictionary dictionary];
        
        [self setupDB];
    }
    
    return self;
}

-(void)setupDB
{
    [[HYDatabaseHelper defaultHelper] setupDB];
    

    
    
}


-(KDataDBService*)dbserviceWithSymbol:(NSString*)symbol
{
    KDataDBService* dataDBService = [self.stkdbDict safeValueForKey:symbol];
    if(!dataDBService){
        dataDBService = [[KDataDBService alloc]init];
        [dataDBService setup];
        [dataDBService createTable:symbol];
        [self.stkdbDict safeSetValue:dataDBService forKey:symbol];
    }
    
    return dataDBService;
}

-(void)test
{
    
    KDataReqModel* reqModel = [[KDataReqModel alloc]init];
    
    
    //dbg code
    //symbol=SH000001&period=1day&type=normal&begin=1424954307755&end=1456490307755&_=1456490307755
    reqModel.symbol = @"SH000001";
    reqModel.period = @"1day";
    reqModel.begin = @"1424954307755";
    reqModel.end = @"1456490307755";
    

    [self queryKData:reqModel];
    
}


-(void)queryKData:(KDataReqModel*)reqModel
{
    KDataRequest* kdataReq = [KDataRequest requestWith:reqModel];
    
    [kdataReq startWithSuccess:^(HYBaseRequest *request, HYBaseResponse *response) {
        KFullDataModel* dataModel = (KFullDataModel*)response.data;
        
        //save to file firstly
        NSString* fileName = [NSString stringWithFormat:@"%@.json",reqModel.symbol];
        [HelpService saveContent:request.responseString withName:fileName];
        
        //save to db.
        for(long i = 0; i<[dataModel.chartlist count]; i++){
            KDataModel* ele = [dataModel.chartlist safeObjectAtIndex:i];
            KDataDBService* service = [self dbserviceWithSymbol:reqModel.symbol];
            [service addRecord:ele];
        }
    } failure:^(HYBaseRequest *request, HYBaseResponse *response) {
        NSLog(@"failed");
    }];
}




@end
