//
//  UIView+AB.h
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/3/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AB)

- (void)setOriginX:(CGFloat)x;

- (void)setOriginY:(CGFloat)y;

- (void)setOrigin:(CGPoint)point;

- (void)centerVerticallyInView:(UIView *)view;

- (void)centerHorizontallyInView:(UIView *)view;

- (void)centerInView:(UIView *)view;

- (void)centerVerticallyInSuperView;

- (void)centerHorizontallyInSuperView;

- (void)centerInSuperView;

- (void)setWidth:(CGFloat)width;

- (void)setHeight:(CGFloat)height;

- (void)setSize:(CGSize)size;

- (CGFloat)height;

- (CGFloat)width;

- (CGFloat)originX;

- (CGFloat)originY;

- (void)applyBottomGradient;

@end
