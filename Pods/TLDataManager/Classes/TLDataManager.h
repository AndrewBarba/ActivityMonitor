//
//  TLDataManager.h
//  Tablelist
//
//  Created by Andrew Barba <andrew@tablelistapp.com>
//  Copyright (c) 2014 Tablelist Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef void    (^TLBlock)       ();
typedef TLBlock (^TLImportBlock) (NSManagedObjectContext *importContext);

/** The `TLDataManager` manages a single CoreData stack consisting of one master
 * `NSManagedObjectContext` on a private thread, one main `NSManagedObjectContext` on
 * the main thread, and one background `NSManagedObjectContext` on a background thread.
 *
 * The master context is connected to a single `NSPersistentStoreCoordinator` and writes
 * all changes to disk on a abckground thread to keep the main thread free. 
 *
 * The main context is a child of the master context and is exposed for UI purposes.
 * `NSfetchedResutlsController` should reference the main context
 *
 * @warning When using the importData: method it is the programmers job to gather
 * references of objects imported on the background thread back onto the main thread.
 * Referencing objects between contexts will cause undesired results. It is highly
 * reccomended to use `NSManagedObjectContext` objectWithID: method for referencing
 * objects between threads.
 */
@interface TLDataManager : NSObject

/**-----------------------------------------------------------------------------
 * @name Initialize / Setup
 * -----------------------------------------------------------------------------
 */

/**
 * Sets the database name to store on disk and the model to look up for the 
 * database. This only affects the singleton sharedManager and must be called
 * before accessing the sharedManager
 *
 * @param databaseName The name of the SQLite file for the local database
 * @param modelName The name of the managedObjectModel file that should be loaded
 */
+ (void)setDatabaseName:(NSString *)databaseName linkedToModel:(NSString *)modelName;

/**
 * Initializes a new CoreData stack based on the given database name and model name
 *
 * @param databaseName The name of the SQLite file for the local database
 * @param modelName The name of the managedObjectModel file that should be loaded
 */
- (instancetype)initWithDatabaseName:(NSString *)databaseName linkedToModel:(NSString *)modelName;


/**-----------------------------------------------------------------------------
 * @name Managed Object Context
 * -----------------------------------------------------------------------------
 */

/**
 * Returns a reference to the ManagedObjectContext on the main thread. This 
 * context should be used for UI purposes
 */
@property (nonatomic, strong, readonly) NSManagedObjectContext *mainContext;


/**-----------------------------------------------------------------------------
 * @name Import Data
 * -----------------------------------------------------------------------------
 */

/** Imports data into the database on a background thread.
 *
 * Use this method to begin importing data into the database.
 * Pass in a block that does some importing and then return a block to be called 
 * when finished. The returned block will be called on the main thread after the 
 * imports are complete.
 *
 * @param importBlock A block that accepts a managed context which should be used 
 * for importing data and returns a block that should be called on the main thread 
 * when importing is complete
 */
- (void)importData:(TLImportBlock)importBlock;


/**-----------------------------------------------------------------------------
 * @name Manage Data
 * -----------------------------------------------------------------------------
 */

/** Saves the master context and writes to disk */
- (void)save;

/** Resets the persistant store coordinator and rebuilds the object model */
- (BOOL)reset;


/**-----------------------------------------------------------------------------
 * @name Singleton
 * -----------------------------------------------------------------------------
 */

/** Static singleton
 *
 * @warning When using the singleton instance you must call 
 * +setDatabaseName:linkedToModel: before referencing the sharedManager.
 */
+ (instancetype)sharedManager;

@end
