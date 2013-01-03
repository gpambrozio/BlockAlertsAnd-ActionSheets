//
//  BlockBackground.m
//  arrived
//
//  Created by Gustavo Ambrozio on 29/11/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "BlockBackground.h"
#import "BlockUI.h"

static inline double radians (double degrees) {return degrees * M_PI/180.0;}


@implementation BlockBackground

@synthesize backgroundImage = _backgroundImage;
@synthesize vignetteBackground = _vignetteBackground;

static BlockBackground *_sharedInstance = nil;

+ (BlockBackground*)sharedInstance
{
    if (_sharedInstance != nil) {
        return _sharedInstance;
    }

    @synchronized(self) {
        if (_sharedInstance == nil) {
            [[[self alloc] init] autorelease];
        }
    }

    return _sharedInstance;
}

+ (id)allocWithZone:(NSZone*)zone
{
    @synchronized(self) {
        if (_sharedInstance == nil) {
            _sharedInstance = [super allocWithZone:zone];
            return _sharedInstance;
        }
    }
    NSAssert(NO, @ "[BlockBackground alloc] explicitly called on singleton class.");
    return nil;
}

- (id)copyWithZone:(NSZone*)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (unsigned)retainCount
{
    return UINT_MAX;
}

- (oneway void)release
{
}

- (id)autorelease
{
    return self;
}

- (id)init
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar;
        self.hidden = YES;
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor colorWithWhite:kBlockUIBackgroundWhite alpha:kBlockUIBackgroundAlpha];
        self.vignetteBackground = NO;
    }
    return self;
}

- (void)applyInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    CGRect mainScreenBounds = [[UIScreen mainScreen] bounds];
    switch( interfaceOrientation )
    {
        case UIInterfaceOrientationPortrait:
            self.bounds = CGRectMake( self.bounds.origin.x, self.bounds.origin.y, mainScreenBounds.size.width, mainScreenBounds.size.height);
            self.transform = CGAffineTransformMakeRotation(0);
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                self.bounds = CGRectMake( self.bounds.origin.x, self.bounds.origin.y, mainScreenBounds.size.width, mainScreenBounds.size.height);
                self.transform = CGAffineTransformMakeRotation(radians(180));
            }
            else // Phone isn't allowed to do upside down orientation
            {
                self.bounds = CGRectMake( self.bounds.origin.x, self.bounds.origin.y, mainScreenBounds.size.width, mainScreenBounds.size.height);
                self.transform = CGAffineTransformMakeRotation(0);
            }
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
            self.bounds = CGRectMake( self.bounds.origin.x, self.bounds.origin.y, mainScreenBounds.size.height, mainScreenBounds.size.width);
            self.transform = CGAffineTransformMakeRotation(radians(-90));
            
            break;
            
        case UIInterfaceOrientationLandscapeRight:
            self.bounds = CGRectMake( self.bounds.origin.x, self.bounds.origin.y, mainScreenBounds.size.height, mainScreenBounds.size.width);
            self.transform = CGAffineTransformMakeRotation(radians(90));
            break;
    }
}

- (void)applyInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        [self applyInterfaceOrientation:interfaceOrientation];
    }];
}

- (void)addToMainWindow:(UIView *)view
{
    if( self.hidden )
    {
        _previousKeyWindow = [[[UIApplication sharedApplication] keyWindow] retain];
        self.alpha = 0.0f;
        self.hidden = NO;
    }
    
    // Make sure user interaction is enabled and that we are the key window
    self.userInteractionEnabled = YES;
    [self makeKeyWindow];

    // If there is a previous view, we turn off userInteraction for it so only the top view will get events.
    if (self.subviews.count > 0)
    {
        ((UIView*)[self.subviews lastObject]).userInteractionEnabled = NO;
    }
    
    if (_backgroundImage)
    {
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:_backgroundImage];
        backgroundView.frame = self.bounds;
        backgroundView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:backgroundView];
        [backgroundView release];
        [_backgroundImage release];
        _backgroundImage = nil;
    }
    
    // Make sure the view is on the top and that user interation is enabled
    [self addSubview:view];
    view.userInteractionEnabled = YES;
}




- (void)reduceAlphaIfEmpty
{
    if (self.subviews.count == 1 || (self.subviews.count == 2 && [[self.subviews objectAtIndex:0] isKindOfClass:[UIImageView class]]))
    {
        self.alpha = 0.0f;
        self.userInteractionEnabled = NO;
    }
}




- (void)removeView:(UIView *)view
{
    [view removeFromSuperview];

    UIView *topView = [self.subviews lastObject];
    if ([topView isKindOfClass:[UIImageView class]])
    {
        // It's a background. Remove it too
        [topView removeFromSuperview];
    }
    
    if( self.subviews.count == 0 )
    {
        self.hidden = YES;
        [_previousKeyWindow makeKeyWindow];
        [_previousKeyWindow release];
        _previousKeyWindow = nil;
    }
    else
    {
        ((UIView*)[self.subviews lastObject]).userInteractionEnabled = YES;
    }
}




- (void)drawRect:(CGRect)rect 
{    
    if (_backgroundImage || !_vignetteBackground) return;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    size_t locationsCount = 2;
    CGFloat locations[2] = {0.0f, 1.0f};
    CGFloat colors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.75f}; 
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
    CGColorSpaceRelease(colorSpace);
    
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    float radius = MIN(self.bounds.size.width , self.bounds.size.height) ;
    CGContextDrawRadialGradient (context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient);
}

@end
