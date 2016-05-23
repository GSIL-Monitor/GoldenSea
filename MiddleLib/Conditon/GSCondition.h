//
//  GSCondition.h
//  GSGoldenSea
//
//  Created by frank weng on 16/5/23.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ShapeCondition_Null = 0,
    ShapeCondition_WaiBaoRi_Down,
    ShapeCondition_WaiBaoRi_Up,
    ShapeCondition_FanZhuanRi_Down,
    ShapeCondition_FanZhuanRi_Up
}ShapeCondition;

@interface GSCondition : NSObject

+(GSCondition*)shareManager;


@end
