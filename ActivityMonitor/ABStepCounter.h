//
//  ABStepCounter.h
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/3/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABActivityDay+AB.h"

@interface ABStepCounter : NSObject

- (BOOL)isStepCountingAvailable;

+ (instancetype)sharedCounter;

@end
