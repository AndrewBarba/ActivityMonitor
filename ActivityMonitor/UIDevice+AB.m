//
//  UIDevice+AB.m
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/4/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import "UIDevice+AB.h"

#define AB_INSTALL_ID_KEY @"ABInstallIdKey"

@implementation UIDevice (AB)

+ (NSString *)vendorIdentifier
{
    static NSString *identifier = nil;
    AB_DISPATCH_ONCE(^{
        identifier = [UIDevice currentDevice].identifierForVendor.UUIDString;
    });
    return identifier;
}

+ (NSString *)installIdentifier
{
    static NSString *identifier = nil;
    AB_DISPATCH_ONCE(^{
        identifier = [[NSUserDefaults standardUserDefaults] stringForKey:AB_INSTALL_ID_KEY];
        if (!identifier) {
            identifier = [[NSUUID UUID] UUIDString];
            [[NSUserDefaults standardUserDefaults] setObject:identifier forKey:AB_INSTALL_ID_KEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    });
    return identifier;
}

@end
