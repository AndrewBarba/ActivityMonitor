//
//  ABTableViewController.h
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/3/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABTableViewController : UITableViewController

/**
 * Override method to for subscribing to nofifications
 * Guarenteed to only be called once
 */
- (void)registerForNotifictions;

/**
 * Override methods for unregistering notifications.
 * Called in dealloc
 */
- (void)unregisterForNotifications;

/**
 * Creates a refresh control that automatically calls beginFetchingData
 */
- (void)setupRefreshControl;

@property (nonatomic) BOOL isFetchingData;

@property (nonatomic) NSTimeInterval lastFetch;

/**
 * Returns the time in seconds since the last fetch
 */
- (NSTimeInterval)timeSinceLastFetch;

/**
 * @overide for fetching data from a web service
 */
- (void)beginFetchingData;

/**
 * @overide for fetching data from a web service
 */
- (void)endFetchingData;

/**
 * Text to be displayed when there are no results from the server
 */
- (NSString *)noResultsText;

/**
 * Called anytime the application becomes active
 */
- (void)applicationDidBecomeActive:(NSNotification *)notification;

@end
