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
    [UIView animateWithDuration:0.5 animations:^{
        // update UI
        self.stepsLabel.text = [NSString stringWithFormat:@"%@\nsteps", _activityDay.steps.decimalString];
        
        float progress = _activityDay.progress;
        UIColor *progressColor = [UIColor colorForStepProgress:progress];
        self.stepsLabel.textColor = progressColor;
        self.stepsLabel.layer.borderColor = progressColor.CGColor;
        self.progressView.backgroundColor = progressColor;
        
        self.progressView.frame = ({
            CGFloat pHeight = self.view.height * 0.9 * progress;
            CGRect frame = CGRectMake(0, self.view.height-pHeight, self.view.width, pHeight);
            frame;
        });
    }];
}

#pragma mark - Step Label

- (void)setStepsLabel:(UILabel *)stepsLabel
{
    if (_stepsLabel != stepsLabel) {
        _stepsLabel = stepsLabel;
        _stepsLabel.layer.cornerRadius = MIN(_stepsLabel.height, _stepsLabel.width) / 2.0f;
        _stepsLabel.backgroundColor = [UIColor whiteColor];
        [_stepsLabel addMotionEffect];
        _stepsLabel.layer.borderWidth = 2.0;
        _stepsLabel.backgroundColor = [UIColor colorWithWhite:0.99 alpha:0.9];
    }
}

- (UIView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.view.height, self.view.width, 0.0)];
        [self.view insertSubview:_progressView atIndex:0];
    }
    return _progressView;
}

@end
