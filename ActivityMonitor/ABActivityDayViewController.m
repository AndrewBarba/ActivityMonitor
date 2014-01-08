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
@property (strong, nonatomic) UIView *progressView;

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
        self.activityDay = [ABActivityDay activityDayForDate:_activityDay.date inContext:[ABDataManager sharedManager].mainContext];
        [self reloadData];
    }];
    
    [NSNotificationCenter observe:UIApplicationDidEnterBackgroundNotification on:^(NSNotification *notification){
        self.activityDay = [ABActivityDay activityDayForDate:nil inContext:[ABDataManager sharedManager].mainContext];
    }];
    
    [NSNotificationCenter observe:UIApplicationWillEnterForegroundNotification on:^(NSNotification *notification){
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
    
    float progress = _activityDay.progress;
    UIColor *progressColor = [UIColor colorForStepProgress:progress];
    self.stepsLabel.textColor = progressColor;
    self.progressView.backgroundColor = progressColor;
    
    CGFloat pHeight = self.view.height * progress;
    self.progressView.frame = ({
        CGRect frame = CGRectMake(0, self.view.height-pHeight, self.view.width, pHeight);
        frame;
    });
}

#pragma mark - Step Label

- (void)setStepsLabel:(UILabel *)stepsLabel
{
    if (_stepsLabel != stepsLabel) {
        _stepsLabel = stepsLabel;
        _stepsLabel.layer.cornerRadius = MIN(_stepsLabel.height, _stepsLabel.width) / 2.0f;
        _stepsLabel.backgroundColor = [UIColor whiteColor];
//        _stepsLabel.layer.borderWidth = 8.0;
//        _stepsLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    }
}

- (UIView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.view insertSubview:_progressView atIndex:0];
    }
    return _progressView;
}

@end
