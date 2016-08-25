//
//  YahooDataReq.m
//  GSGoldenSea
//
//  Created by frank weng on 16/8/25.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "YahooDataReq.h"

@implementation YahooDataReq

+(YahooDataReq*)requestWith:(KDataReqModel*)reqModel
{    
    NSString* url = @"http://ichart.yahoo.com/table.csv?s=600126.SS&g=d";
    YahooDataReq* req = [[YahooDataReq alloc]initWithUrl:url];
    return req;
}

@end
