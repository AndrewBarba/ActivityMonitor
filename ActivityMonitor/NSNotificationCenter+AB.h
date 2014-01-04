//
//  NSNotificationCenter+AB.h
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/3/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (AB)

+ (id)observe:(NSString *)name on:(void(^)(NSNotification *notification))block;

@end
