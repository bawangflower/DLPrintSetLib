//
//  DateHandler.h
//  slh_split
//
//  Created by keqiang xu on 12-4-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLDateHandler : NSObject

+(NSString *) getCurDate;

+(NSString *) getCurDateTime;

+(NSDate *) addDays:(int) days s_date:(NSString *)s_date;

+(NSString *) addDaysAsString:(int) days s_date:(NSString *)s_date ;

+(NSDate *) getMondayDateByToday;

+(NSString *) getMondayDateByTodayAsString;

+(NSMutableArray *) getMonthRange;

+(long) getCurHourBy24;

+(NSString *) getCurDateTime24;

+(long) getDiffdays:(NSString *)date1 date2:(NSString *)date2;

+(void) initDateFormate;

+(long) getWeekday:(NSString *)s_date;

+(NSString *) getWeekdayAsString:(NSString *)s_date;

+(long) getDiffHour:(NSString *)date1 date2:(NSString *)date2;

+(BOOL) checkSDateValid:(NSString *)s_date;

@end
