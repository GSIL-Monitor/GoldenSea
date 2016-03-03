//
//  NSDateEX.h
//


@interface NSDate (EX) 



// 倒计时
+ (NSString*)countdownText:(NSTimeInterval)fireDate currentDate:(NSTimeInterval)currentDate fired:(BOOL*)fired;

//NSDate+Formatter
- (NSString*)stringWithFormat:(NSString*)fmt;
+ (NSDate*)dateFromString:(NSString*)str withFormat:(NSString*)fmt;
+ (NSDate *)dateFromString:(NSString *)str withFormat:(NSString *)fmt locale:(NSLocale *)locale;
- (NSDate *)dateByAddingDays:(NSInteger)days months:(NSInteger)months years:(NSInteger)years;

-(BOOL) isLaterThanOrEqualTo:(NSDate*)date;
-(BOOL) isEarlierThanOrEqualTo:(NSDate*)date;
-(BOOL) isLaterThan:(NSDate*)date;
-(BOOL) isEarlierThan:(NSDate*)date;

@end
