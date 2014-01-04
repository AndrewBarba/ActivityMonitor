//
//  NSDate+AB.h
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/3/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (AB)

/**
 * return: 1993-4-8
 */
- (NSString *)simpleStringRespresentation;

/**
 * return: April 8th, 1993
 */
- (NSString *)longStringRepresentation;

/**
 * 12:30:00
 */
- (NSString *)timeStringRepresentation;

/**
 * 8:45pm
 */
- (NSString *)prettyTimeRepresentation;

/**
 * Converts the current UTC date to a localized date form the current locale
 */
- (NSDate *)localizedDate;

/**
 * Returns todays date with specified hour and minutes
 */
- (NSDate *)dateWithHour:(NSInteger)hour andMinute:(NSInteger)minute;

/**
 * Returns a day from 2am - 2am
 */
- (NSDate *)diaryDate;

/**
 * Adds one day to date
 */
- (NSDate *)tomorrow;

/**
 * Removes one day to date
 */
- (NSDate *)yesterday;

- (NSDate*)dateByAddingUnit:(NSCalendarUnit)unit
                     offset:(NSInteger)offset;

- (NSString *)dayOfWeek;

- (BOOL)isToday;

/**
 * Compares the day of this date and given date
 */
- (BOOL)isSameDayAsDate:(NSDate *)date;

/**
 * Is the current date later than the given date
 */
- (BOOL)isLaterThanDate:(NSDate *)otherDate;

@end
