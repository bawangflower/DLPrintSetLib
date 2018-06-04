//
//  DateHandler.m
//  slh_split
//
//  Created by keqiang xu on 12-4-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DLDateHandler.h"
#import "NSBundle+DLFoundationLib.h"

#define Sunday    DLLocalizedString(@"日")
#define Monday    DLLocalizedString(@"一")
#define Tuesday   DLLocalizedString(@"二")
#define Wednesday DLLocalizedString(@"三")
#define Thursday  DLLocalizedString(@"四")
#define Friday    DLLocalizedString(@"五")
#define Saturday  DLLocalizedString(@"六")

@implementation DLDateHandler

static NSDateFormatter *dateFormat = nil, *datetimeFormat=nil, *datetimeFormat24=nil ;

+(void) initDateFormate {
    if (dateFormat == nil) {
        dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"]; 
        
        datetimeFormat = [[NSDateFormatter alloc] init];
        [datetimeFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; 
        
        datetimeFormat24 = [[NSDateFormatter alloc] init];
        [datetimeFormat24 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
    }
   
}

+(NSString *) getCurDate {
    [self initDateFormate];
    return  [dateFormat stringFromDate:[NSDate date]];
}
+(NSString *) getCurDateTime {
    [self initDateFormate];
    return  [datetimeFormat stringFromDate:[NSDate date]];
}

+(NSString *) getCurDateTime24 {
    [self initDateFormate];
    return  [datetimeFormat24 stringFromDate:[NSDate date]];
}

+(long) getWeekday:(NSString *)s_date {
    NSDate *date = [dateFormat dateFromString:s_date];
     NSCalendar* cal = [NSCalendar currentCalendar];
     NSDateComponents* comp = [cal components:NSCalendarUnitWeekday fromDate:date];
    if ([comp weekday] == 1 ) {
        return 7;
    }
    return [comp weekday]-1;
}
+(NSString *) getWeekdayAsString:(NSString *)s_date {
    NSDate *date = [dateFormat dateFromString:s_date];
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comp = [cal components:NSCalendarUnitWeekday fromDate:date];
    if ([comp weekday] == 1 ) {
        return Sunday;
    }
    long weekday = [comp weekday]-1;
    if (weekday == 1) {
        return Monday;
    }else if (weekday == 2) {
        return Tuesday;
    }else if (weekday == 3) {
        return Wednesday;
    }else if (weekday == 4) {
        return Thursday;
    }else if (weekday == 5) {
        return Friday;
    }else if (weekday == 6) {
        return Saturday;
    }
    return @"";
}

+(NSDate *) addDays:(long) days date1:(NSDate *)date1 {
    return [date1 dateByAddingTimeInterval:( days*60*60*24)];
}

+(NSDate *) addDays:(int) days s_date:(NSString *)s_date {
    [self initDateFormate];
    NSDate *date1 = [dateFormat dateFromString:s_date];
    return [date1 dateByAddingTimeInterval:( days*60*60*24)];
}

+(NSString *) addDaysAsString:(int) days s_date:(NSString *)s_date {
    NSDate *date1 = [self addDays:days s_date:s_date];
    return [dateFormat stringFromDate:date1];

}

+(long) getCurHourBy24 {
     NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comp = [cal components:NSCalendarUnitHour fromDate:[NSDate date]];
    return comp.hour;
}


+(NSDate *) getMondayDateByToday {
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDate *today = [NSDate date];
    NSDateComponents* comp = [cal components:NSCalendarUnitWeekday fromDate:today];
    if ([comp weekday] == 2) {
        return today;
    }else if ([comp weekday] == 1) {
        return [self addDays:-6 date1:today];;
    }else {
        return [self addDays:-[comp weekday]+2 date1:today];
    }
}

+(NSString *) getMondayDateByTodayAsString {
    NSDate *date1 = [self getMondayDateByToday];
    [self initDateFormate];
    return  [dateFormat stringFromDate:date1];
}

//返回String类型的Array;
+(NSMutableArray *) getMonthRange {
    NSMutableArray *a_s = [[NSMutableArray alloc] init];
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDate *today = [NSDate date];
     [self initDateFormate];
    NSString *yearMonth =[[dateFormat stringFromDate:today] substringToIndex:7];
    NSRange days = [cal rangeOfUnit:NSCalendarUnitDay   inUnit:NSCalendarUnitMonth forDate:today];
    [a_s addObject:[NSString stringWithFormat:@"%@-01", yearMonth] ];
    [a_s addObject:[NSString stringWithFormat:@"%@-%ld", yearMonth, (long)days.length] ];
    return a_s;
}

//取两个日期的天数子差；date1-date2;
+(long) getDiffdays:(NSString *)date1 date2:(NSString *)date2 {
    [self initDateFormate];
    NSDate *d_date1 = [dateFormat dateFromString:date1];
     NSDate *d_date2 = [dateFormat dateFromString:date2];
    NSUInteger unitFlags = NSCalendarUnitDay;
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:unitFlags fromDate:d_date2 toDate:d_date1 options:0];
    return [components day];
}

//如果date2是第二天，小时数会加上；
+(long) getDiffHour:(NSString *)date1 date2:(NSString *)date2 {
    [self initDateFormate];
    NSDate *d_date1 = [datetimeFormat24 dateFromString:date1];
    NSDate *d_date2 = [datetimeFormat24 dateFromString:date2];
    NSUInteger unitFlags = NSCalendarUnitHour;
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:unitFlags fromDate:d_date2 toDate:d_date1 options:0];
    return [components hour];
}

+(BOOL) checkSDateValid:(NSString *)s_date {
    [self initDateFormate];
    @try {
        if (s_date.length == 8) {
            s_date = [NSString stringWithFormat:@"20%@", s_date];
        }
         NSDate *d_date1 = [dateFormat dateFromString:s_date];
        if (d_date1 == nil) {
            return FALSE;
        }
        return TRUE;
    }
    @catch (NSException *exception) {
        return FALSE;
    }
 
   
}
@end
