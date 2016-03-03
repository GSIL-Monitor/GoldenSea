//
//  HYBaseModel.h
//  iRCS
//
//  Created by frank weng on 15/8/25.
//  Copyright (c) 2015年 frank weng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYBaseModel : NSObject


/**
 *  build data
 *
 *  @return json data
 */
-(NSData*) toJsonData;

/**
 *  build json dictionary
 *
 *  @return json dictionary
 */
-(NSMutableDictionary*) toDict;

/**
 *  build query string, such as mobile=18868832060&name=sheng
 *
 *  @return string
 */
-(NSString*) toQueryString;

/**
 *  init the model with json
 *
 *  @param jsonObj json dictionary
 *
 *  @return the instance
 */
-(instancetype) initFromObj:(id)jsonObj;

/**
 *  get the property Name for jsonKey， default is key. If your property name is different with the key, you should
    override this function and return the custom property name for sepecial key.
 *
 *  @param key json key
 *
 *  @return property name,
 */
-(NSString*)propetyForKey:(NSString*)key;


/**
 *  get the class name for jsonKey, default is the property's class name. for NSArray case, you should override the function and return the element class name in the array.
 *
 *  @param key json key
 *
 *  @return class name,
 */
-(NSString*)classForKey:(NSString*)key;


/**
 *  Custom set value for property key: used for that you want do get the custom property value with the orginal value by custom action, for example:
    1,the json val is string, but you want change it to NSIntger or BOOL or other..
    2,the json val is string, but you want change the string format, such as trim, etc...
 *
 *  @param val      the orig val from the json parser engine
 *  @param property property key
 *
 *  @return YES,HYBaseModel didn't do setvalue for the key action; No, HYBaseModel will do it.
 */
-(BOOL)customSetValue:(id)val forProperty:(NSString*)property;


@end
