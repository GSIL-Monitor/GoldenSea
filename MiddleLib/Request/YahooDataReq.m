//
//  YahooDataReq.m
//  GSGoldenSea
//
//  Created by frank weng on 16/8/25.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "YahooDataReq.h"

@implementation YahooDataReq

-(NSString*)toYahooSTKID:(NSString*)engSTKID
{
    NSString* yahooID;
    if([engSTKID hasPrefix:@"SH"]){
        yahooID = [NSString stringWithFormat:@"%@.SS",[engSTKID substringFromIndex:2]];
    }else{
        yahooID = [NSString stringWithFormat:@"%@.SZ",[engSTKID substringFromIndex:2]];
    }
    
    return yahooID;
}

+(YahooDataReq*)requestWith:(STKModel*)reqModel
{
    NSString* url = @"http://ichart.yahoo.com/table.csv?s=600126.SS&g=d";
    YahooDataReq* req = [[YahooDataReq alloc]initWithUrl:url];
    return req;
}

@end
