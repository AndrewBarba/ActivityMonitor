//
//  ABStepCounter.h
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/3/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABActivityDay+AB.h"

static NSString *const ABActivityDayUpdatedNotificationKey = @"ABActivityDayUpdatedNotificationKey";

typedef void (^ABActivityDayBlock) (ABActivityDay *day, NSError *error);

@interface ABStepCounter : NSObject

- (void)startMonitoringStepCount;

- (void)stopMonitoringStepCount;

- (BOOL)isStepCountingAvailable;

+ (instancetype)sharedCounter;

@end
