//
//  ABDispatch.m
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/2/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import "ABDispatch.h"

@implementation ABDispatch

void ABDispatchMain(ABBlock block)
{
    dispatch_async(dispatch_get_main_queue(),block);
}

void ABDispatchAfter(float after, ABBlock block)
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, after * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(),block);
}

void ABDispatchBackground(ABBlock block)
{
    dispatch_queue_t queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue,block);
}

@end
