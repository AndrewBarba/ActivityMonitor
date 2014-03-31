//
//  ABActivityCell.m
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/8/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import "ABActivityCell.h"

@interface ABActivityCell() {
    UIView *_progressView;
}

@end

@implementation ABActivityCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
    
//    _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, self.height)];
//    _progressView.alpha = 0.7;
//    [self.contentView insertSubview:_progressView atIndex:0];
}

- (void)setActivityDay:(ABActivityDay *)activityDay
{
    if (_activityDay != activityDay) {
        _activityDay = activityDay;
    }
    [self _layoutActivityDay];
}

- (void)_layoutActivityDay
{
    self.textLabel.text = [NSString stringWithFormat:@"%@ steps", _activityDay.steps.decimalString];
    self.detailTextLabel.text = _activityDay.date.longStringRepresentation;
    _progressView.width = _activityDay.progress * self.width * 0.9;
    _progressView.backgroundColor = [UIColor colorForStepProgress:_activityDay.progress];
}

@end
