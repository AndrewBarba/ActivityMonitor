//
//  NSDictionary+AB.h
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/3/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (AB)

// simple getters
- (BOOL)boolForKey:(NSString *)key;
- (float)floatForKey:(NSString *)key;
- (double)doubleForKey:(NSString *)key;
- (NSInteger)integerForKey:(NSString *)key;
- (NSNumber *)numberForKey:(NSString *)key;
- (NSDecimalNumber *)decimalNumberForKey:(NSString *)key;

// dates
- (NSDate *)dateFromTimestampAtKey:(NSString *)key;
- (NSDate *)dateFromDateStringAtKey:(NSString *)key;

// JSON
- (BOOL)containsNonEmptyJSONValueForKey:(NSString *)key;

- (BOOL)containsNonEmptyStringValueForKey:(NSString *)key;

- (BOOL)containsNonEmptyDictionaryValueForKey:(NSString *)key;

- (BOOL)containsNonEmptyArrayValueForKey:(NSString *)key;

- (BOOL)containsNonEmptyJSONValueForKey:(NSString *)key ofClass:(Class)class;

@end
