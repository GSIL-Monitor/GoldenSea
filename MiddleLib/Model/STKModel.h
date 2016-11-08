//
//  STKModel.h
//  GSGoldenSea
//
//  Created by frank weng on 16/3/3.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "HYBaseModel.h"

@interface STKModel : HYBaseModel

@property (nonatomic, strong) NSString* stkID;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* industry;
@property (nonatomic, strong) NSString* province;
@property (nonatomic, strong) NSString* property;
@property (nonatomic, assign) CGFloat totalMV; //market value;
@property (nonatomic, assign) CGFloat curMV; //current market value;

@property (assign) long lastUpdateTime;

@end
