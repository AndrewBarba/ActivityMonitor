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
    request.relationshipKeyPathsForPrefetching = @[@"entries"];
    
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
    }
    
    day.id = dateId;
    day.date = diaryDate;
    
    return day;
}

+ (instancetype)_mergeDays:(NSArray *)days inContext:(NSManagedObjectContext *)context
{
    ABActivityDay *day = [self objectInContext:context];
    NSMutableSet *entries = [NSMutableSet set];
    for (ABActivityDay *day in days) {
        [entries addObjectsFromArray:day.entries.allObjects];
        [context deleteObject:day];
    }
    day.entries = entries;
    
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

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"{\n objectId: %@,\n id: %@,\n date: %@,\n steps: %@\n}",
            self.objectID,
            self.id,
            self.date.longStringRepresentation,
            self.steps.stringValue];
}

@end
