//
//  NSString+ex.m
//  GSGoldenSea
//
//  Created by frank weng on 16/11/8.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "NSString+ex.h"

@implementation NSString (ex)


- (BOOL)isValidString
{
    if(!self || 0 == self.length ){
        return NO;
    }
    
    // 过滤空格
    NSString* newStr = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if((0 == newStr.length) || [newStr isEqualToString:@"(null)"]){
        return NO;
    }
    
    return YES;
}

@end
