//
//  ABDataManager.h
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/2/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Special CoreData completion blocks
 */
typedef ABBlock (^ABCoreDataContextCompletionBlock) (NSManagedObjectContext *context);
typedef void (^ABCoreDataBooleanBlock) (BOOL success);

@interface ABDataManager : NSObject

/**
 * The main CoreData/iCloud document
 */
@property (nonatomic, strong) UIManagedDocument *mainDocument;

/**
 * Returns a reference to the ManagedObjectContext on the main thread
 * This context should be used for UI purposes
 */
- (NSManagedObjectContext *)mainContext;

/**
 * Returns a reference to the ManagedObjectContext on the background thread
 * This context should be used for importing objects into the database
 */
- (NSManagedObjectContext *)backgroundContext;

/**
 * Use this method to begin importing data into the database.
 * Pass in a block that does some importing and then return a block to be called when finished.
 * The returned block will be called on the main thread after the imports are complete.
 */
- (void)importData:(ABCoreDataContextCompletionBlock)dataBlock;

/**
 * Opens the UIManagedDocument
 */
- (void)openDocument:(ABCoreDataBooleanBlock)complete;

/**
 * Saves the UIManagedDocument
 */
- (void)saveDocument:(ABCoreDataBooleanBlock)complete;

/**
 * Resets the UIManagedDocument
 */
- (void)resetDocument:(ABCoreDataBooleanBlock)complete;

/**
 * Static accessor
 */
+ (instancetype)sharedManager;

@end
