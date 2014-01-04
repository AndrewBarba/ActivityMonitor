//
//  UIColor+AB.m
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/3/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import "UIColor+AB.h"

@implementation UIColor (AB)

+ (instancetype)activitySuccessColor
{
    static id color = nil;
    AB_DISPATCH_ONCE(^{
        color = [UIColor greenColor];
    });
    return color;
}

@end
