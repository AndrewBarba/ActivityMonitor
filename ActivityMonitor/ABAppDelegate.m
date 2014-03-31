//
//  ABAppDelegate.m
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/2/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import "ABAppDelegate.h"
#import "ABStepCounter.h"
#import "ABDataManager.h"

@implementation ABAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    [NSNotificationCenter observe:ABActivityDayUpdatedNotificationKey on:^(NSNotification *notification){
        ABActivityDay *day = notification.object;
        if ([day.date isToday]) {
//            NSInteger count = MAX(0, [ABStepCounter sharedCounter].stepCountingGoal - day.steps.integerValue);
            NSInteger count = day.steps.integerValue;
            [application setApplicationIconBadgeNumber:count];
        }
    }];
    
    self.window.backgroundColor = [UIColor clearColor];
    
    return YES;
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    ABBlock update = ^{
        [[ABStepCounter sharedCounter] rebuildActivityDayForDate:nil onCompletion:^(ABActivityDay *day, NSError *error){
            if (day && !error) {
                if (completionHandler) {
                    completionHandler(UIBackgroundFetchResultNewData);
                }
            } else {
                if (completionHandler) {
                    completionHandler(UIBackgroundFetchResultFailed);
                }
            }
        }];
    };
    
    if ([ABDataManager sharedManager].isDocumentOpenAndReady) {
        update();
    } else {
        id observer = nil;
        observer = [NSNotificationCenter observe:ABMainDocumentOpenNotificationKey on:^(NSNotification *notification){
            update();
            [[NSNotificationCenter defaultCenter] removeObserver:observer name:ABMainDocumentOpenNotificationKey object:nil];
        }];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[ABDataManager sharedManager] saveDocument:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
