//
//  MonthStatAnalysisMgr.h
//  GSGoldenSea
//
//  Created by frank weng on 16/11/8.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "GSBaseAnalysisMgr.h"

@interface STKResult : NSObject
@property (nonatomic, strong) NSString* stkID;
@property (nonatomic, assign) CGFloat avgDV;
@property (nonatomic, strong) NSMutableArray* eleArray;
@end



@interface STATAnalysisMgr : GSBaseAnalysisMgr
@property (nonatomic, strong) NSMutableArray* statResultArray;
@end