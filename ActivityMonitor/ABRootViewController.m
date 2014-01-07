//
//  ABRootViewController.m
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/2/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import "ABRootViewController.h"
#import "ABDataManager.h"
#import "ABStepCounter.h"

@implementation ABRootViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    AB_DISPATCH_ONCE(^{
        [[ABDataManager sharedManager] openDocument:^(BOOL success){            
            [self _handleDocumentOpened];
        }];
    });
}

- (void)_handleDocumentOpened
{
    ABBlock done = ^{
        ABDispatchMain(^{
            [[ABStepCounter sharedCounter] startMonitoringStepCount];
            [self performSegueWithIdentifier:@"Main Segue" sender:self];
        });
    };
    
    NSSet *set = [ABActivityDay allObjectsInContext:nil];
    if (set.count == 0) {
        [[ABStepCounter sharedCounter] rebuildAllActivity:^(NSSet *set){
            done();
        }];
    } else {
        done();
    }
}

@end
