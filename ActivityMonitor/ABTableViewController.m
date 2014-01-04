//
//  ABTableViewController.m
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/3/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import "ABTableViewController.h"

@interface ABTableViewController () {
    BOOL _inited;
}

@end

@implementation ABTableViewController

#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self abCommonInit];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self abCommonInit];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self abCommonInit];
    }
    return self;
}

- (void)abCommonInit
{
    if (_inited) return;
    _inited = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:[UIApplication sharedApplication]];
    
    [self registerForNotifictions];
}

#pragma mark - Style

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:[UIApplication sharedApplication]];
    
    [self unregisterForNotifications];
}

#pragma mark - Fetch Data

- (void)setupRefreshControl
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(beginFetchingData) forControlEvents:UIControlEventValueChanged];
}

- (void)beginFetchingData
{
    self.isFetchingData = YES;
}

- (void)endFetchingData
{
    self.isFetchingData = NO;
    self.lastFetch = [[NSDate date] timeIntervalSince1970];
    [self.refreshControl endRefreshing];
}

- (NSTimeInterval)timeSinceLastFetch
{
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    return now - self.lastFetch;
}

- (NSString *)noResultsText
{
    return NSLocalizedString(@"Nothing to see here...", nil);
}

#pragma mark - Notifications

- (void)registerForNotifictions
{
    // override
}

- (void)unregisterForNotifications
{
    // override
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    // refresh data after 5 min
    if ([self timeSinceLastFetch] > (60 * 5) && self.refreshControl) {
        [self beginFetchingData];
    }
}

@end
