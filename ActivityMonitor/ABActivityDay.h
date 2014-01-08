//
//  ABActivityDay.h
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/8/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABStepEntry+AB.h"

@interface ABActivityDay : NSObject

@property (nonatomic, strong) NSString *id;

@property (nonatomic, strong) NSNumber *steps;

@property (nonatomic, strong) NSDate *date;

- (float)progress;

- (void)reloadStepsInContext:(NSManagedObjectContext *)context;

- (BOOL)isEqualToActivityDay:(ABActivityDay *)day;

+ (instancetype)activityDayForDate:(NSDate *)date inContext:(NSManagedObjectContext *)context;

+ (NSArray *)allActivityDaysInContext:(NSManagedObjectContext *)context;

@end
