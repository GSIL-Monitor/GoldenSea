//
//  YahooDataReq.h
//  GSGoldenSea
//
//  Created by frank weng on 16/8/25.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "HYBaseRequest.h"
#import "STKModel.h"

/**
 *  Yahoo data had many mistadk -_-.
 */
@interface YahooDataReq : HYBaseRequest

+(YahooDataReq*)requestWith:(STKModel*)reqModel;


@end
