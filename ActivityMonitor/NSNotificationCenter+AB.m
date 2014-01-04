//
//  NSNotificationCenter+AB.m
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/3/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import "NSNotificationCenter+AB.h"

@implementation NSNotificationCenter (AB)

+ (void)observe:(NSString *)name on:(void (^)(NSNotification *))block
{
    [[NSNotificationCenter defaultCenter] addObserverForName:name object:nil queue:[NSOperationQueue mainQueue] usingBlock:block];
}

@end
