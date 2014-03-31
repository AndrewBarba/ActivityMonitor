//
//  ABActivityCell.h
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/8/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABActivityDay.h"

@interface ABActivityCell : UITableViewCell

@property (nonatomic, weak) ABActivityDay *activityDay;

@end
