//
//  CommonMacros.h
//

#import "UIDeviceEX.h"

#ifndef iPhone_CommonMacros_h
#define iPhone_CommonMacros_h

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//debug
#ifdef DEBUG
#define GSLogRect(r) NSLog(@"(%.1fx%.1f)-(%.1fx%.1f)", r.origin.x, r.origin.y, r.size.width, r.size.height)
#define GSLogSize(r) NSLog(@"(%.1fx%.1f)", r.width, r.height)
#define GSLogPoint(r) NSLog(@"(%.1fx%.1f)", r.x, r.y)
#else
#define GSLogPoint(r) ;
#define GSLogRect(r) ;
#define GSLogSize(r) ;
#endif


#ifdef DEBUG
#define GSAssert(expression, ...) \
do { \
if (!(expression)) { \
NSLog(@"%@", [NSString stringWithFormat: @"Assertion failure: %s in %s on line %s:%d. %@", #expression, __PRETTY_FUNCTION__, __FILE__, __LINE__, [NSString stringWithFormat:@"" __VA_ARGS__]]); \
abort(); \
} \
} while(NO)
#else
#define GSAssert(expression, ...) ;
#endif


#ifdef DEBUG
#define GSFunctionPerformancePeriodTest(func, expectedLife, msg) \
{ \
NSDate *start = [NSDate date]; \
{ \
func; \
} \
NSDate *end = [NSDate date]; \
NSTimeInterval cost = [end timeIntervalSinceDate:start]; \
NSLog(@"\r\n---Performance Test(%@) cost: %f---\r\n", msg, cost); \
if (cost > expectedLife) { \
NSAssert(0, @"GSFunctionPerformancePeriodTest failed!!!"); \
} \
}
#else
#define GSFunctionPerformancePeriodTest(func, expectedLife, msg) \
{ \
func; \
}
#endif

#define __FUNC_NAME__ NSLog(NSStringFromSelector(_cmd));


////////////////////////////////////////////////////////////////////////////////
// safe action
////////////////////////////////////////////////////////////////////////////////
//weakself
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;


#define SafeCFRelease(p) \
do { \
if (p) { \
CFRelease(p); \
p = NULL; \
} \
} while(NO)


#define SafeFree(p) \
do { \
if (p) { \
free(p); \
p = nil; \
} \
} while(NO)

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// UI相关
#define DEFAULT_IMAGE_COLOR_IPHONE  0xdedede

// 屏幕方向 (在IOS 6之前并且在window makeKeyAndVisible那个runloop内无效)
#define CURRENT_ORIENTATION                 [[UIApplication sharedApplication] statusBarOrientation]
#define CURRENT_ORIENTATION_IS_LANDSCAPE    UIInterfaceOrientationIsLandscape(CURRENT_ORIENTATION)
#define CURRENT_ORIENTATION_IS_PORTRAIT     UIInterfaceOrientationIsPortrait(CURRENT_ORIENTATION)

// 屏幕尺寸
#define SCREEN_SIZE         [UIScreen mainScreen].bounds.size
#define SCREEN_WIDTH        SCREEN_SIZE.width
#define SCREEN_HEIGHT       SCREEN_SIZE.height
#define SCREEN_SCALE        [UIDevice currentDevice].screenScale

//vc中view的尺寸，考虑到个人热点连接状态下，view下移的情况
#define VIEW_HEIGHT         self.view.frame.size.height

#define SCREEN_Native_WIDTH     [UIScreen mainScreen].nativeBounds.size.width
#define SCREEN_Native_HEIGHT    [UIScreen mainScreen].nativeBounds.size.height

#define IPHONE_6_HEIGHT 667.0f

#define SCREEN_WIDTH_SCALE (SCREEN_WIDTH/375.0f)

#define SCREEN_ORIENTATION_WIDTH    MAX(SCREEN_HEIGHT, SCREEN_WIDTH)
#define SCREEN_ORIENTATION_HEIGHT   MIN(SCREEN_HEIGHT, SCREEN_WIDTH)

#define IS_IPHONE           (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5         (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_IPAD             (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_4INCH_SCREEN (SCREEN_HEIGHT == 568.f)

#define IS_RETINA_SCREEN    [[UIDevice currentDevice] isRetinaScreen]

// 状态栏尺寸
#define STATUS_BAR_SIZE     [UIApplication sharedApplication].statusBarFrame.size
#define STATUS_BAR_WIDTH    MAX(STATUS_BAR_SIZE.height, STATUS_BAR_SIZE.width)
#define STATUS_BAR_HEIGHT   MIN(STATUS_BAR_SIZE.height, STATUS_BAR_SIZE.width)

// 开始绘制阴影
#define SHADOW_START_WITH_PARAMS(context, uicolor, width, height, blur)\
CGContextSaveGState(context);\
CGContextSetShadowWithColor(context, CGSizeMake(width, height), blur, uicolor.CGColor);

// 结束阴影绘制
#define SHADOW_STOP_WITH_PARAMS(context)     \
CGContextRestoreGState(context);

// RGB颜色
#define RGBCOLOR(r,g,b)     [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define HEXRGBCOLOR(h)      RGBCOLOR(((h>>16)&0xFF), ((h>>8)&0xFF), (h&0xFF))
#define HEXRGBACOLOR(h,a)   RGBACOLOR(((h>>16)&0xFF), ((h>>8)&0xFF), (h&0xFF), a)

#define CLEARCOLOR          [UIColor clearColor]
#define IOS7NavColor        [UIColor colorWithRed:174/255.0 green:6/255.0 blue:15/255.0 alpha:1]

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// 字符串处理

#define HYString(key)       NSLocalizedString(key, @"")
#define HYLocalizedString(key)       NSLocalizedString(key, @"")
#define NONILString(str)    (str? str: @"")
#define ZEROString(str)     (str? str: @"0")


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// Device相关

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

// 是否是iOS 7或者更高版本
#define IS_IOS7_OR_HIGHER       SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")

// 是否是iOS 8或者更高版本
#define IS_IOS8_OR_HIGHER       SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// Math
#define FLOAT_EQUAL(f1, f2)     ((fabs(f1-f2) < FLT_EPSILON) ? YES : NO)

////////////////////////////////////////////////////////////////////////////////
// SDK 版本兼容
#ifdef __IPHONE_7_0

#define UITextAlignment       NSTextAlignment
#define UITextAlignmentLeft   NSTextAlignmentLeft
#define UITextAlignmentCenter NSTextAlignmentCenter
#define UITextAlignmentRight  NSTextAlignmentRight

#define UILineBreakMode                       NSLineBreakMode
#define UILineBreakModeWordWrap               NSLineBreakByWordWrapping
#define UILineBreakModeCharacterWrap          NSLineBreakByCharWrapping
#define UILineBreakModeClip                   NSLineBreakByClipping
#define UILineBreakModeHeadTruncation         NSLineBreakByTruncatingHead
#define UILineBreakModeTailTruncation         NSLineBreakByTruncatingTail
#define UILineBreakModeMiddleTruncation       NSLineBreakByTruncatingMiddle

#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
#define kCGImageAlphaPremultipliedFirst  (kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst)
#define kCGImageAlphaPremultipliedLast   (kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast)
#else
#define kCGImageAlphaPremultipliedFirst  kCGImageAlphaPremultipliedFirst
#define kCGImageAlphaPremultipliedLast   kCGImageAlphaPremultipliedLast
#endif

////////////////////////////////////////////////////////////////////////////////
// iOS 7 界面适配
#ifdef __IPHONE_7_0
#define ADJUST_VIEW_FOR_IOS7(viewController, view) \
if ([viewController respondsToSelector:@selector(edgesForExtendedLayout)]){ \
    UIRectEdge rectEdge = viewController.edgesForExtendedLayout; \
    if (rectEdge & UIRectEdgeTop){ \
        float top = [[UIApplication sharedApplication] statusBarFrame].size.height + viewController.navigationController.navigationBar.height; \
        CGRect frame = view.frame; \
        frame.origin.y += top; \
        view.frame = frame; \
    } \
}
#else
#define ADJUST_VIEW_FOR_IOS7(viewController, view)
#endif

#ifdef __IPHONE_7_0
#define ADJUST_SCROLLVIEW_FOR_IOS7(viewController, scrollView) \
if ([viewController respondsToSelector:@selector(edgesForExtendedLayout)]){ \
    UIRectEdge rectEdge = viewController.edgesForExtendedLayout; \
    if (rectEdge & UIRectEdgeTop){ \
        float top = [[UIApplication sharedApplication] statusBarFrame].size.height + viewController.navigationController.navigationBar.height; \
        scrollView.contentInset = UIEdgeInsetsMake(scrollView.contentInset.top+top, scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right); \
        scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(scrollView.scrollIndicatorInsets.top+top, \
                                                            scrollView.scrollIndicatorInsets.left, \
                                                            scrollView.scrollIndicatorInsets.bottom, \
                                                            scrollView.scrollIndicatorInsets.right); \
    } \
}
#else
#define ADJUST_SCROLLVIEW_FOR_IOS7(viewController, scrollView)
#endif

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// 设计模式

// 单例模式
#define SINGLETON_GENERATOR(class_name, shared_func_name)    \
static class_name * s_##class_name = nil;                       \
+ (class_name *)shared_func_name                                \
{                                                               \
    static dispatch_once_t once;                                \
    dispatch_once(&once, ^{                                     \
        s_##class_name = [[super allocWithZone:NULL] init];     \
    });                                                         \
    return s_##class_name;                                      \
}                                                               \
+ (class_name *)allocWithZone:(NSZone *)zone                    \
{                                                               \
    return s_##class_name;                                      \
}                                                               \
- (class_name *)copyWithZone:(NSZone *)zone                     \
{                                                               \
    return self;                                                \
}                                                               \

// 配合SINGLETON_GENERATOR 返回静态实例
#define SINGLETON_SHARED_INSTANCE(class_name)    s_##class_name

// 用在init中检测是否已经init过
#define SINGLETON_CHECK_INITED(class_name)                   \
{if (SINGLETON_SHARED_INSTANCE(class_name)) return SINGLETON_SHARED_INSTANCE(class_name);}

/// generate keyboard notifications
#define GENERATE_KeyboardNotification -(void)viewWillAppear:(BOOL)animated{ [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil]; [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];} -(void)viewWillDisappear:(BOOL)animated{[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];}
#define DEFAULT_TEXT_KEYBOARD_OFFSET 7.0f


#endif
