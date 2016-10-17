//
//  GSLogout.h
//  GSGoldenSea
//
//  Created by frank weng on 16/5/20.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSBaseLogout : NSObject



//@property (nonatomic, strong) NSMutableArray* paramArray;

//interface
-(void)logOutResult;


-(void)SimpleLogOutResult:(BOOL)isJustLogFail;


//log all and save to file.
-(void)analysisAndLogtoFile;

//-(void)queryAndLogtoDB;

//protected.
-(void)logSelResultWithParam:(GSBaseParam*)param;
-(void)logAllResultWithParam:(GSBaseParam*)param;

-(NSArray*)reOrderParamArray:(NSMutableArray*)array;

@end
