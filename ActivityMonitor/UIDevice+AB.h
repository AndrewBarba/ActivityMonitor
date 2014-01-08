//
//  UIDevice+AB.h
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/4/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (AB)

/**
 * A type of unique of identifier
 */
+ (NSString *)vendorIdentifier;

/**
 * A unique identifier for this device
 */
+ (NSString *)installIdentifier;

@end
