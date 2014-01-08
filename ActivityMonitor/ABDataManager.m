//
//  ABDataManager.m
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/2/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import "ABDataManager.h"
#import <CoreData/CoreData.h>

#define AB_DOCUMENT_KEY @"TLDocumentKey"

@interface ABDataManager() {
    NSManagedObjectContext *_backgroundContext;
}

@end

@implementation ABDataManager

- (NSManagedObjectContext *)mainContext
{
    return self.mainDocument.managedObjectContext;
}

- (NSManagedObjectContext *)backgroundContext
{
    return _backgroundContext;
}

- (void)importData:(ABCoreDataContextCompletionBlock)dataBlock
{
    NSManagedObjectContext *context = self.backgroundContext;
    [context performBlock:^{
        
        // peform the import, copy return block to be called when done
        ABBlock complete = dataBlock(context);
        
        // save the background context and propagate changes up to the main context
        NSError *error = nil;
        BOOL saved = [context save:&error];
        
        // save the main context and call the completion block
        if (saved) {
            [self.mainContext performBlock:^{
                [self.mainDocument updateChangeCount:UIDocumentChangeDone];
                if (complete) complete();
            }];
        } else {
            NSLog(@"FATAL DOCUMENT ERROR: %@",error);
        }
        
        // reset the context after we save
        [context reset];
    }];
}

#pragma mark - Document handling

- (void)openDocument:(ABCoreDataBooleanBlock)complete
{
    [self createMainDocument:^{
        NSString *version = AB_DOCUMENT_VERSION;
        NSString *current = [[NSUserDefaults standardUserDefaults] objectForKey:AB_DOCUMENT_KEY];
        
        if (!current || ![current isEqualToString:version]) {
            [[NSUserDefaults standardUserDefaults] setObject:version forKey:AB_DOCUMENT_KEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            return [self resetDocument:complete];
        }
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:[self.mainDocument.fileURL path]]) {
            [self.mainDocument saveToURL:self.mainDocument.fileURL
                        forSaveOperation:UIDocumentSaveForCreating
                       completionHandler:^(BOOL success){
                           ABDispatchMain(^{
                               if (complete) complete(YES);
                               [[NSNotificationCenter defaultCenter] postNotificationName:ABMainDocumentOpenNotificationKey object:self.mainDocument];
                           });
                       }];
        } else if (self.mainDocument.documentState == UIDocumentStateClosed) {
            [self.mainDocument openWithCompletionHandler:^(BOOL success){
                if (success) {
                    ABDispatchMain(^{
                        if (complete) complete(YES);
                        [[NSNotificationCenter defaultCenter] postNotificationName:ABMainDocumentOpenNotificationKey object:self.mainDocument];
                    });
                } else {
                    [self resetDocument:complete];
                }
            }];
        } else if (self.mainDocument.documentState == UIDocumentStateNormal) {
            ABDispatchMain(^{
                if (complete) complete(YES);
            });
        } else {
            if (complete) complete(NO);
        }
    }];
}

- (void)saveDocument:(ABCoreDataBooleanBlock)complete
{
    [self.mainContext performBlock:^{
        [self.mainContext save:nil];
        [self.mainDocument performAsynchronousFileAccessUsingBlock:^{
            [self.mainDocument saveToURL:self.mainDocument.fileURL
                        forSaveOperation:UIDocumentSaveForOverwriting
                       completionHandler:complete];
        }];
    }];
}

-(void)resetDocument:(ABCoreDataBooleanBlock)complete
{
    [self createMainDocument:^{
        if ([[NSFileManager defaultManager] fileExistsAtPath:[self.mainDocument.fileURL path]]) {
            if (self.mainDocument.documentState == UIDocumentStateNormal) {
                [self.mainDocument closeWithCompletionHandler:^(BOOL done){
                    [[NSNotificationCenter defaultCenter] postNotificationName:ABMainDocumentClosedNotificationKey object:self.mainDocument];
                    [[NSFileManager defaultManager] removeItemAtURL:self.mainDocument.fileURL error:nil];
                    [self createMainDocument:^{
                        [self openDocument:complete];
                    }];
                }];
            } else {
                [[NSFileManager defaultManager] removeItemAtURL:self.mainDocument.fileURL error:nil];
                [self createMainDocument:^{
                    [self openDocument:complete];
                }];
            }
        } else {
            [self openDocument:complete];
        }
    }];
}

#pragma mark - Helpers

- (void)createMainDocument:(ABBlock)complete
{
    if (_mainDocument != nil) {
        if (complete) {
            complete();
        }
        return;
    }
    
    ABDispatchBackground(^{
        
        // create document
        NSString *documentName = @"ABActivityMonitorCoreDataDocument";
        
        NSURL *fileURL = nil;
        NSURL *iCloudURL = AB_ICLOUD_ENABLED ? [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil] : nil;
        if (iCloudURL == nil) {
            fileURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
            NSLog(@"iCloud Disabled");
        }
        
        fileURL = [fileURL URLByAppendingPathComponent:documentName];
        
        NSMutableDictionary *options = [@{ NSMigratePersistentStoresAutomaticallyOption : @(YES),
                                           NSInferMappingModelAutomaticallyOption       : @(YES) } mutableCopy];
        
        if (iCloudURL) {
            NSURL *logsURL = [iCloudURL URLByAppendingPathComponent:@"CoreData"];
            options[NSPersistentStoreUbiquitousContentNameKey] = documentName;
            options[NSPersistentStoreUbiquitousContentURLKey] = logsURL;
        }
        
        ABDispatchMain(^{
            
            NSURL *documentURL = iCloudURL ? [iCloudURL URLByAppendingPathComponent:@"Documents"] : fileURL;
            documentURL = [documentURL URLByAppendingPathComponent:documentName];
            
            self.mainDocument = [[UIManagedDocument alloc] initWithFileURL:documentURL];
            self.mainDocument.persistentStoreOptions = [options copy];
            
            // create background context
            _backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            _backgroundContext.parentContext = self.mainContext;
            [_backgroundContext setUndoManager:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(_handlePersistantStoreUpdated:)
                                                         name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
                                                       object:self.mainContext.persistentStoreCoordinator];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(_handlePersistantStoreChanged:)
                                                         name:NSPersistentStoreCoordinatorStoresDidChangeNotification
                                                       object:self.mainContext.persistentStoreCoordinator];
            
            if (complete) {
                complete();
            }
        });
    });
}

- (void)_handlePersistantStoreUpdated:(NSNotification *)notification
{
    NSLog(@"UPDTAED iCLOUD");
    [[NSNotificationCenter defaultCenter] postNotificationName:ABiCloudDocumentUpdatedNotificationKey object:notification.object];
}

- (void)_handlePersistantStoreChanged:(NSNotification *)notification
{
    NSLog(@"STORE CHANGED");
    [[NSNotificationCenter defaultCenter] postNotificationName:ABiCloudDocumentUpdatedNotificationKey object:notification.object];
}

- (BOOL)isDocumentOpenAndReady
{
    return _mainDocument != nil && _mainDocument.documentState == UIDocumentStateNormal;
}

#pragma mark - Initialization

AB_DISABLE_INIT()

- (id)_initPrivate
{
    self = [super init];
    if (self) {
        // setup
    }
    return self;
}

+ (instancetype)sharedManager
{
    static ABDataManager *instance = nil;
    AB_DISPATCH_ONCE(^{
        instance = [[self alloc] _initPrivate];
    });
    return instance;
}

@end
