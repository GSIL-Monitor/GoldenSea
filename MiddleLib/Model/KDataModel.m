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

@end



@implementation KDataReqModel


@end