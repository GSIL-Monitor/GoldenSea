//
//  TBProtocolConstantsEX.h
//

#ifndef _Client_iPhone_TBProtocolConstantsEX_h
#define _Client_iPhone_TBProtocolConstantsEX_h

typedef enum{
    limit,
    tjb,
    mjs,
    promotion,
    shopvip,
    none
} PromotionType;

typedef enum{
    cartTypeAll
} CartType;

typedef enum{
    configTypeSeller,
    configTypeActivity
} CartConfigType;

typedef enum{
    commonCartDatatypeMode,
    orderCartDatatypeMode
} CartDatatypeMode;

#define EMPTYSTRING @""

//*******************local file name*********************//

#define LOCAL_SEARCH_HISTORY        @"localSearchHistory.plist"
#define LOCAL_LIKE                  @"localLike.plist"

//*******************all kinds of default value***********//

#define DEFAULT_PAGE_NO         1
#define DEFAULT_PAGE_SIZE       10
#define DEFAULT_ORDER_TYPE      @"guarantee_trade,auto_delivery,ec,cod,super_market_trade,eticket,step"
#define DEFAULT_ZERO            0
#define DEFAULT_ONE             1
#define DEFAULT_MAX_LIKE_SIZE   200

#define DEFAULT_SEARCH_HISTORY_SIZE     10

#define TRUE_STRING        @"true"
#define FALSE_STRING       @"false"
#define SYMBOL_AND         @"&"
#define SYMBOL_COLON       @":"
#define SYMBOL_SPACE       @" "
#define SYMBOL_SEMICOLON   @";"
#define SYMBOL_COMMA       @","
#define SYMBOL_EQUAL       @"="
#define SINGLE_BACK_SLASH  @"\\"
#define DOUBLE_BACK_SLASH  @"\\\\"
#define DEFAULT_STRING     @"default"
#define DEFAULT_ALL        @"all"
#define DEFAULT_HTTP_HEADER @"http://"

#define IMAGE_SHORT_URL_EXPRESSION   @"http://img0%@.taobaocdn.com/tps/%@"

#define TRADE_TAG_AUCTION           8
#define TRADE_TAG_FIXPRICE          16
#define TRADE_TAG_DIRECTCHARGE      32
#define TRADE_TAG_AUTOPOST          64
#define TRADE_TAG_GROUPON           128
#define TRADE_TAG_VIRTUAL           256
#define TRADE_TAG_HOTEL             512
#define TRADE_TAG_TRAVEL            1024

#define ITEM_TAG_MALL               4
#define ITEM_TAG_VIRTUAL            16
#define ITEM_TAG_PCKILL             32
#define ITEM_TAG_WAPKILL            64
#define ITEM_TAG_KOUBEI             128
#define ITEM_TAG_TICKET             256
#define ITEM_TAG_SUPERMARKET        512
#define ITEM_TAG_TOGO               1024
#define ITEM_TAG_BEHALF             2048
#define ITEM_TAG_COIN               4096
#define ITEM_TAG_HOUSE              8192
#define ITEM_TAG_JU                 16384
#define ITEM_TAG_MEDICINE           32768
#define ITEM_TAG_DIGITAL            65536
#define ITEM_TAG_PRESELL            (1<<25)
#define ITEM_TAG_PREORDER           (1<<27)
#define ITEM_TAG_DAMIAO             (1<<29)
#define ITEM_TAG_DIANQICHENG        (1<<30)

#define PIC_POSTFIX_MIDDLE_RESOLUTION       @"_120x120.jpg"

#define PIC_POSTFIX_IMAGE_60    @"_60x60.jpg"
#define PIC_POSTFIX_IMAGE_120   @"_120x120.jpg"
#define PIC_POSTFIX_IMAGE_170   @"_170x170.jpg"
#define PIC_POSTFIX_IMAGE_200   @"_200x200.jpg"
#define PIC_POSTFIX_IMAGE_250   @"_250x250.jpg"
#define PIC_POSTFIX_IMAGE_310   @"_310x310.jpg"


