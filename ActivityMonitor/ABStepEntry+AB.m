//
//  ABStepEntry+AB.m
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/4/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import "ABStepEntry+AB.h"

@implementation ABStepEntry (AB)

+ (NSString *)entityName
{
    return @"ABStepEntry";
}

+ (instancetype)entryForActivityDay:(ABActivityDay *)day fromDevice:(NSString *)deviceId inContext:(NSManagedObjectContext *)context
{
    ABStepEntry *entry = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[self entityName]];
    request.predicate = [NSPredicate predicateWithFormat:@"activityDay == %@ && deviceIdentifier == %@", day, deviceId];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"steps" ascending:YES]];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (error) {
        [NSException raise:@"Error fetching Step Entry" format:nil];
    } else if (matches.count > 0) {
        entry = [matches lastObject];
    } else {
        entry = [self objectInContext:context];
        entry.activityDay = day;
        entry.deviceIdentifier = deviceId;
        entry.steps = @0;
    }
    
    return entry;
}

@end
