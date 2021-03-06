//
//  KDayRequest.m
//  GSGoldenSea
//
//  Created by frank weng on 16/2/26.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "XueQiuDataRequest.h"

@implementation XueQiuDataRequest


+(XueQiuDataRequest*)requestWith:(KDataReqModel*)reqModel
{
    //symbol=SH000001&period=1day&type=normal&begin=1424954307755&end=1456490307755&_=1456490307755

    NSMutableString* url = [reqModel toQueryString];
    [url appendString:@"&_=1456490307755"]; 
    XueQiuDataRequest* req = [[XueQiuDataRequest alloc]initWithUrl:url];
    return req;
}

@end
