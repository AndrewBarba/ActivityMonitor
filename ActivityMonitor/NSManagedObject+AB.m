//
//  NSManagedObject+AB.m
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/3/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import "NSManagedObject+AB.h"
#import "ABDataManager.h"

@implementation NSManagedObject (AB)

#pragma mark - Override

+ (NSString *)entityName
{
    [NSException raise:@"Must override entityName in Category Subclass" format:nil];
    return nil;
}

+ (NSString *)uniqueKey
{
    return @"id";
}

#pragma mark - Create Object

+ (instancetype)objectInContext:(NSManagedObjectContext *)context
{
    NSString *entityName = [self entityName];
    return [NSEntityDescription insertNewObjectForEntityForName:entityName
                                         inManagedObjectContext:context];
}

#pragma mark - Fetch Single Object

+ (instancetype)singleObjectForProperty:(NSString *)propertyName withValue:(id)value inContext:(NSManagedObjectContext *)context
{
    NSManagedObject *object = nil;
    
    NSString *entityName = [self entityName];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
    request.predicate = [NSPredicate predicateWithFormat:@"%K == %@", propertyName, value];
    request.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO] ];
    request.fetchLimit = 1;
    request.fetchBatchSize = 1;
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (error || !matches) {
        // handle error
        [NSException raise:@"Failed to fetch object from CoreData" format:nil];
    } else if (matches.count == 0) {
        // could not find object
    } else {
        object = [matches lastObject];
    }
    
    return object;
}

- (instancetype)referenceInContext:(NSManagedObjectContext *)context
{
    if (!context) {
        context = [[ABDataManager sharedManager] mainContext];
    }
    
    if (self.managedObjectContext == context) {
        return self;
    } else {
        return [context objectWithID:self.objectID];
    }
}


#pragma mark - Fetch Multiple Objects

+ (NSSet *)allObjectsInContext:(NSManagedObjectContext *)context
{
    NSString *entityName = [self entityName];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
    request.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO] ];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!error && matches) {
        return [[NSSet alloc] initWithArray:matches];
    } else {
        return nil;
    }
}

+ (NSSet *)references:(NSSet *)objects inContext:(NSManagedObjectContext *)context
{
    NSMutableSet *newSet = [NSMutableSet set];
    for (NSManagedObject *object in objects) {
        [newSet addObject:[object referenceInContext:context]];
    }
    return newSet;
}


#pragma mark - Merge Sets

+ (void)updateSet:(NSSet *)oldSet toSet:(NSSet *)newSet inContext:(NSManagedObjectContext *)context
{
    for (NSManagedObject *object in oldSet) {
        if (![newSet containsObject:object]) {
            [context deleteObject:object];
        }
    }
}

@end
