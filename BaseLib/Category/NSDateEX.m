//
//  NSDateEX.m
//

#import "NSDateEX.h"

@implementation NSDate (EX) 




+ (NSString*)countdownText:(NSTimeInterval)fireDate currentDate:(NSTimeInterval)currentDate fired:(BOOL*)fired
{
    if (currentDate <= fireDate)
    {
        if (fired)
            *fired = NO;
        
        int64_t gap = (int64_t)(fireDate - currentDate);
        int64_t day = gap / 86400;
        int64_t hour = (gap % 86400) / 3600;
        int64_t minute = (gap % 3600) / 60;
        int64_t second = gap % 60;
        return day > 0 ? [NSString stringWithFormat:@"%lld天%02lld:%02lld:%02lld", day, hour, minute, second] : [NSString stringWithFormat:@"%02lld:%02lld:%02lld", hour, minute, second];
    }
    else if (fired)
    {
        *fired = YES;
    }
    return @"00:00:00";
}

//NSDate+Formatter
- (NSString*)stringWithFormat:(NSString*)fmt {
    //    static NSDateFormatter *fmtter;
    //
    //    if (fmtter == nil) {
    //        fmtter = [[NSDateFormatter alloc] init];
    //    }
    
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *fmtter = [dictionary objectForKey:@"TBDateFormater"];
    
    if (fmtter == nil) {
        fmtter = [[NSDateFormatter alloc] init];
        [dictionary setObject:fmtter forKey:@"TBDateFormater"];
    }
    
    if (fmt == nil || [fmt isEqualToString:@""]) {
        fmt = @"HH:mm:ss";
    }
    
    [fmtter setDateFormat:fmt];
    
    return [fmtter stringFromDate:self];
}

+ (NSDate*)dateFromString:(NSString*)str withFormat:(NSString*)fmt {
    //    static NSDateFormatter *fmtter;
    //
    //    if (fmtter == nil) {
    //        fmtter = [[NSDateFormatter alloc] init];
    //    }
    
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *fmtter = [dictionary objectForKey:@"TBDateFormater"];
    
    if (fmtter == nil) {
        fmtter = [[NSDateFormatter alloc] init];
        [dictionary setObject:fmtter forKey:@"TBDateFormater"];
    }
    
    if (fmt == nil || [fmt isEqualToString:@""]) {
        fmt = @"HH:mm:ss";
    }
    
    [fmtter setDateFormat:fmt];
    
    return [fmtter dateFromString:str];
}


+ (NSDate *)dateFromString:(NSString*)str withFormat:(NSString*)fmt locale:(NSLocale *)locale {
    //    static NSDateFormatter *fmtter;
    //
    //    if (fmtter == nil) {
    //        fmtter = [[NSDateFormatter alloc] init];
    //    }
    
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *fmtter = [dictionary objectForKey:@"TBDateFormater"];
    
    if (fmtter == nil) {
        fmtter = [[NSDateFormatter alloc] init] ;
        [dictionary setObject:fmtter forKey:@"TBDateFormater"];
    }
    
    if (fmt == nil || [fmt isEqualToString:@""]) {
        fmt = @"HH:mm:ss";
    }
    
    [fmtter setDateFormat:fmt];
    if (locale != nil) {
        [fmtter setLocale:locale];
    }
    
    return [fmtter dateFromString:str];
}

- (NSDate *)dateByAddingDays:(NSInteger)days months:(NSInteger)months years:(NSInteger)years
{
    NSDateComponents *c = [[NSDateComponents alloc] init] ;
    c.year = years;
    c.month = months;
    c.day = days;
    return [[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0];
}


-(BOOL) isLaterThanOrEqualTo:(NSDate*)date {
    return !([self compare:date] == NSOrderedAscending);
}

-(BOOL) isEarlierThanOrEqualTo:(NSDate*)date {
    return !([self compare:date] == NSOrderedDescending);
}
-(BOOL) isLaterThan:(NSDate*)date {
    return ([self compare:date] == NSOrderedDescending);
    
}
-(BOOL) isEarlierThan:(NSDate*)date {
    return ([self compare:date] == NSOrderedAscending);
}

@end
