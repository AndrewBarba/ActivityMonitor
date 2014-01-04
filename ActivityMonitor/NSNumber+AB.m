//
//  NSNumber+AB.m
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/3/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import "NSNumber+AB.h"

@implementation NSNumber (AB)

- (NSString *)currencyString
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    return [numberFormatter stringFromNumber:self];
}

- (NSString *)shortCurrencyString
{
    NSString *string = self.currencyString;
    NSArray *parts = [string componentsSeparatedByString:@"."];
    return [parts firstObject];
}

- (NSString *)decimalString
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    return [numberFormatter stringFromNumber:self];
}

@end
