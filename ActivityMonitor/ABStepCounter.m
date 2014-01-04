//
//  ABStepCounter.m
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/3/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import "ABStepCounter.h"
#import <CoreMotion/CoreMotion.h>
#import "ABDataManager.h"

#define AB_STEP_COUNTING_KEY @"ABStepCountingOkay"
#define AB_STEP_COUNTING_GOAL_KEY @"ABStepCountingGoal"

@interface ABStepCounter() {
    CMStepCounter *_stepCounter; // shared step counter
    NSOperationQueue *_backgroundQueue;
    NSInteger _totalStepsForSession;
}

@end

@implementation ABStepCounter

#pragma mark - Monitoring

- (void)startMonitoringStepCount
{
    [_stepCounter startStepCountingUpdatesToQueue:_backgroundQueue
                                         updateOn:5
                                      withHandler:^(NSInteger steps, NSDate *timestamp, NSError *error){
                                          [self rebuildActivityDayForDate:timestamp onCompletion:nil];
                                      }];
}

- (void)stopMonitoringStepCount
{
    [_stepCounter stopStepCountingUpdates];
    _totalStepsForSession = 0;
}

#pragma mark - History

- (void)rebuildAllActivity:(ABSetBlock)complete
{
    if (!_stepCounter) {
        if (complete) {
            complete(nil);
        }
    }
    
    [self _rebuildActivityHelper:7 days:[NSMutableSet set] onCompletion:complete];
}

- (void)_rebuildActivityHelper:(NSInteger)remaining days:(NSMutableSet *)days onCompletion:(ABSetBlock)complete
{
    ABDispatchBackground(^{
        if (remaining == 0) {
            if (complete) {
                complete(days);
            }
        } else {
            NSDate *date = [[NSDate date].diaryDate dateByAddingUnit:NSCalendarUnitDay offset:(-1 * remaining)];
            [self rebuildActivityDayForDate:date onCompletion:^(ABActivityDay *day, NSError *error){
                if (day && !error) {
                    [days addObject:day];
                }
                [self _rebuildActivityHelper:remaining-1 days:days onCompletion:complete];
            }];
        }
    });
}

- (void)rebuildActivityDayForDate:(NSDate *)date onCompletion:(ABActivityDayBlock)complete
{
    if (!_stepCounter) {
        if (complete) {
            complete(nil, [NSError errorWithDomain:@"Step counting is not available on this device" code:0 userInfo:nil]);
        }
    }
    
    if (!date) {
        date = [NSDate date];
    }
    
    NSDate *start = [date diaryDate];
    NSDate *end = [start tomorrow];
    
    [_stepCounter queryStepCountStartingFrom:start to:end toQueue:_backgroundQueue withHandler:^(NSInteger steps, NSError *error){
        if (!error) {
            [[ABDataManager sharedManager] importData:^(NSManagedObjectContext *context){

                ABActivityDay *day = [ABActivityDay activityDayForDate:start inContext:context];
                day.steps = @(steps);
                
                return ^{
                    ABActivityDay *newDay = [day referenceInContext:nil];
                    if (complete) {
                        complete(newDay, nil);
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:ABActivityDayUpdatedNotificationKey
                                                                        object:newDay];
                };
            }];
        } else {
            if (complete) {
                complete(nil, error);
            }
        }
    }];
}

#pragma mark - Step Goal

- (NSInteger)stepCountingGoal
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:AB_STEP_COUNTING_GOAL_KEY];
}

- (void)setStepCountingGoal:(NSInteger)steps
{
    [[NSUserDefaults standardUserDefaults] setInteger:steps forKey:AB_STEP_COUNTING_GOAL_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Availability

- (ABStepCountingStatus)stepCountingStatus
{
    if (_stepCounter == nil) {
        return ABStepCountingStatusNotSupported;
    }
    
    ABStepCountingStatus status = [[NSUserDefaults standardUserDefaults] integerForKey:AB_STEP_COUNTING_KEY];
    return status;
}

#pragma mark - Initialization

AB_DISABLE_INIT()

- (id)_initPrivate
{
    self = [super init];
    if (self) {
        _backgroundQueue = [[NSOperationQueue alloc] init];
        if ([CMStepCounter isStepCountingAvailable]) {
            _stepCounter = [[CMStepCounter alloc] init];
        }
        
        if (self.stepCountingGoal == 0) {
            [self setStepCountingGoal:10000];
        }
    }
    return self;
}

+ (instancetype)sharedCounter
{
    static ABStepCounter *counter = nil;
    AB_DISPATCH_ONCE(^{
        counter = [[self alloc] _initPrivate];
    });
    return counter;
}

@end
