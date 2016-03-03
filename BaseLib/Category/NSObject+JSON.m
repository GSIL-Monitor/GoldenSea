//
//  NSObject+JSON.m
//  LotteryAssit
//
//  Created by ios on 14-7-14.
//  Copyright (c) 2014年 goldensea. All rights reserved.
//

#import "NSObject+JSON.h"



@implementation NSString (TBJSONKitDeserializing)

- (id)tbObjectFromJSONString{
    return [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
}

- (id)tbMutableObjectFromJSONString{
    id object = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments|NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
    if ([object isKindOfClass:[NSDictionary class]]) {
        return [[NSMutableDictionary alloc] initWithDictionary:object];
    }else if ([object isKindOfClass:[NSArray class]]){
        return [[NSMutableArray alloc] initWithArray:object];
    }
    return nil;
}


- (id)objectFromJSONString{
    return [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
}


@end




@implementation NSString (JSONKitSerializing)

- (NSData *)JSONData{
    if (self != nil) {
        return [[NSArray arrayWithObject:self] JSONData];
    }
    return nil;
}

- (NSString *)JSONString{
    if (self != nil){
        return [[NSArray arrayWithObject:self] JSONString];
    }
    return nil;
}



@end


@implementation NSObject (JSON)

-(NSData*)JSONData
{
    NSError* error = nil;
    id result = nil;
    result = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    if(error){
        return nil;
    }
    
    return result;
}

-(NSString*)JSONString
{
    NSString* string = nil;
    
    NSData* data = [self JSONData];
    if(data){
        string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }else{
        return nil;
    }
    
    return string;
}

@end
