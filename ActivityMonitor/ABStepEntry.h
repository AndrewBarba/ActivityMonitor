//
//  ABStepEntry.h
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/8/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ABStepEntry : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * steps;
@property (nonatomic, retain) NSString * deviceIdentifier;

@end
