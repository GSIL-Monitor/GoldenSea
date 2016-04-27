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


@implementation KDataModel

-(id)init
{
    if(self = [super init]){
        self.open = kInvalidData_Base+1;
        self.close = kInvalidData_Base+1;
        self.high = kInvalidData_Base+1;
        self.low = kInvalidData_Base+1;
    }
    
    return self;
}

@end



@implementation KDataReqModel


@end