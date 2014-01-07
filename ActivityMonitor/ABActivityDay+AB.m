//
//  ABActivityDay+AB.m
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/3/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import "ABActivityDay+AB.h"
#import "ABStepEntry+AB.h"
#import "ABStepCounter.h"
#import "ABDataManager.h"

@implementation ABActivityDay (AB)

+ (NSString *)entityName
{
    return @"ABActivityDay";
}

+ (instancetype)activityDayForDate:(NSDate *)date inContext:(NSManagedObjectContext *)context
{
    ABActivityDay *day = nil;
    
    if (!date) {
        date = [NSDate date];
    }
    
    NSDate *diaryDate = [date diaryDate];
    NSString *dateId = [diaryDate simpleStringRespresentation];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[self entityName]];
    request.predicate = [NSPredicate predicateWithFormat:@"id == %@", dateId];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (error) {
        [NSException raise:@"Error fetching Step Entry" format:nil];
    } else if (matches.count > 1) {
        day = [self _mergeDays:matches inContext:context];
    } else if (matches.count == 1){
        day = [matches lastObject];
    } else {
        day = [self objectInContext:context];
        day.objectDeleted = @(NO);
    }
    
    day.id = dateId;
    day.date = diaryDate;
    
    return day;
}

+ (void)mergeDuplicates:(NSArray *)activityDays inContext:(NSManagedObjectContext *)context
{
    if (!context) {
        context = [ABDataManager sharedManager].mainContext;
    }
    
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    
    for (ABActivityDay *day in activityDays) {
        NSMutableArray *days = data[day.id];
        if (!days) {
            days = [NSMutableArray array];
            data[day.id] = days;
        }
        [days addObject:day];
    }
    
    [data enumerateKeysAndObjectsUsingBlock:^(NSString *id, NSArray *days, BOOL *stop){
        if (days.count > 1) {
            [self _mergeDays:days inContext:context];
        }
    }];
}

+ (instancetype)_mergeDays:(NSArray *)days inContext:(NSManagedObjectContext *)context
{
    NSString *dateId = nil;
    NSDate *date = nil;
    
    NSMutableSet *entries = [NSMutableSet set];
    for (ABActivityDay *day in days) {
        dateId = [day.id copy];
        date = [day.date copy];
        [entries addObjectsFromArray:day.entries.allObjects];
        day.objectDeleted = @(YES);
    }
    
    ABActivityDay *day = [self objectInContext:context];
    [day addEntries:entries];
    day.id = dateId;
    day.date = date;
    day.objectDeleted = @(NO);
    
    return day;
}

- (NSNumber *)steps
{
    NSInteger steps = 0;
    for (ABStepEntry *entry in self.entries) {
        steps += entry.steps.integerValue;
    }
    return @(steps);
}

- (void)setSteps:(NSNumber *)steps
{
    NSString *deviceId = [UIDevice vendorIdentifier];
    ABStepEntry *entry = [ABStepEntry entryForActivityDay:self fromDevice:deviceId inContext:self.managedObjectContext];
    entry.steps = steps;
}

- (float)progress
{
    float steps = self.steps.floatValue;
    float goal = [[ABStepCounter sharedCounter] stepCountingGoal];
    return steps / goal;
}

- (NSString *)ABDescription
{
    return [NSString stringWithFormat:
            @"{\n objectId: %@,\n id: %@,\n date: %@,\n steps: %@\n}",
            self.objectID,
            self.id,
            self.date.longStringRepresentation,
            self.steps.stringValue];
}

@end
