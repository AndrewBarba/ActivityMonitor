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

@interface ABStepCounter() {
    CMStepCounter *_stepCounter; // shared step counter
    NSOperationQueue *_backgroundQueue;
    NSInteger _totalStepsForSession;
}

@end

@implementation ABStepCounter

- (void)startMonitoringStepCount
{
    [_stepCounter startStepCountingUpdatesToQueue:_backgroundQueue
                                         updateOn:5
                                      withHandler:^(NSInteger steps, NSDate *timestamp, NSError *error){
                                          if (!error) {
                                              
                                              // update new steps
                                              NSInteger newSteps = steps - _totalStepsForSession;
                                              _totalStepsForSession = steps;
                                              NSLog(@"NEW STEPS: %@", @(newSteps));
                                              
                                              [self _addSteps:newSteps toActivityDayWithDate:timestamp onCompletion:^(ABActivityDay *day, NSError *error){
                                                  [[NSNotificationCenter defaultCenter] postNotificationName:ABActivityDayUpdatedNotificationKey
                                                                                                      object:day];
                                              }];
                                          } else {
                                              NSLog(@"WARNING: Error gathering step data");
                                          }
                                      }];
}

- (void)stopMonitoringStepCount
{
    [_stepCounter stopStepCountingUpdates];
    _totalStepsForSession = 0;
}

#pragma mark - Helpers

- (void)_addSteps:(NSInteger)steps toActivityDayWithDate:(NSDate *)date onCompletion:(ABActivityDayBlock)complete
{
    [[ABDataManager sharedManager] importData:^(NSManagedObjectContext *context){
        ABActivityDay *day = [ABActivityDay activityDayForDate:date inContext:context];
        [day addSteps:steps];
        return ^{
            if (complete) {
                complete([day referenceInContext:nil], nil);
            }
        };
    }];
}

#pragma mark - Availability

- (BOOL)isStepCountingAvailable
{
    return _stepCounter != nil;
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
