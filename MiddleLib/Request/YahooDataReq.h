//
//  YahooDataReq.h
//  GSGoldenSea
//
//  Created by frank weng on 16/8/25.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "HYBaseRequest.h"
#import "STKModel.h"

@interface YahooDataReq : HYBaseRequest

+(YahooDataReq*)requestWith:(STKModel*)reqModel;


@end
