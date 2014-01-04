//
//  ABMenuViewController.h
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/3/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import "ABViewController.h"
#import "ABAllActivityDaysViewController.h"
#import "ABActivityDayViewController.h"

@interface ABMenuViewController : ABViewController <ABAllActivityDaysDelegate>

// Controllers
@property (nonatomic, strong) ABAllActivityDaysViewController *allActivitiesViewController;
@property (nonatomic, strong) ABActivityDayViewController *activityDayViewController;

// Views
@property (nonatomic, strong) IBOutlet UIView *mainView;
@property (nonatomic, strong) IBOutlet UIView *bottomView;

@end
