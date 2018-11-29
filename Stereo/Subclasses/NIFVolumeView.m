//
//  NIFVolumeView.m
//  Stereo
//
//  Created by Terry Lewis on 4/09/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import "NIFVolumeView.h"

@interface NIFVolumeView (){
    BOOL _lastState;
}

@end

@implementation NIFVolumeView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self _removeAnimationsOnSubviews:self];
        [self setup];
#ifdef DEBUG
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_debug_toggleSliderAirplayMode)];
        tap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:tap];
#endif
    }
    return self;
}

/**
 *  debug method, please ignore.
 */
#ifdef DEBUG
- (void)_debug_toggleSliderAirplayMode{
    [self updateSliderImagesShowingMaximumButton:!_lastState];
}
#endif

/**
 *  Sets the values and properties which aren't changed, registers for notifications.
 */
- (void)setup{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routesAvailabilityChangedNotification:) name:MPVolumeViewWirelessRoutesAvailableDidChangeNotification object:nil];
    [self setVolumeThumbImage:[UIImage imageNamed:@"now-playing-volume-thumb"] forState:UIControlStateNormal];
    [self setRouteButtonImage:[UIImage imageNamed:@"airplay"] forState:UIControlStateNormal];
}

/**
 *  Attempt to implement a more reliable method to determine if the airplay button is showing.
 *
 *  @return whether airplay button is showing.
 */
- (BOOL)showingAirplayButton{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"MPButton")]) {
            if (view.hidden || view.alpha == 0 || CGRectEqualToRect(view.frame, CGRectZero) || CGSizeEqualToSize(view.frame.size, CGSizeZero)) {
                return NO;
            }else{
                return YES;
            }
        }
    }
    return NO;
}

- (void)updateSliderImagesShowingMaximumButton:(BOOL)showMaximumButton{
    /**
     *  if wireless routes (airplay) are available, hide the max volume icon.
     *  The order here matters -so- much.
     *  If changed, things like track colour won't apply, buttons at either
     *  end may disappear, etc.
     */
    _lastState = showMaximumButton;
    for (UISlider *view in self.subviews) {
        if ([view isKindOfClass:[UISlider class]]) {
            UISlider *slider = (UISlider *)view;
            [slider setMinimumTrackTintColor:[UIColor blackColor]];
            [slider setMaximumTrackTintColor:[UIColor _volumeSliderGreyColour]];
            [slider setTintColor:[UIColor _volumeSliderGreyColour]];
            [self setMinimumVolumeSliderImage:[UIImage imageNamed:@"VolumeTrackImageMinimum"] forState:UIControlStateNormal];
            [self setMaximumVolumeSliderImage:[UIImage imageNamed:@"VolumeTrackImageMaximum"] forState:UIControlStateNormal];
            [slider setMinimumValueImage:[[UIImage imageNamed:@"volume-minimum-value-image"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            if (showMaximumButton) {
                [slider setMaximumValueImage:[[UIImage imageNamed:@"volume-maximum-value-image"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            }else{
                [slider setMaximumValueImage:nil];
            }
        }
    }
}

/**
 *  updates the slider to reflect the current wireless route availablility state.
 */
- (void)updateSliderImages{
    [self updateSliderImagesShowingMaximumButton:![self areWirelessRoutesAvailable]];
}

/**
 *  Called when airplay availability changes.
 *
 *  @param notification the received notification.
 */
- (void)routesAvailabilityChangedNotification:(NSNotification *)notification{
    [self updateSliderImages];
}

/**
 *  unregister notifications
 */
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self updateSliderImages];
    [self _removeAnimationsOnSubviews:self];
}

/**
 *  Destroy animations on views.
 *
 *  @param view view to have animations recursively removed on.
 */
- (void)_removeAnimationsOnSubviews:(UIView *)view
{
    [view.layer removeAllAnimations];
    for (UIView *subview in view.subviews) {
        [self _removeAnimationsOnSubviews:subview];
    }
}

- (CGRect)routeButtonRectForBounds:(CGRect)bounds{
    CGRect rect = [super routeButtonRectForBounds:bounds];
//    NSLog(@"%@", NSStringFromCGRect(rect));
    rect.size.width = 15.4;
    rect.size.height = 13.3;
    CGRect volumeRect = [self volumeSliderRectForBounds:bounds];
    rect.origin.y = volumeRect.origin.y + volumeRect.size.height/2 - rect.size.height / 2;
    return rect;
}


@end
