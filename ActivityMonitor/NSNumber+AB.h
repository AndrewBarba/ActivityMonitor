//
//  NSNumber+AB.h
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/3/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (AB)

/**
 * @return $300.00
 */
- (NSString *)currencyString;

/**
 * @return $300
 */
- (NSString *)shortCurrencyString;

/**
 * @return 30,000
 */
- (NSString *)decimalString;

@end
