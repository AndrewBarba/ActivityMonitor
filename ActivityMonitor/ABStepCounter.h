//
//  ABStepCounter.h
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/3/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABActivityDay.h"

static NSString *const ABActivityDayUpdatedNotificationKey = @"ABActivityDayUpdatedNotificationKey";

typedef void (^ABActivityDayBlock) (ABActivityDay *day, NSError *error);

typedef NS_ENUM(NSInteger, ABStepCountingStatus){
    ABStepCountingStatusNotSupported = -1,
    ABStepCountingStatusPermissionUnknown = 0,
    ABStepCountingStatusPermissionDenied = 1,
    ABStepCountingStatusOkay = 2
};

@interface ABStepCounter : NSObject

/**
 * Rebuilds all activity for the past 7 days
 */
- (void)rebuildAllActivity:(ABSetBlock)complete;

/**
 * Recalcualtes the number of steps for a given date
 */
- (void)rebuildActivityDayForDate:(NSDate *)date onCompletion:(ABActivityDayBlock)complete;

/**
 * Starts monitoring the user for steps
 */
- (void)startMonitoringStepCount;

/**
 * Stops monitoring the user
 */
- (void)stopMonitoringStepCount;

/**
 * The users step conting goal. Default 10,000
 */
- (NSInteger)stepCountingGoal;

/**
 * The Current status of step counting permission
 */
- (ABStepCountingStatus)stepCountingStatus;

+ (instancetype)sharedCounter;

@end