#define FIELDS_TRADES_BOUGHT_GET        @"alipay_no,seller_nick,buyer_nick,title,type,created,sid,tid,seller_rate,buyer_rate,status,payment,discount_fee,adjust_fee,post_fee,total_fee,pay_time,end_time,modified,consign_time,buyer_obtain_point_fee,point_fee,real_point_fee,received_payment,commission_fee,pic_path,num_iid,num_iid,num,price,cod_fee,cod_status,shipping_type,receiver_name,receiver_state,receiver_city,receiver_district,receiver_address,receiver_zip,receiver_mobile,receiver_phone,has_yfx,yfx_fee,yfx_id,orders.title,orders.pic_path,orders.price,orders.num,orders.iid,orders.num_iid,orders.sku_id,orders.refund_status,orders.status,orders.oid,orders.total_fee,orders.payment,orders.discount_fee,orders.adjust_fee,orders.sku_properties_name,orders.item_meal_name,orders.buyer_rate,orders.seller_rate,orders.outer_iid,orders.outer_sku_id,orders.refund_id,orders.seller_type"

#define FIELDS_TRADE_BOUGHT_GET        @"seller_nick, buyer_nick, title, type, created, tid, seller_rate,buyer_flag, buyer_rate, status, payment, adjust_fee, post_fee, total_fee, pay_time, end_time, modified, consign_time, buyer_obtain_point_fee, point_fee, real_point_fee, received_payment, commission_fee, buyer_memo, seller_memo, alipay_no,alipay_id,buyer_message, pic_path, num_iid, num, price, buyer_alipay_no, receiver_name, receiver_state, receiver_city, receiver_district, receiver_address, receiver_zip, receiver_mobile, receiver_phone,seller_flag, seller_alipay_no, seller_mobile, seller_phone, seller_name, seller_email, available_confirm_fee, has_post_fee, timeout_action_time, snapshot_url, cod_fee, cod_status, shipping_type, trade_memo, is_3D,buyer_email,buyer_area, trade_from,is_lgtype,is_force_wlb,is_brand_sale,buyer_cod_fee,discount_fee,seller_cod_fee,express_agency_fee,invoice_name,service_orders,credit_cardfee, orders.title, orders.pic_path, orders.price, orders.num, orders.num_iid, orders.sku_id, orders.refund_status, orders.status, orders.oid, orders.total_fee, orders.payment, orders.discount_fee, orders.adjust_fee, orders.snapshot_url,orders.timeout_action_time, orders.sku_properties_name,orders.item_meal_name, orders.item_meal_id, item_memo,orders.buyer_rate, orders.seller_rate, orders.outer_iid, orders.outer_sku_id, orders.refund_id, orders.seller_type, orders.is_oversold,orders.end_time,orders.order_from, orders, promotion_details, invoice_name"

#define FIELDS_ITEM_DESC    @"num_iid,desc"

#define FIELDS_USER_GET     @"user_id,uid,nick,sex,buyer_credit,seller_credit,location,created,last_visit,birthday,type,status,alipay_no,alipay_account,alipay_account,email,consumer_protection,alipay_bind,avatar"

#define FIELDS_SHOP_GET     @"sid,cid,title,nick,desc,bulletin,pic_path,created,modified,shop_score"

//*******************trade status value*****************//

#define TRADE_STATUS_PAY_PENDING                @"PAY_PENDING"
#define TRADE_STATUS_NO_CREATE_PAY              @"TRADE_NO_CREATE_PAY"
#define TRADE_STATUS_WAIT_BUYER_PAY             @"WAIT_BUYER_PAY"
#define TRADE_STATUS_WAIT_SELLER_SEND_GOODS     @"WAIT_SELLER_SEND_GOODS"
#define TRADE_STATUS_WAIT_BUYER_CONFIRM_GOODS   @"WAIT_BUYER_CONFIRM_GOODS"
#define TRADE_STATUS_BUYER_SIGNED               @"TRADE_BUYER_SIGNED"
#define TRADE_STATUS_FINISHED                   @"TRADE_FINISHED"
#define TRADE_STATUS_CLOSED                     @"TRADE_CLOSED"
#define TRADE_STATUS_CLOSED_BY_TAOBAO           @"TRADE_CLOSED_BY_TAOBAO"
#define TRADE_STATUS_ALL_WAIT_PAY               @"ALL_WAIT_PAY"
#define TRADE_STATUS_ALL_CLOSED                 @"ALL_CLOSED"
#define TRADE_STATUS_INVALID_FOR_ALIPAY         @"PLS_USE_ZFB"
#define TRADE_BUYER_PAYED_DEPOSIT               @"BUYER_PAYED_DEPOSIT"

//*******************promotion type value**********

#define PROMOTION_LIMIT         @"LIMIT"
#define PROMOTION_TJB           @"TJB"
#define PROMOTION_MJS           @"MSJ"
#define PROMOTION_SHOPVIP       @"SHOPVIP"
#define PROMOTION_PROMOTION     @"PROMOTION"

#endif
