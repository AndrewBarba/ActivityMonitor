//
//  ABAllActivityDaysViewController.h
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/3/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import "ABTableViewController.h"
#import "ABActivityDay.h"

@class ABAllActivityDaysViewController;

@protocol ABAllActivityDaysDelegate <NSObject>

- (void)activityDaysController:(ABAllActivityDaysViewController *)controller selectedActivityDay:(ABActivityDay *)day;

@end

@interface ABAllActivityDaysViewController : ABTableViewController

@property (nonatomic, weak) id <ABAllActivityDaysDelegate> delegate;

@end
