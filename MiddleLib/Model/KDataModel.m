//
//  KDayModel.m
//  GSGoldenSea
//
//  Created by frank weng on 16/2/26.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "KDataModel.h"

@implementation KFullDataModel

-(NSString*)classForKey:(NSString *)key
{
    if([key isEqualToString:@"chartlist"]){
        return NSStringFromClass([KDataModel class]);
    }
    
    return [super classForKey:key];
}

@end

@implementation DebugData


@end




@implementation DVDebugData

-(id)init
{
    if(self = [super init]){

        
        self.dvT0 = [[DVValue alloc]init];
        self.dvTP1 = [[DVValue alloc]init];
        self.dvT1 = [[DVValue alloc]init];
        self.dvT2 = [[DVValue alloc]init];
        
        self.dvAvgTP1toTP5 = [[DVValue alloc]init];
        
    }
    
    return self;
}

@end

@implementation TradeDebugData


@end

@implementation UnitDebugData
-(id)init
{
    if(self = [super init]){
        self.monthLow = kInvalidData_Base+1;
        self.weekLow = kInvalidData_Base+1;
        self.monthOpen = kInvalidData_Base+1;
        self.weekOpen = kInvalidData_Base+1;
    }
    
    return self;
}


@end


@implementation DVValue

-(id)init
{
    if(self = [super init]){
        self.dvOpen = kInvalidData_Base+1;
        self.dvHigh = kInvalidData_Base+1;
        self.dvLow = kInvalidData_Base+1;
        self.dvClose = kInvalidData_Base+1;
        
    }
    
    return self;
}


@end


@implementation KDataModel

-(id)init
{
    if(self = [super init]){
        self.open = kInvalidData_Base+1;
        self.close = kInvalidData_Base+1;
        self.high = kInvalidData_Base+1;
        self.low = kInvalidData_Base+1;
        
        self.dvDbg = [[DVDebugData alloc]init];
        self.tradeDbg = [[TradeDebugData alloc]init];
        self.unitDbg = [[UnitDebugData alloc]init];
    }
    
    return self;
}

-(BOOL)isYiZi
{
    if(fabs(self.high-self.low)<0.01){
        return YES;
    }
    
    return NO;
}

-(BOOL)isRed
{
    long iClose = self.close*100;
    long iOpen = self.open*100;
    if(iClose >= iOpen){
        return YES;
    }
    
    return NO;
}

-(BOOL)getBuyValue:(CGFloat)destBuyValue;
{
    if([self isYiZi]){
        return NO;
    }
    
    if(destBuyValue > self.low){
        return YES;
    }
    
    return NO;
}

@end



@implementation KDataReqModel


@end
