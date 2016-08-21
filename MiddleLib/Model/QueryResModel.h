//
//  QueryResModel.h
//  GSGoldenSea
//
//  Created by frank weng on 16/8/19.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "HYBaseModel.h"

@interface QueryResModel : HYBaseModel

@property (nonatomic, strong) NSString* stkID;
@property (assign) long time;
@property (nonatomic, assign) CGFloat pvLast2kTP1DataMA5;
@property (nonatomic, assign) CGFloat buyVal;
@end
