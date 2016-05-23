//
//  KDayModel.h
//  GSGoldenSea
//
//  Created by frank weng on 16/2/26.
//  Copyright © 2016年 frank weng. All rights reserved.
//

#import "HYBaseModel.h"



/**
 *  week report:
 
 "stock": {
 "symbol": "SH600418"
	},
	"success": "true",
	"chartlist": [{
 "volume": 207328854,
 "open": 6.71,
 "high": 7.34,
 "close": 7.31,
 "low": 6.67,
 "chg": 0.6,
 "percent": 8.94,
 "turnrate": 19.33,
 "ma5": 7.31,
 "ma10": 7.31,
 "ma20": 7.31,
 "ma30": 7.31,
 "dif": 0.0,
 "dea": 0.0,
 "macd": 0.0,
 "time": "Fri Mar 02 00:00:00 +0800 2012"
	}, {}]
 */



/*
 "stock": {
 "symbol": "SH600418"
	},
	"success": "true",
	"chartlist": [{
 "volume": 26940238,
 "open": 14.37,
 "high": 14.55,
 "close": 14.4,
 "low": 14.17,
 "chg": 0.08,
 "percent": 0.56,
 "turnrate": 2.52,
 "ma5": 14.24,
 "ma10": 13.37,
 "ma20": 12.96,
 "ma30": 12.74,
 "dif": 0.44,
 "dea": 0.21,
 "macd": 0.46,
 "time": "Fri Feb 27 00:00:00 +0800 2015"
	}, {...}]
 */



//请求

//http://xueqiu.com/stock/forchartk/stocklist.json?symbol=SH000001&period=1day&type=normal&begin=1424954307755&end=1456490307755&_=1456490307755

// GET /stock/forchartk/stocklist.json?symbol=SH000001&period=1day&type=normal&begin=1424954307755&end=1456490307755&_=1456490307755 HTTP/1.1
// Host	xueqiu.com
// Accept	application/json, text/javascript, */*; q=0.01
//cache-control	no-cache
//X-Requested-With	XMLHttpRequest
//User-Agent	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.116 Safari/537.36
//Referer	http://xueqiu.com/S/SH000001
//Accept-Encoding	gzip, deflate, sdch
//Accept-Language	zh-CN,zh;q=0.8,en;q=0.6,ja;q=0.4,zh-TW;q=0.2
//Cookie	s=2xjv17wxca; bid=980a0ffa0c20398f8c5102d22f7c0733_ijf71lzw; webp=1; xq_a_token=f7f850c8cd3ad9bf4d15ed05a15d24d7c813a8e9; xqat=f7f850c8cd3ad9bf4d15ed05a15d24d7c813a8e9; xq_r_token=e09045bf8c0808a3c3aa92b0740f56428512523b; xq_is_login=1; u=9036714866; xq_token_expire=Thu%20Mar%2010%202016%2012%3A26%3A09%20GMT%2B0800%20(CST); __utmt=1; __utma=1.852695814.1452832627.1456460499.1456489019.15; __utmb=1.15.9.1456489610682; __utmc=1; __utmz=1.1452832627.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); Hm_lvt_1db88642e346389874251b5a1eded6e3=1456115149,1456460499,1456489019,1456490293; Hm_lpvt_1db88642e346389874251b5a1eded6e3=1456490293



@interface KFullDataModel : HYBaseModel
@property (nonatomic, strong) NSArray* chartlist;
@end



@interface DVValue : NSObject

@property (assign) CGFloat dvOpen;
@property (assign) CGFloat dvHigh;
@property (assign) CGFloat dvLow;
@property (assign) CGFloat dvClose;


@end


@interface KDataModel : HYBaseModel

@property (strong) NSString* time;

@property (assign) CGFloat open;
@property (assign) CGFloat high;
@property (assign) CGFloat low;
@property (assign) CGFloat close;

@property (assign) int volume;


@property (strong) KDataModel* TP1Data;
@property (strong) KDataModel* T1Data;

@property (strong) DVValue* dvT0; //dv property , percent , t value vs tp1 close
@property (strong) DVValue* dvTP1; //tp1 dv property , percent ,  tp1 vs tp2 close
@property (strong) DVValue* dvT1; //dv property , percent , t1 value vs t close

@property (strong) DVValue* dvAvgTP1toTP5; //dv property , percent , t1 value vs t close


//conditons.
@property (assign) BOOL isMeetT0DayConditonOpen;






////below is reserved.
//@property (assign) CGFloat chg; //
//@property (assign) CGFloat percent; //换手率
//@property (assign) CGFloat turnrate; //
//
//@property (assign) CGFloat ma5;
//@property (assign) CGFloat ma10;
//@property (assign) CGFloat ma20;
//@property (assign) CGFloat ma30;
//
//@property (assign) CGFloat dif;
//@property (assign) CGFloat dea;
//@property (assign) CGFloat macd;





@end







@interface KDataReqModel : HYBaseModel

@property (nonatomic,strong) NSString* symbol;
@property (nonatomic,strong) NSString* period;
@property (nonatomic,strong) NSString* begin;
@property (nonatomic,strong) NSString* end;


@end









