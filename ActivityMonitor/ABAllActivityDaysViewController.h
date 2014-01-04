//
//  ABAllActivityDaysViewController.h
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/3/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import "ABCoreDataTableViewController.h"
#import "ABActivityDay+AB.h"

@class ABAllActivityDaysViewController;

@protocol ABAllActivityDaysDelegate <NSObject>

- (void)activityDaysController:(ABAllActivityDaysViewController *)controller selectedActivityDay:(ABActivityDay *)day;

@end

@interface ABAllActivityDaysViewController : ABCoreDataTableViewController

@property (nonatomic, weak) id <ABAllActivityDaysDelegate> delegate;

@end
