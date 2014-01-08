//
//  ABActivityDay.m
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/8/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import "ABActivityDay.h"
#import "ABStepCounter.h"
#import "ABDataManager.h"

@interface ABActivityDay()

@end

@implementation ABActivityDay

+ (instancetype)activityDayForDate:(NSDate *)date inContext:(NSManagedObjectContext *)context
{
    static NSMutableDictionary *_cache = nil;
    AB_DISPATCH_ONCE(^{
        _cache = [[NSMutableDictionary alloc] init];
    });
    
    if (!date) {
        date = [NSDate date];
    }
    
    NSDate *diaryDate = date.diaryDate;
    NSString *dateId = [diaryDate simpleStringRespresentation];
    
    ABActivityDay *day = [_cache objectForKey:dateId];
    
    if (!day) {
        day = [[self alloc] init];
        day.id = dateId;
        day.date = diaryDate;
        [day reloadStepsInContext:context];
        [_cache setObject:day forKey:dateId];
    }
    
    return day;
}

+ (NSArray *)allActivityDaysInContext:(NSManagedObjectContext *)context
{
    if (!context) {
        context = [ABDataManager sharedManager].mainContext;
    }
    
    NSMutableSet *days = [NSMutableSet set];
    
    NSSet *entries = [ABStepEntry allObjectsInContext:context];
    for (ABStepEntry *entry in entries) {
        ABActivityDay *day = [ABActivityDay activityDayForDate:entry.date inContext:context];
        [day reloadStepsInContext:context];
        [days addObject:day];
    }
    
    return [days sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]];
}

- (void)reloadStepsInContext:(NSManagedObjectContext *)context
{
    NSSet *entries = [ABStepEntry allEntriesForDate:self.date inContext:context];
    
    NSInteger steps = 0;
    for (ABStepEntry *entry in entries) {
        steps += entry.steps.integerValue;
    }
    self.steps = @(steps);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ABActivityDayUpdatedNotificationKey object:self];
}

- (float)progress
{
    NSInteger goal = [[ABStepCounter sharedCounter] stepCountingGoal];
    return (self.steps.floatValue / @(goal).floatValue);
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[ABActivityDay class]]) {
        ABActivityDay *day = (ABActivityDay *)object;
        return [self isEqualToActivityDay:day];
    }
    return NO;
}

- (BOOL)isEqualToActivityDay:(ABActivityDay *)day
{
    return [self.id isEqualToString:day.id];
}

@end
