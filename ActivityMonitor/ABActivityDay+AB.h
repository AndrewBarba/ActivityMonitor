//
//  ABActivityDay+AB.h
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/3/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import "ABActivityDay.h"
#import "NSManagedObject+AB.h"

@interface ABActivityDay (AB)

+ (instancetype)activityDayForDate:(NSDate *)date inContext:(NSManagedObjectContext *)context;

- (NSNumber *)steps;

- (void)setSteps:(NSNumber *)steps;

@end
