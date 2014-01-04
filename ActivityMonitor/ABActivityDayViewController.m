//
//  ABActivityDayViewController.m
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/3/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import "ABActivityDayViewController.h"
#import "ABStepCounter.h"
#import "ABDataManager.h"

@interface ABActivityDayViewController ()

@property (weak, nonatomic) IBOutlet UILabel *stepsLabel;

@end

@implementation ABActivityDayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.activityDay = [ABActivityDay activityDayForDate:nil inContext:[ABDataManager sharedManager].mainContext];
    
    [[ABStepCounter sharedCounter] rebuildActivityDayForDate:nil onCompletion:^(ABActivityDay *day, NSError *error){
        if (day && !error) {
            self.activityDay = day;
        }
    }];
	
    [NSNotificationCenter observe:ABActivityDayUpdatedNotificationKey on:^(NSNotification *notification){
        [self reloadData];
    }];
    
    [NSNotificationCenter observe:UIApplicationDidEnterBackgroundNotification on:^(NSNotification *notification){
        self.activityDay = [ABActivityDay activityDayForDate:nil inContext:[ABDataManager sharedManager].mainContext];
    }];
}

- (void)setActivityDay:(ABActivityDay *)activityDay
{
    if (_activityDay != activityDay) {
        _activityDay = activityDay;
    }
    [self reloadData];
}

- (void)reloadData
{
    // update UI
    self.stepsLabel.text = [NSString stringWithFormat:@"%@\nsteps", _activityDay.steps.decimalString];
}

#pragma mark - Step Label

- (void)setStepsLabel:(UILabel *)stepsLabel
{
    if (_stepsLabel != stepsLabel) {
        _stepsLabel = stepsLabel;
        _stepsLabel.layer.cornerRadius = MIN(_stepsLabel.height, _stepsLabel.width) / 2.0f;
        _stepsLabel.layer.borderWidth = 4.0;
        _stepsLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    }
}

@end
