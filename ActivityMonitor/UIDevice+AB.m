//
//  UIDevice+AB.m
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/4/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import "UIDevice+AB.h"
#import <AdSupport/AdSupport.h>

#define AB_INSTALL_ID_KEY @"ABInstallIdKey"

@implementation UIDevice (AB)

+ (NSString *)deviceIdentifier
{
    static NSString *identifier = nil;
    AB_DISPATCH_ONCE(^{
        identifier = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
    });
    return identifier;
}

@end
