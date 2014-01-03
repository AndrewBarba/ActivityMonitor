//
//  NSDictionary+AB.m
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/3/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import "NSDictionary+AB.h"

@implementation NSDictionary (AB)

#pragma mark - Simple Getters

- (BOOL)boolForKey:(NSString *)key
{
    return [self[key] boolValue];
}

- (float)floatForKey:(NSString *)key
{
    return [self[key] floatValue];
}

- (double)doubleForKey:(NSString *)key
{
    return [self[key] doubleValue];
}

- (NSInteger)integerForKey:(NSString *)key
{
    return [self[key] integerValue];
}

- (NSNumber *)numberForKey:(NSString *)key
{
    return @([self integerForKey:key]);
}

- (NSDecimalNumber *)decimalNumberForKey:(NSString *)key
{
    return [[NSDecimalNumber alloc] initWithFloat:[self floatForKey:key]];
}

#pragma mark - Dates

- (NSDate *)dateFromTimestampAtKey:(NSString *)key
{
    NSTimeInterval interval = [self doubleForKey:key] / 1000;
    return [NSDate dateWithTimeIntervalSince1970:interval];
}

- (NSDate *)dateFromDateStringAtKey:(NSString *)key
{
    NSString *dateString = self[key];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setLocale:[NSLocale systemLocale]];
    format.dateFormat = dateString.length > 10 ? @"yyyy-MM-dd HH:mm:ss" : @"yyyy-MM-dd";
    return [format dateFromString:dateString];
}

#pragma mark - JSON

- (BOOL)containsNonEmptyJSONValueForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    if (value == nil || value == [NSNull null]) {
        return NO;
    }
    if ([value isKindOfClass:[NSString class]]) {
        NSString * stringValue = (NSString *)value;
        return (stringValue.length > 0);
    }
    return YES;
}

- (BOOL)containsNonEmptyJSONValueForKey:(NSString *)key ofClass:(Class)class
{
    if ([self containsNonEmptyJSONValueForKey:key]) {
        id val = self[key];
        return [val isKindOfClass:class];
    }
    
    return NO;
}

- (BOOL)containsNonEmptyStringValueForKey:(NSString *)key
{
    return [self containsNonEmptyJSONValueForKey:key ofClass:[NSString class]];
}

- (BOOL)containsNonEmptyDictionaryValueForKey:(NSString *)key
{
    return [self containsNonEmptyJSONValueForKey:key ofClass:[NSDictionary class]];
}

- (BOOL)containsNonEmptyArrayValueForKey:(NSString *)key
{
    return [self containsNonEmptyJSONValueForKey:key ofClass:[NSArray class]];
}

@end
