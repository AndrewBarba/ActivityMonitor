//
//  NSDate+AB.m
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/3/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import "NSDate+AB.h"

#define AB_DAY_SPLIT_HOUR 2

@implementation NSDate (AB)

- (NSString *)simpleStringRespresentation
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yyyy";
    return [dateFormatter stringFromDate:self];
}

- (NSString *)longStringRepresentation
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    dateFormatter.dateStyle = NSDateFormatterLongStyle;
    return [dateFormatter stringFromDate:self];
}

- (NSString *)timeStringRepresentation
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents* comp = [calendar components:unitFlags fromDate:self];
    return [NSString stringWithFormat:@"%li:%li:%li", (long)comp.hour, (long)comp.minute, (long)comp.second];
}

- (NSString *)prettyTimeRepresentation
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDateComponents* comp = [calendar components:unitFlags fromDate:self];
    
    NSString *hour = [NSString stringWithFormat:@"%li", (comp.hour > 12) ? (long)(comp.hour - 12) : (long)comp.hour];
    NSString *minute = [NSString stringWithFormat:@"%02li", (long)comp.minute];
    BOOL pm = comp.hour > 12;
    
    return [NSString stringWithFormat:@"%@:%@%@", hour, minute, pm ? @"pm" : @"am"];
}

- (NSDate *)dateWithHour:(NSInteger)hour andMinute:(NSInteger)minute
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:self];
    components.hour = hour;
    components.minute = minute;
    return [calendar dateFromComponents:components];
}

- (BOOL)isToday
{
    return [self isSameDayAsDate:[NSDate date]];
}

- (NSDate *)localizedDate
{
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:self];
    
    NSTimeInterval interval = [self timeIntervalSince1970];
    NSTimeInterval destinationInterval = interval - destinationGMTOffset;
    
    NSDate* destinationDate = [NSDate dateWithTimeIntervalSince1970:destinationInterval];
    return destinationDate;
}

- (BOOL)isSameDayAsDate:(NSDate *)date
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:self];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date];
    
    if (comp1.year == comp2.year && comp1.month == comp2.month) {
        if (comp1.day == comp2.day) {
            return YES;
        } else {
            if (comp1.day == comp2.day + 1) {
                return comp1.hour <= AB_DAY_SPLIT_HOUR;
            } else if (comp2.day == comp1.day + 1) {
                return comp2.hour <= AB_DAY_SPLIT_HOUR;
            }
        }
    }
    return NO;
}

- (BOOL)isLaterThanDate:(NSDate *)otherDate
{
    return (otherDate != nil) && ([self compare:otherDate] == NSOrderedDescending);
}

- (NSDate *)diaryDate
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
	NSDateComponents* comps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit
                                          fromDate:self];
    comps.hour = AB_DAY_SPLIT_HOUR;
    comps.minute = 0;
    comps.second = 0;
	NSDate* adjustedMidnight = [calendar dateFromComponents:comps];
    
    if ([adjustedMidnight isLaterThanDate:self]) {
		// date late night entries back to yesterday
        adjustedMidnight = [adjustedMidnight dateByAddingUnit:NSDayCalendarUnit offset:-1];
	}
    
	return adjustedMidnight;
}

- (NSString *)dayOfWeek
{
    NSDateFormatter* theDateFormatter = [[NSDateFormatter alloc] init];
    [theDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [theDateFormatter setDateFormat:@"EEEE"];
    NSString *weekDay =  [theDateFormatter stringFromDate:self];
    return weekDay;
}

- (NSDate*)dateByAddingUnit:(NSCalendarUnit)unit
                     offset:(NSInteger)offset
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone localTimeZone];
    calendar.locale = [NSLocale currenABocale];
    NSDateComponents* toAdd = [[NSDateComponents alloc] init];
    switch (unit) {
        case NSYearCalendarUnit:
            toAdd.year = offset;
            break;
        case NSMonthCalendarUnit:
            toAdd.month = offset;
            break;
        case NSDayCalendarUnit:
            toAdd.day = offset;
            break;
        case NSHourCalendarUnit:
            toAdd.hour = offset;
            break;
        case NSMinuteCalendarUnit:
            toAdd.minute = offset;
            break;
        case NSSecondCalendarUnit:
            toAdd.second = offset;
            break;
        default:
            @throw [NSException exceptionWithName:NSInvalidArgumentException
                                           reason:@"Unhandled calendar unit"
                                         userInfo:nil];
    }
    
    NSDate* result = [calendar dateByAddingComponents:toAdd
                                               toDate:self
                                              options:0];
    return result;
}

@end
