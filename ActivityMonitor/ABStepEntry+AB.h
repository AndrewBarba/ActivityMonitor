//
//  ABStepEntry+AB.h
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/8/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import "ABStepEntry.h"
#import "NSManagedObject+AB.h"

@interface ABStepEntry (AB)

+ (instancetype)entryForDate:(NSDate *)date inContext:(NSManagedObjectContext *)context;

+ (NSSet *)allEntriesForDate:(NSDate *)date inContext:(NSManagedObjectContext *)context;

@end
