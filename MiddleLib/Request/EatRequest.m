//
//  EatRequest.m
//  iRCS
//
//  Created by frank weng on 15/8/25.
//  Copyright (c) 2015年 frank weng. All rights reserved.
//

#import "EatRequest.h"

@implementation EatRequest


+(EatRequest*)requestWithShopID:(long)shopID
{
    NSString* url = [NSString stringWithFormat:@"entertainments/%ld",shopID];
    EatRequest* req = [[EatRequest alloc]initWithUrl:url];
    return req;
}

-(void)donothing
{
    
}

@end
