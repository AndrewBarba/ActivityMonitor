//
//  ABActivityDay.h
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/6/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ABStepEntry;

@interface ABActivityDay : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * objectDeleted;
@property (nonatomic, retain) NSSet *entries;
@end

@interface ABActivityDay (CoreDataGeneratedAccessors)

- (void)addEntriesObject:(ABStepEntry *)value;
- (void)removeEntriesObject:(ABStepEntry *)value;
- (void)addEntries:(NSSet *)values;
- (void)removeEntries:(NSSet *)values;

@end
