//
//  EatModel.m
//  iRCS
//
//  Created by frank weng on 15/8/27.
//  Copyright (c) 2015年 frank weng. All rights reserved.
//

#import "EatModel.h"
#import "EntermaintModel.h"

@implementation EatChild



@end

@implementation EatModel

-(NSString*)propetyForKey:(NSString *)key
{
    if([key isEqualToString:@"title"]){
        return  NSStringFromSelector(@selector(theTitle));
    }else if ([key isEqualToString:@"hasCoverImage"]){
        return NSStringFromSelector(@selector(hasCoverImage));
    }
    
    return [super propetyForKey:key];
}


-(NSString*)classForKey:(NSString *)key
{
    if([key isEqualToString:@"entertainment_info"]){
        return NSStringFromClass([EntermaintModel class]);
    }
    
    return [super classForKey:key];
}


-(BOOL)customSetValue:(id)val forProperty:(NSString *)property
{
    if ([property isEqualToString:NSStringFromSelector(@selector(hasCoverImage))]) {
        NSString* theVal = (NSString*)val;
        if([theVal isEqualToString:@"jusTest"]){
            [self setValue:[NSNumber numberWithBool:YES] forKey:property];
        }else{
            [self setValue:[NSNumber numberWithBool:NO] forKey:property];
        }
        
        return YES;
    }
    
    return NO;
}

@end
