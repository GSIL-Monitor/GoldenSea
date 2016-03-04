//
//  KDayRequest.h
//  GSGoldenSea
//
//  Created by frank weng on 16/2/26.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "HYBaseRequest.h"
#import "KDataModel.h"





@interface KDataRequest : HYBaseRequest

+(KDataRequest*)requestWith:(KDataReqModel*)reqModel;


@end
