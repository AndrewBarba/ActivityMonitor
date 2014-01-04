//
//  ABMenuViewController.m
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/3/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import "ABMenuViewController.h"

#define AB_CLOSED_X 0
#define AB_OPENED_X (_mainView.width - 80.0f)

@interface ABMenuViewController () <UIGestureRecognizerDelegate> {
    BOOL _isMenuOpen;
}

@end

@implementation ABMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __weak typeof(self) _self = self;
    [NSNotificationCenter observe:UIApplicationDidEnterBackgroundNotification on:^(NSNotification *notification){
        [_self closeMenuAnimated:NO];
    }];
}

#pragma mark - Open And Close

- (void)openMenuAnimated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.325 animations:^{
            [_mainView setOriginX:AB_OPENED_X];
        }];
    } else {
        [_mainView setOriginX:AB_OPENED_X];
    }
    _isMenuOpen = YES;
}

- (void)closeMenuAnimated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.325 animations:^{
            [_mainView setOriginX:AB_CLOSED_X];
        }];
    } else {
        [_mainView setOriginX:AB_CLOSED_X];
    }
    _isMenuOpen = NO;
}

#pragma mark - All Activites

- (void)setAllActivitiesViewController:(ABAllActivityDaysViewController *)allActivitiesViewController
{
    if (_allActivitiesViewController != allActivitiesViewController) {
        _allActivitiesViewController = allActivitiesViewController;
        _allActivitiesViewController.delegate = self;
    }
}

- (void)activityDaysController:(ABAllActivityDaysViewController *)controller selectedActivityDay:(ABActivityDay *)day
{
    [self.activityDayViewController setActivityDay:day];
    [self closeMenuAnimated:YES];
}

#pragma mark - Activity Day

- (void)setActivityDayViewController:(ABActivityDayViewController *)activityDayViewController
{
    if (_activityDayViewController != activityDayViewController) {
        _activityDayViewController = activityDayViewController;
    }
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[ABAllActivityDaysViewController class]]) {
        self.allActivitiesViewController = segue.destinationViewController;
    }
    
    if ([segue.destinationViewController isKindOfClass:[ABActivityDayViewController class]]) {
        self.activityDayViewController = segue.destinationViewController;
    }
}

#pragma mark - Views

- (void)setMainView:(UIView *)mainView
{
    if (_mainView != mainView) {
        _mainView = mainView;
        _mainView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _mainView.layer.borderWidth = 0.5;
        _mainView.layer.shadowColor = [UIColor blackColor].CGColor;
        _mainView.layer.shadowRadius = 2.0;
        _mainView.layer.shadowOffset = CGSizeZero;
        _mainView.layer.shadowOpacity = 0.5;
        _mainView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_mainView.bounds].CGPath;
        _mainView.layer.shouldRasterize = YES;
        _mainView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handlePanGesture:)];
        pan.delegate = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleTapGesture:)];
        tap.delegate = self;
        [_mainView addGestureRecognizer:pan];
        [_mainView addGestureRecognizer:tap];
    }
}

- (void)_handlePanGesture:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint p = [pan translationInView:self.view];
        CGFloat add = _isMenuOpen ? AB_OPENED_X : AB_CLOSED_X;
        CGFloat x = (p.x + add);
        x = MIN(x, AB_OPENED_X);
        x = MAX(x, AB_CLOSED_X);
        [_mainView setOriginX:x];
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        CGPoint v = [pan velocityInView:self.view];
        CGFloat x = (v.x >= 0) ? AB_OPENED_X : AB_CLOSED_X;
        NSTimeInterval t = (fabsf(x - _mainView.originX) / fabsf(v.x)) * 2.0;
        t = MIN(t, 0.5);
        t = MAX(t, 0.1);
        [UIView animateWithDuration:t
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [_mainView setOriginX:x];
                         }
                         completion:nil];
        
        _isMenuOpen = (x == AB_OPENED_X);
    }
}

- (void)_handleTapGesture:(UITapGestureRecognizer *)tap
{
    if (_isMenuOpen) {
        [self closeMenuAnimated:YES];
    } else {
        [self openMenuAnimated:YES];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)recognizer
{
    if ([recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)recognizer;
        CGPoint p = [pan locationInView:_mainView];
        return p.x <= 80;
    } else if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        UITapGestureRecognizer *tap = (UITapGestureRecognizer *)recognizer;
        CGPoint p = [tap locationInView:_mainView];
        return p.x <= 80 && p.y <= 100;
    } else {
        return YES;
    }
}

@end
