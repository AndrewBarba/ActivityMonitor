//
//  ABActivityDay+AB.m
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/3/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import "ABActivityDay+AB.h"

@implementation ABActivityDay (AB)

+ (NSString *)entityName
{
    return @"ABActivityDay";
}

+ (instancetype)activityDayForDate:(NSDate *)date inContext:(NSManagedObjectContext *)context
{
    ABActivityDay *day = nil;
    
    NSDate *diaryDate = [date diaryDate];
    
    NSString *dateId = [diaryDate simpleStringRespresentation];
    day = [self singleObjectForProperty:@"id" withValue:dateId inContext:context];
    
    if (day == nil) {
        day = [self objectInContext:context];
        day.id = dateId;
        day.date = diaryDate;
        day.steps = @0;
    }
    
    return day;
}

- (void)addSteps:(NSInteger)steps
{
    self.steps = @(steps + self.steps.integerValue);
}

@end
