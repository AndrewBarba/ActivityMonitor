//
//  TLDataManager.m
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

#import "TLDataManager.h"

@interface TLDataManager() {
    
    // vars
    NSString *_databaseName;
    NSString *_modelName;
    
    // store
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
    NSPersistentStore *_persistentStore;
    
    // model
    NSManagedObjectModel *_managedObjectModel;
    
    // contexts
    NSManagedObjectContext *_masterContext;
    NSManagedObjectContext *_mainContext;
    NSManagedObjectContext *_backgroundContext;
}

@end

static NSString *TLDatabaseName = nil;
static NSString *TLDatabaseModelName = nil;

@implementation TLDataManager

+ (void)setDatabaseName:(NSString *)databaseName linkedToModel:(NSString *)modelName
{
    TLDatabaseName = databaseName;
    TLDatabaseModelName = modelName;
}

#pragma mark - Persistent Store

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *storeURL = [self persistentStoreURL];
        NSDictionary *options = [self persistentStoreOptions];
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        _persistentStore = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                     configuration:nil
                                                                               URL:storeURL
                                                                           options:options
                                                                             error:nil];
    });
    return _persistentStoreCoordinator;
}

- (NSURL *)persistentStoreURL
{
    NSString *name = [_databaseName copy];
    NSURL *documentDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [documentDirectory URLByAppendingPathComponent:name];
}

- (NSDictionary *)persistentStoreOptions
{
    return @{ NSMigratePersistentStoresAutomaticallyOption : @(YES),
              NSInferMappingModelAutomaticallyOption       : @(YES) };
}

#pragma mark - Object Model

- (NSManagedObjectModel *)managedObjectModel
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *modelName = [_modelName copy];
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:modelName withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    });
    return _managedObjectModel;
}

#pragma mark - Contexts

- (NSManagedObjectContext *)masterContext
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _masterContext = [self _backgroundContextWithParent:nil];
        [_masterContext setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
    });
    return _masterContext;
}

- (NSManagedObjectContext *)mainContext
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_mainContext setUndoManager:nil];
        [_mainContext setParentContext:[self masterContext]];
    });
    return _mainContext;
}

- (NSManagedObjectContext *)backgroundContext
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _backgroundContext = [self _backgroundContextWithParent:[self mainContext]];
    });
    return _backgroundContext;
}

- (NSManagedObjectContext *)_backgroundContextWithParent:(NSManagedObjectContext *)parentContext
{
    NSManagedObjectContext *_context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    if (parentContext) {
        _context.parentContext = parentContext;
    }
    [_context setUndoManager:nil];
    return _context;
}

#pragma mark - Saving

- (void)save
{
    [self.masterContext performBlock:^{
        NSError *error = nil;
        NSManagedObjectContext *managedObjectContext = self.masterContext;
        if (managedObjectContext != nil) {
            if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            }
        }
    }];
}

- (BOOL)reset
{
    BOOL success = YES;
    
    NSURL *storeURL = [self persistentStoreURL];
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    NSManagedObjectContext *masterContext = [self masterContext];
    NSPersistentStore *store = [coordinator.persistentStores lastObject];
    
    // lock and reset context
    [masterContext lock];
    [masterContext reset];
    
    // remove store
    if (store) {
        NSError *removeStoreError = nil;
        if (![coordinator removePersistentStore:store error:&removeStoreError]) {
            NSLog(@"%@", removeStoreError);
            success = NO;
        }
    }
    
    // remove DB file
    if ([[NSFileManager defaultManager] fileExistsAtPath:storeURL.path]) {
        NSError *removeDBError = nil;
        if (![[NSFileManager defaultManager] removeItemAtURL:storeURL error:&removeDBError]) {
            NSLog(@"%@", removeDBError);
            success = NO;
        }
    }
    
    // add new store
    _persistentStore = [coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                 configuration:nil
                                                           URL:storeURL
                                                       options:[self persistentStoreOptions]
                                                         error:nil];
    
    // unlock
    [masterContext unlock];
    
    return success;
}

#pragma mark - Importing

- (void)importData:(TLImportBlock)importBlock
{
    NSManagedObjectContext *context = [self backgroundContext];
    
    [context performBlock:^{
        
        // peform the import, copy return block to be called when done
        TLBlock complete = [importBlock(context) copy];
        
        // save the background context and propagate changes up to the main context
        [context save:nil];
        
        // call the completion block from the main context
        [self.mainContext performBlock:^{
            if (complete) {
                complete();
            }
            
            // save main context
            [self.mainContext save:nil];
            
            // save master context
            [self save];
        }];
    }];
}

#pragma mark - Initialization

- (void)_start
{
    if (!_databaseName || !_modelName) {
        [NSException raise:@"Database name and model not set. [TLDataManager setDatabaseName:] must be called before accessing shared manager."
                    format:nil];
        return;
    }
    
    [self mainContext];
    if (!_persistentStore) {
        [self reset];
    }
}

- (id)init
{
    [super doesNotRecognizeSelector:_cmd];
    return nil;
}

- (instancetype)initWithDatabaseName:(NSString *)databaseName linkedToModel:(NSString *)modelName
{
    self = [super init];
    if (self) {
        _databaseName = databaseName;
        _modelName = modelName;
        [self _start];
    }
    return self;
}

+ (instancetype)sharedManager
{
    static TLDataManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithDatabaseName:TLDatabaseName linkedToModel:TLDatabaseModelName];
    });
    return instance;
}

@end
