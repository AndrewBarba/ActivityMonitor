//
//  ABStepEntry.h
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/4/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ABActivityDay;

@interface ABStepEntry : NSManagedObject

@property (nonatomic, retain) NSString * deviceIdentifier;
@property (nonatomic, retain) NSNumber * steps;
@property (nonatomic, retain) ABActivityDay *activityDay;

@end
