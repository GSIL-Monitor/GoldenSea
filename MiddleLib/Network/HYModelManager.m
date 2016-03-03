//
//  HYModelManager.m
//  iRCS
//
//  Created by frank weng on 15/8/27.
//  Copyright (c) 2015年 frank weng. All rights reserved.
//

#import "HYModelManager.h"

@interface HYModelManager()

@property (nonatomic,strong) NSDictionary* jsonKeyDict;
@property (nonatomic,strong) NSDictionary* jsonKeyMapDict;


@end

@implementation HYModelManager


+ (HYModelManager *)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


-(void)registerJsonKey:(NSArray *)jsonKey withModel:(NSString *)modelClassString
{
    [self.jsonKeyDict setValue:jsonKey forKey:modelClassString];
}

-(NSArray*)jsonKeyWtihModel:(NSString *)modelClassString
{
    return [self.jsonKeyDict valueForKey:modelClassString];
}


-(void)registerJsonKeyMap:(NSArray *)jsonKey withModel:(NSString *)modelClassString
{
    [self.jsonKeyMapDict setValue:jsonKey forKey:modelClassString];
}



- (NSDictionary*)jsonKeyMapWtihModel:(NSString*)modelClassString
{
    return [self.jsonKeyMapDict valueForKey:modelClassString];
}



@end
