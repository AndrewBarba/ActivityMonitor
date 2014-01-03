//
//  ABStepCounter.m
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/3/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import "ABStepCounter.h"
#import <CoreMotion/CoreMotion.h>

@interface ABStepCounter() {
    CMStepCounter *_stepCounter;
}

@end

@implementation ABStepCounter

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
