//
//  OneDayCondition.m
//  GSGoldenSea
//
//  Created by frank weng on 16/4/27.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "OneDayCondition.h"

@implementation OneDayCondition

-(id)init
{
    self = [super init];
    if(self){
        self.open_max = 11.f;
        self.open_min = -11.f;
        
        self.close_max = 11.f;
        self.close_min = -11.f;
        
        self.high_max = 11.f;
        self.high_min = -11.f;
        
        self.low_max = 11.f;
        self.low_min = -11.f;
    }
    
    return self;
}

@end
