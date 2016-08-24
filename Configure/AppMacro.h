//
//  AppMacro.h
//  MobileApplicationPlatform
//
//  Created by zhdooo on 15/4/15.
//  Copyright (c) 2015年 gs. All rights reserved.
//

#ifndef MobileApplicationPlatform_AppMacro_h
#define MobileApplicationPlatform_AppMacro_h

/// common macro func
#define RCSDefaultNotificationCenter [NSNotificationCenter defaultCenter]

#define kInvalidData_Base 1000000.f
#define kInvalidData_Base_Small (kInvalidData_Base-1)




#define GetDVValue(dest,base) ((dest - base)*100.f/base)











//http://xueqiu.com/stock/forchartk/stocklist.json?symbol=SH000001&period=1day&type=normal&begin=1424954307755&end=1456490307755&_=1456490307755

#ifdef DEBUG
//#define Server_BaseURL @"http://183.131.13.86:9080"   //product server url
#define Server_BaseURL @"http://xueqiu.com/stock/forchartk/stocklist.json"   //test server url
#define Analysis_Key @"43200ad8f2284f869db47ab741c81bdf"
#define XiaoPush_Cert_File @"develop"
#define MAMapServices_ApiKey @"a989b813f4dfcbe2aa4e4305ce2a60cf"

#else
//#define Server_BaseURL @"http://183.131.13.86:9080"   //product server url
#define Server_BaseURL @"http://xueqiu.com/stock/forchartk/stocklist.json"   //test server url
#define Analysis_Key @"d0833d2b161246799c66c524a89d78b4"
#define XiaoPush_Cert_File @"product"
#define MAMapServices_ApiKey @"6823fabb9770b182f268bf4b227939b2"

#endif


#define DDLogInfo NSLog
#define DDLogError NSLog


#define Timeout_uploadImage     (dispatch_time(DISPATCH_TIME_NOW,(NSEC_PER_SEC*45)))
#define Timeout_commonRestService     (dispatch_time(DISPATCH_TIME_NOW,(NSEC_PER_SEC*30)))

#endif




/// util
//提示信息显示时间
#define RCSHUD_DURATION 1.4f

//默认倒计时时间
#define DEFAULT_COUNTDOWN_TIME 60
#define DEFAULT_TIMER_DELAY 1.7f
#define DEFAULT_ANIMATE_TIME 0.3f

// 手机号长度
#define PHONE_LENGTH 11
