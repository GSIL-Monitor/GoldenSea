//
//  HYBaseModel.m
//  iRCS
//
//  Created by frank weng on 15/8/25.
//  Copyright (c) 2015年 frank weng. All rights reserved.
//

#import "HYBaseModel.h"
#import "HYModelManager.h"

@implementation HYBaseModel

-(NSData*) toJsonData
{
    return nil;
}

-(NSMutableDictionary*) toDict
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    NSArray* propertyKeyArray = [self getPropertyList];

    for(NSString* pkey in propertyKeyArray){
        [dict setValue: [self valueForKey:pkey] forKey:pkey];
    }
    
    return dict;
}

-(NSString*)toQueryString
{
    NSArray* propertyKeyArray = [self getPropertyList];
    
    NSMutableString* qstring = [NSMutableString string];
    
    long i = 0;
    for(NSString* pkey in propertyKeyArray){
        NSString* value = [self valueForKey:pkey];
        if(!value){
            continue;
        }
        
        if( 0 == i ){
            [qstring appendFormat:@"?%@=%@",pkey,[self valueForKey:pkey] ];
        }else{
            [qstring appendFormat:@"&%@=%@",pkey,[self valueForKey:pkey] ];
        }
        i++;
    }
    return qstring;
}


-(instancetype) initFromObj:(id)jsonObj
{
    self = [super init];
    if(self){
        NSArray* propertyKeyArray = [self getPropertyList];
        
        if([jsonObj isKindOfClass:[NSDictionary class]]){
            NSDictionary* dict = (NSDictionary*)jsonObj;
            for (NSString* key in dict.allKeys) {
                id val = [dict valueForKey:key];
                if(!val){
                    continue;
                }
                
                NSString* pName = [self propetyForKey:key];
                if(![propertyKeyArray containsObject:pName]){
                    continue;
                }
                
                if ([self customSetValue:val forProperty:pName]) {
                    continue;
                }
                
#ifdef DEBUG
                if(![self isValidClass:pName josnValue:val]){
                    continue;
                }
#endif
                
                if( [val isKindOfClass:[NSString class]]){
                    [self setValue:val forKey:pName ];
                }else if( [val isKindOfClass:[NSNumber class]]){
                    [self setValue:val forKey:pName];
                }else if( [val isKindOfClass:[NSArray class]]){
                    NSString* pClass = [self classForKey:key];
                    if(pClass){
                        NSMutableArray* array = [NSMutableArray array];
                        for(id jsonEle in (NSArray*)val){
                            id obj = [[NSClassFromString(pClass) alloc] initFromObj:jsonEle ];
                            [array addObject:obj];
                        }
                        [self setValue:array forKey:pName];
                    }else{ //the array is contained NSString or NSNumber, not dictionary.
                        [self setValue:val forKey:pName];
                    }
                    
                   
                    
                }else if ([val isKindOfClass:[NSDictionary class]]){
                    NSString* pClass = [self classForKey:key];
                    
                    id obj = [[NSClassFromString(pClass) alloc] initFromObj:val ];
                    [self setValue:obj forKey:pName];


                }else{
                    DDLogError(@"error class type in %@", NSStringFromClass([self class]));
                }
                
            }
        }else if([jsonObj isKindOfClass:[NSArray class]]) { //array.
            
        }else{ //if other
            return jsonObj;
        }
    }
    
    return self;
}


-(NSString*)propetyForKey:(NSString*)key
{
    return key;
}


-(NSString*)classForKey:(NSString*)key
{
    return nil; //nil. default is the key
}


-(BOOL)customSetValue:(id)val forProperty:(NSString *)property
{
    return NO;
}

-(NSDictionary*) unionDictionaryFromArrayElements: (NSArray*) array
{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    for ( id item in array){
        if([item isKindOfClass:[NSDictionary class]]){
            NSDictionary* dic = item;
            for(NSString* key in dic.allKeys){
                dictionary[key] = dic[key];
            }
        }
    }
    
    return dictionary;
}


-(NSArray*)getPropertyList
{
    NSMutableArray* array = [NSMutableArray array];
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (i=0; i<outCount; i++) {
        objc_property_t property = properties[i];
        NSString * key = [[NSString alloc]initWithCString:property_getName(property)  encoding:NSUTF8StringEncoding];
        
//        NSString * key2 = [[NSString alloc]initWithCString:property_getAttributes(property)  encoding:NSUTF8StringEncoding];
//        
//        NSString* type = [self getPropetyType:property];
//
//        DDLogInfo(@"property[%d] :%@: type:%@  \n", i, key2,type);

        [array addObject:key];
    }
    
    free(properties);
    
    return array;
}

-(NSString*)getPropetyType:(objc_property_t)property
{
    NSString* ptype;
    
    NSString * pAttr = [[NSString alloc]initWithCString:property_getAttributes(property)  encoding:NSUTF8StringEncoding];
    NSRange range = [pAttr rangeOfString:@","];

    NSString* typeString = [pAttr substringWithRange:NSMakeRange(0, range.location)];
    
    
    if([typeString hasPrefix:@"T@"]){
        NSArray* array = [typeString componentsSeparatedByString:@"\""];
        ptype = [array objectAtIndex:1];
    }else{
        return NSStringFromClass([NSNumber class]);
    }
//        if([typeString isEqualToString:@"Ti"]){
//        return @"NSInteger";
//    }else if([typeString isEqualToString:@"Tc"]){
//        return @"char";
//    }else if([typeString isEqualToString:@"Td"]){
//        return @"double";
//    }else if([typeString isEqualToString:@"Tf"]){
//        return @"float";
//    }else if([typeString isEqualToString:@"Tl"]){
//        return @"long";
//    }else if([typeString isEqualToString:@"Ts"]){
//        return @"short";
//    }else if([typeString isEqualToString:@"TI"]){
//        return @"NSUInteger";
//    }else if([typeString isEqualToString:@"TL"]){
//        return @"unsigned long";
//    }else if([typeString isEqualToString:@"TS"]){
//        return @"unsigned short";
//    }
    
    return ptype;
}


#pragma mark - help function
-(BOOL)isValidClass:(NSString*)propertyName josnValue:(id)val
{
    BOOL valid = NO;
    
    if([val isKindOfClass:[NSArray class]]){
        //becuase array isn't match as defined.
        return YES;
    }
    
    
    if([val isKindOfClass:[NSDictionary class]]){
        //becuase array isn't match as defined.
        return YES;
    }
    
//    NSString* valClassString = NSStringFromClass([val class]);
    
    objc_property_t property = class_getProperty([self class], [propertyName cStringUsingEncoding:NSUTF8StringEncoding]);
    NSString* ptype = [self getPropetyType:property];
    
    valid = [val isKindOfClass:NSClassFromString(ptype)];
    
    
    if(!valid){
        GSAssert(NO, @"class(%@) kind not maped in propertyName(%@): property class(%@), json class(%@)",NSStringFromClass([self class]),propertyName,ptype,NSStringFromClass([val class]));
    }
    
    return valid;
}

@end
