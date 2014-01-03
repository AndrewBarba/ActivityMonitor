//
//  ABRootViewController.m
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/2/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import "ABRootViewController.h"
#import "ABDataManager.h"

@implementation ABRootViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    AB_DISPATCH_ONCE(^{
        [[ABDataManager sharedManager] openDocument:^(BOOL success){
            NSLog(@"OPENED DOCUMENT: %i", success);
        }];
    });
}

@end
