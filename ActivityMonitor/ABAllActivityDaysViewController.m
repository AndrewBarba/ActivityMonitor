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
#import "ABActivityCell.h"

@interface ABAllActivityDaysViewController ()

@property (nonatomic, strong) NSArray *activityDays;

@end

@implementation ABAllActivityDaysViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    
    [NSNotificationCenter observe:ABiCloudDocumentUpdatedNotificationKey on:^(NSNotification *notification){
        [self reloadData];
    }];
    
    [NSNotificationCenter observe:ABActivityDayUpdatedNotificationKey on:^(NSNotification *notification){
        [self.tableView reloadData];
    }];
    
    [self reloadData];
}

- (void)reloadData
{
    NSManagedObjectContext *context = [ABDataManager sharedManager].mainContext;
    self.activityDays = [ABActivityDay allActivityDaysInContext:context];
}

- (void)setActivityDays:(NSArray *)activityDays
{
    if (_activityDays != activityDays) {
        _activityDays = activityDays;
        [self.tableView reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.activityDays.count;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ABActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Activity Day Cell" forIndexPath:indexPath];
    
    ABActivityDay *day = self.activityDays[indexPath.row];
    cell.activityDay = day;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - Selection

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ABActivityDay *day = self.activityDays[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(activityDaysController:selectedActivityDay:)]) {
        [self.delegate activityDaysController:self selectedActivityDay:day];
    }
}

@end
