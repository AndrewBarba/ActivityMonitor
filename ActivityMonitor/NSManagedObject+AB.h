//
//  NSManagedObject+AB.h
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/3/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (AB)

// OVERRIDE METHODS
///////////////////

/**
 * Must be overriden by subclasses
 */
+ (NSString *)entityName;

/**
 * A unique key in the JSON dictionary to associate with object.id
 * default: id
 */
+ (NSString *)uniqueKey;



// CREATE OBJECT
////////////////

/**
 * Creates an empty NSManagedObject
 */
+ (instancetype)objectInContext:(NSManagedObjectContext *)context;

// FETCH SINGLE OBJECT
//////////////////////

/**
 * Fetches a single object by the given property with the given value
 * If nothing is found, nil is returned
 */
+ (instancetype)singleObjectForProperty:(NSString *)propertyName withValue:(id)value inContext:(NSManagedObjectContext *)context;

/**
 * Returns a reference to the TLObject in the given context
 * nil context defaults to main context
 * Useful for gettings a main context reference to an object that was created on a background context
 */
- (instancetype)referenceInContext:(NSManagedObjectContext *)context;



// FETCH MULTIPLE OBJECTS
/////////////////////////

/**
 * Fetches all objects of this entity
 */
+ (NSSet *)allObjectsInContext:(NSManagedObjectContext *)context;


/**
 * Returns a list of objects referenced in the given context
 * nil context defaults to main context
 * Useful for getting a main context reference to a set that was created on the background context
 */
+ (NSSet *)references:(NSSet *)objects inContext:(NSManagedObjectContext *)context;



// MERGE SETS
/////////////

/**
 * Updates a current set to match a given set
 * Useful for recieving an updated list from a server and making sure old data is deleted
 */
+ (void)updateSet:(NSSet *)oldSet toSet:(NSSet *)newSet inContext:(NSManagedObjectContext *)context;

@end
