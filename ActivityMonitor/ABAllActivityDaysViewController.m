//
//  ABAllActivityDaysViewController.m
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/3/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import "ABAllActivityDaysViewController.h"
#import "ABStepCounter.h"
#import "ABDataManager.h"

@interface ABAllActivityDaysViewController ()

@end

@implementation ABAllActivityDaysViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.animatesChanges = YES;
    
    [self setupRefreshControl];
    
    [self _setupFetchedResultsController];
    
    [self beginFetchingData];
}

- (void)beginFetchingData
{
    [[ABStepCounter sharedCounter] rebuildAllActivity:^(NSSet *days){
        [self endFetchingData];
    }];
}

- (void)_setupFetchedResultsController
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ABActivityDay"];
    request.fetchBatchSize = 10;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:[ABDataManager sharedManager].mainContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.containsEmptySet) {
        return [super emptySetTableViewCellForIndexPath:indexPath];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Activity Day Cell" forIndexPath:indexPath];
    
    ABActivityDay *day = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ steps", day.steps.decimalString];
    cell.detailTextLabel.text = day.date.longStringRepresentation;
    
    return cell;
}

#pragma mark - Selection

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ABActivityDay *day = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(activityDaysController:selectedActivityDay:)]) {
        [self.delegate activityDaysController:self selectedActivityDay:day];
    }
    
    ABDispatchAfter(0.3, ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
}

#pragma mark - Delete (dev only)

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        ABActivityDay *day = [self.fetchedResultsController objectAtIndexPath:indexPath];
//        [[ABDataManager sharedManager].mainContext deleteObject:day];
//    }
//}
//
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}

@end
