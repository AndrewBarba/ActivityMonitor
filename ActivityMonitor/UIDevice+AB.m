//
//  UIDevice+AB.m
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/4/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import "UIDevice+AB.h"

@implementation UIDevice (AB)

+ (NSString *)vendorIdentifier
{
    static NSString *identifier = nil;
    AB_DISPATCH_ONCE(^{
        identifier = [UIDevice currentDevice].identifierForVendor.UUIDString;
    });
    return identifier;
}

@end
