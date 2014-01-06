//
//  ABCoreDataTableViewController.m
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/3/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import "ABCoreDataTableViewController.h"
#import "ABActivityDay+AB.h"

@interface ABCoreDataTableViewController () {
    BOOL _isUpdatingTable;
}

@end

@implementation ABCoreDataTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [NSNotificationCenter observe:ABiCloudDocumentUpdatedNotificationKey on:^(NSNotification *notification){
        [self performFetch];
        [self.tableView reloadData];
    }];
}

- (void)setFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != fetchedResultsController) {
        _fetchedResultsController = fetchedResultsController;
        _fetchedResultsController.delegate = self;
        [self performFetch];
    }
}

- (BOOL)performFetch
{
    NSError *fetchError = nil;
    [self.fetchedResultsController performFetch:&fetchError];
    return fetchError ? NO : YES;
}

#pragma mark - Empty Set

- (BOOL)containsEmptySet
{
    return self.fetchedResultsController.fetchedObjects.count == 0;
}

#pragma mark - Fetching

- (void)endFetchingData
{
    [super endFetchingData];
    ABDispatchAfter(0.3, ^{
        [self performFetch];
        [self.tableView reloadData];
    });
}

#pragma mark - Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.containsEmptySet) {
        return 1;
    } else {
        return self.fetchedResultsController.sections.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.containsEmptySet) {
        return 2;
    } else {
        return [self.fetchedResultsController.sections[section] numberOfObjects];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (self.containsEmptySet) {
        return nil;
    } else {
        return [self.fetchedResultsController.sections[section] name];
    }
}

- (UITableViewCell *)emptySetTableViewCellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *blankCellID = @"TLBlankCell";
    static NSString *emptySetCellID = @"TLEmptyCell";
    
    if (indexPath.row == 0) {
        return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:blankCellID];
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:emptySetCellID];
    cell.textLabel.text = [self noResultsText];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return !self.containsEmptySet;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark - Fetched Results Controller Delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if (_animatesChanges && !_isUpdatingTable) {
        _isUpdatingTable = YES;
        [self.tableView beginUpdates];
        
        if (self.containsEmptySet) {
            NSIndexPath *blankPath = [NSIndexPath indexPathForRow:0 inSection:0];
            NSIndexPath *textPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [self.tableView deleteRowsAtIndexPaths:@[blankPath,textPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            //            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
            //            [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

//- (void)controller:(NSFetchedResultsController *)controller
//  didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
//           atIndex:(NSUInteger)sectionIndex
//     forChangeType:(NSFetchedResultsChangeType)type
//{
//    if (_animatesChanges && _isUpdatingTable) {
//
//        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:sectionIndex];
//
//        switch (type) {
//            case NSFetchedResultsChangeInsert:
//            {
//                [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//                return;
//            }
//
//            case NSFetchedResultsChangeDelete:
//            {
//                [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//                return;
//            }
//
//            case NSFetchedResultsChangeMove:
//            {
//                // nothing to do here
//                return;
//            }
//
//            case NSFetchedResultsChangeUpdate:
//            {
//                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//                return;
//            }
//        }
//
//    }
//}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    if (_animatesChanges && _isUpdatingTable) {
        
        switch (type) {
            case NSFetchedResultsChangeInsert:
            {
                [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                return;
            }
                
            case NSFetchedResultsChangeDelete:
            {
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                return;
            }
                
            case NSFetchedResultsChangeMove:
            {
                [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
                return;
            }
                
            case NSFetchedResultsChangeUpdate:
            {
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                return;
            }
        }
        
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (_animatesChanges && _isUpdatingTable) {
        
        if (self.containsEmptySet) {
            NSIndexPath *blankPath = [NSIndexPath indexPathForRow:0 inSection:0];
            NSIndexPath *textPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[blankPath,textPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            //            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
            //            [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        
        [self.tableView endUpdates];
        _isUpdatingTable = NO;
        
        ABDispatchAfter(0.3, ^{
            [self.tableView reloadData];
        });
    } else {
        [self.tableView reloadData];
    }
}

#pragma mark - Update All

- (void)reloadDataAnimated:(BOOL)animated
{
    [self performFetch];
    
    if (!animated) {
        [self.tableView reloadData];
    } else {
        [self reloadAllSections];
    }
}

- (void)reloadAllSections
{
    NSUInteger tableViewSections = self.tableView.numberOfSections;
    NSUInteger fetchedSections = self.fetchedResultsController.sections.count;
    
    if (fetchedSections > 0 && fetchedSections == tableViewSections) {
        NSRange range = NSMakeRange(0, self.fetchedResultsController.sections.count-1);
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:range]
                      withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [self.tableView reloadData];
    }
}

@end
