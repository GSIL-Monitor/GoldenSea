//
//  HYDBManager.m
//  HYBaseProject
//
//  Created by frank weng on 16/6/21.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "HYDBManager.h"
#import "HYDatabaseHelper.h"

#import "STKDBService.h"

@interface HYDBManager()

@property (nonatomic, strong) HYDatabaseHelper        *DBHelper;
@property (strong) NSMutableDictionary* stkdbDict;

@end

@implementation HYDBManager

SINGLETON_GENERATOR(HYDBManager, defaultManager)

-(id)init
{
    if(self = [super init]){
        _stkdbDict = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void)setupDB
{
    self.DBHelper = [HYDatabaseHelper defaultHelper];
    [self.DBHelper setupDB];
    
   
    
    [[STKDBService shareManager]setup];
    if([[STKDBService shareManager]createTableWithName:@"tSTKBasicInfo"]){
        DDLogInfo(@"STK table create success!");
    }
    
   
}

- (BOOL)closeDB
{
    BOOL rst = [self.DBHelper closeDB];
    return rst;
}


-(KDataDBService*)dbserviceWithSymbol:(NSString*)symbol
{
    KDataDBService* dataDBService = [self.stkdbDict safeValueForKey:symbol];
    if(!dataDBService){
        dataDBService = [[KDataDBService alloc]init];
        [dataDBService setup];
        [dataDBService createTableWithName:symbol];
        [self.stkdbDict safeSetValue:dataDBService forKey:symbol];
    }
    
    return dataDBService;
}

@end
