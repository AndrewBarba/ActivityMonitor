//
//  UIView+AB.m
//  ActivityMonitor
//
//  Created by Andrew Barba on 1/3/14.
//  Copyright (c) 2014 Andrew Barba. All rights reserved.
//

#import "UIView+AB.h"

@implementation UIView (AB)

- (void)setOriginX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setOriginY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (void)setOrigin:(CGPoint)point
{
    [self setOriginX:point.x];
    [self setOriginY:point.y];
}

- (void)centerVerticallyInView:(UIView *)view
{
    CGFloat y = (view.frame.size.height - self.frame.size.height) / 2;
    [self setOriginY:y];
}

- (void)centerHorizontallyInView:(UIView *)view
{
    CGFloat x = (view.frame.size.width - self.frame.size.width) / 2;
    [self setOriginX:x];
}

- (void)centerInView:(UIView *)view
{
    [self centerVerticallyInView:view];
    [self centerHorizontallyInView:view];
}

- (void)centerVerticallyInSuperView
{
    [self centerVerticallyInView:self.superview];
}

- (void)centerHorizontallyInSuperView
{
    [self centerHorizontallyInView:self.superview];
}

- (void)centerInSuperView
{
    [self centerVerticallyInSuperView];
    [self centerHorizontallyInSuperView];
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setSize:(CGSize)size
{
    [self setWidth:size.width];
    [self setHeight:size.height];
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)originX
{
    return self.frame.origin.x;
}

- (CGFloat)originY
{
    return self.frame.origin.y;
}

- (void)applyBottomGradient
{
    ABDispatchMain(^{
        CAGradientLayer *layer = [CAGradientLayer layer];
        
        CGFloat height = self.height * 0.5f;
        CGFloat width = self.width;
        layer.frame = CGRectMake(0, self.height-height, width, height);
        layer.colors = [NSArray arrayWithObjects:
                        (id)[[UIColor clearColor] CGColor],
                        (id)[[[UIColor blackColor] colorWithAlphaComponent:0.8f] CGColor],
                        nil];
        [self.layer addSublayer:layer];
    });
}

- (void)addMotionEffect
{
    // Set vertical effect
    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-20);
    verticalMotionEffect.maximumRelativeValue = @(20);
    
    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-20);
    horizontalMotionEffect.maximumRelativeValue = @(20);
    
    // Create group to combine both
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    // Add both effects to your view
    [self addMotionEffect:group];
}

@end
