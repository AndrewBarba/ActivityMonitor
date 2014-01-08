//
//  ABStepEntry+AB.m
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/8/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import "ABStepEntry+AB.h"

@implementation ABStepEntry (AB)

+ (NSString *)entityName
{
    return @"ABStepEntry";
}

+ (instancetype)entryForDate:(NSDate *)date inContext:(NSManagedObjectContext *)context
{
    ABStepEntry *entry = nil;
    
    if (!date) {
        date = [NSDate date];
    }
    
    NSDate *diaryDate = [date diaryDate];
    NSString *dateId = [diaryDate simpleStringRespresentation];
    NSString *deviceId = [UIDevice installIdentifier];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[self entityName]];
    request.predicate = [NSPredicate predicateWithFormat:@"id == %@ && deviceIdentifier == %@", dateId, deviceId];
    request.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES] ];
    request.fetchLimit = 1;
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (error) {
        [NSException raise:@"Error fetching Step Entry" format:nil];
    } else if (matches.count > 0) {
        entry = [matches lastObject];
    } else {
        entry = [self objectInContext:context];
        entry.id = dateId;
        entry.date = diaryDate;
        entry.deviceIdentifier = deviceId;
    }
    
    return entry;
}

+ (NSSet *)allEntriesForDate:(NSDate *)date inContext:(NSManagedObjectContext *)context
{
    if (!date) {
        date = [NSDate date];
    }
    
    NSString *dateId = [date.diaryDate simpleStringRespresentation];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[self entityName]];
    request.predicate = [NSPredicate predicateWithFormat:@"id == %@", dateId];
    request.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES] ];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    return [[NSSet alloc] initWithArray:matches];
}

@end
