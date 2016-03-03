//
//  Constants.h
//

#ifndef HYFrameDemo_Constants_h
#define HYFrameDemo_Constants_h

//item url link for web
#define ITEM_WEB_LINK(id) [NSString stringWithFormat:@"http://detail._.com/item.htm?id=%@",id]

// sqlite defines
#define DATABASE_FILENAME [NSString stringWithFormat:@"%@.db",RCSUserPhone]

#define RCSUserPhone   [RCSUtils getCurrentUserPhoneNumber]   //当前用户的号码
#define RCSUserId      [RCSUtils getCurrentUserId]

//数据库对表如果有改动，请对version加1，并且写更新数据库代码
#define DATABASE_VERSION 1  // 此宏已废弃不用

// 图片缓存目录
#define IMAGE_CACHE_DIR             @"ImageCaches"
#define IMAGE_CACHE_OWNED_DIR       @"Owned"

// BannerList一级数据缓存
#define BANNER_LIST_NAME            @"bannerList.data"

// 存储数字提示相关数据的文件
#define HINT_NUM_FILE_NAME          @"hintNum"

#define __APP_CN_LINK @""

// 本地保存的用户名
#define HY_HISTORY_LOGIN_USERINFO @"historyLoginUserInfo"

// 下拉刷新的高度
#define kRefreshViewHeight      65.0

#define TBMBProgressHUD MBProgressHUD

#endif
