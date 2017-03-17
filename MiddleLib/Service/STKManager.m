//
//  STKManager.m
//  GSGoldenSea
//
//  Created by frank weng on 16/3/4.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "STKManager.h"
#import "XueQiuDataRequest.h"
#import "TKData.h"
#import "HYDatabaseHelper.h"
#import "HYDayDBManager.h"
#import "STKxlsReader.h"
#import "HYSTKDBManager.h"


@interface STKManager ()


@end

@implementation STKManager

SINGLETON_GENERATOR(STKManager, shareInstance);



-(id)init
{
    self = [super init];
    if(self){
        
        [self setupDB];
    }
    
    return self;
}

-(void)setupDB
{
//    [[HYDatabaseHelper defaultHelper] setupDB];
        
}


-(void)saveStkToDB;
{
    [[HYSTKDBManager defaultManager]setupDB:nil isReset:YES];

    
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString* xlsPath = [NSString stringWithFormat:@"%@/Code/1HelpCode/0data/11.xlsx",[paths stringByDeletingLastPathComponent]];
    //    NSString* xlsPath = [NSString stringWithFormat:@"%@/Code/1HelpCode/0data/test1.xlsx",[paths stringByDeletingLastPathComponent]];
    
    [[STKxlsReader shareInstance] startWithPath:xlsPath dbPath:nil];
}






@end
