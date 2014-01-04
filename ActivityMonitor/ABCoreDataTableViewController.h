//
//  ABCoreDataTableViewController.h
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/3/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import "ABTableViewController.h"
#import <CoreData/CoreData.h>

@interface ABCoreDataTableViewController : ABTableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic) BOOL animatesChanges;

/**
 * Fetches data from CoreData
 * @return returns YES for successful fetch, NO otherwise
 */
- (BOOL)performFetch;

- (void)reloadDataAnimated:(BOOL)animated;

- (void)reloadAllSections;

- (BOOL)containsEmptySet;

- (UITableViewCell *)emptySetTableViewCellForIndexPath:(NSIndexPath *)indexPath;

@end
