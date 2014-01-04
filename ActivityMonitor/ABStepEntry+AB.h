//
//  ABStepEntry+AB.h
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/4/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import "ABStepEntry.h"
#import "NSManagedObject+AB.h"

@interface ABStepEntry (AB)

+ (instancetype)entryForActivityDay:(ABActivityDay *)day fromDevice:(NSString *)device inContext:(NSManagedObjectContext *)context;

@end
