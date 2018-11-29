//
//  NIFNowPlayingIndicatorView.m
//  Stereo
//
//  Created by Terry Lewis on 19/10/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import "NIFNowPlayingIndicatorView.h"

@implementation NIFNowPlayingIndicatorView{
    NSMutableArray *_levelViews;
}

/**
 *  Creates animations for the level views, animations are looped and are not removed upon completion.
 */
- (void)_updateLevelAnimations{
    BOOL shouldWindDown = NO;
    if (_playbackState == MPMusicPlaybackStatePaused || _playbackState == MPMusicPlaybackStateInterrupted) {
        shouldWindDown = YES;
    }else if (_playbackState == MPMusicPlaybackStateStopped){
        [self _removeAllAnimations:YES];
        return;
    }
    
    static NSString *const kAnimationIdentifier = @"nowPlayingIndicatorAnimation";
    static NSString *const kWindDownAnimationIdentifier = @"nowPlayingIndicatorWindDownAnimation";
    for (UIView *view in _levelViews) {
        
        [view.layer removeAnimationForKey:kAnimationIdentifier];
        if (shouldWindDown) {
            //            [UIView animateWithDuration:0.45f
            //                                  delay:0
            //                                options:0
            //                             animations:^{
            //                                 CGRect bounds = view.bounds;
            //                                 bounds.size.height = _minimumLevelHeight;
            //                                 view.bounds = bounds;
            //                             } completion:nil];
            
            [CATransaction begin];
            CABasicAnimation *windDownAnimation = [CABasicAnimation animationWithKeyPath:@"bounds.size.height"];
            windDownAnimation.duration = ((arc4random()%RAND_MAX)/(RAND_MAX*1.0))*(0.5-0.4)+0.4;
            windDownAnimation.fillMode = kCAFillModeBoth;
            windDownAnimation.fromValue = [view.layer.presentationLayer valueForKeyPath:@"bounds.size.height"];
            windDownAnimation.toValue = @(_minimumLevelHeight);
            windDownAnimation.removedOnCompletion = YES;
            windDownAnimation.autoreverses = NO;
            windDownAnimation.repeatCount = 0;
            windDownAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            [view.layer addAnimation:windDownAnimation forKey:kWindDownAnimationIdentifier];
            [CATransaction setCompletionBlock:^{
                CGRect bounds = view.layer.bounds;
                bounds.size.height = _minimumLevelHeight;
                view.layer.bounds = bounds;
            }];
            [CATransaction commit];
            
            continue;
        }
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds.size.height"];
        animation.duration = ((arc4random()%RAND_MAX)/(RAND_MAX*1.0))*(0.5-0.4)+0.4;
        animation.fillMode = kCAFillModeBoth;
        animation.fromValue = @(_minimumLevelHeight);
        animation.toValue = @(_maximumLevelHeight);
        animation.removedOnCompletion = NO;
        animation.autoreverses = YES;
        animation.repeatCount = HUGE_VALF;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [view.layer addAnimation:animation forKey:kAnimationIdentifier];
        
        //        [UIView animateWithDuration:((arc4random()%RAND_MAX)/(RAND_MAX*1.0))*(0.4-0.1)+0.2
        //                              delay:0
        //                            options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse
        //                         animations:^{
        //                             CGRect rect = view.bounds;
        //                             rect.size.height = _maximumLevelHeight;
        //                             view.bounds = rect;
        //                         } completion:nil];
    }
}

/**
 *  Sets the level gutters colour and redraws the level gutters.
 *
 *  @param levelGuttersColor the colour of the level gutters.
 */
- (void)setLevelGuttersColor:(UIColor *)levelGuttersColor{
    _levelGuttersColor = levelGuttersColor;
    [self setNeedsDisplay];
}

/**
 *  Shows or hides the level gutters. Once set, the view will redraw.
 *
 *  @param showsLevelGutters the desired visibility of the level gutters.
 */
- (void)setShowsLevelGutters:(BOOL)showsLevelGutters{
    _showsLevelGutters = showsLevelGutters;
    [self setNeedsDisplay];
}

/**
 *  Updates the playback state of the view. This can be used to pause the animations or start them.
 *
 *  @param playbackState the playback state.
 */
- (void)setPlaybackState:(MPMusicPlaybackState)playbackState{
    _playbackState = playbackState;
    [self _updateLevelAnimations];
}

/**
 *  Sets the number of levels. This will cuase an update to the level gutters, thus calling a redraw.
 *
 *  @param showsLevelGutters the number of levels.
 */
- (void)setNumberOfLevels:(NSInteger)showsLevelGutters{
    _showsLevelGutters = showsLevelGutters;
    [self _reloadLevelViews];
}

/**
 *  Sets the minimum height that any given level can have.
 *
 *  @param minimumLevelHeight the minimum height, in points of the level.
 */
- (void)setMinimumLevelHeight:(CGFloat)minimumLevelHeight{
    _minimumLevelHeight = minimumLevelHeight;
    [self _reloadLevelViews];
}

/**
 *  Sets the maximum height that any given level can have.
 *
 *  @param maximumLevelHeight the maximum height, in points of the level.
 */
- (void)setMaximumLevelHeight:(CGFloat)maximumLevelHeight{
    _maximumLevelHeight = maximumLevelHeight;
    [self _reloadLevelViews];
}

/**
 *  Sets the width of the levels.
 *
 *  @param levelWidth the width, in points of the level.
 */
- (void)setLevelWidth:(CGFloat)levelWidth{
    _levelWidth = levelWidth;
    [self _reloadLevelViews];
}

/**
 *  Sets the corner radius of the levels.
 *
 *  @param levelCornerRadius the corner radius, in points of the level.
 */
- (void)setLevelCornerRadius:(CGFloat)levelCornerRadius{
    _levelCornerRadius = levelCornerRadius;
    [self _reloadLevelViews];
}

/**
 *  Sets the spacing between levels.
 *
 *  @param interLevelSpacing the spacing, in points between the levels.
 */
- (void)setInterLevelSpacing:(CGFloat)interLevelSpacing{
    _interLevelSpacing = interLevelSpacing;
    [self _reloadLevelViews];
}

/**
 *  Called when the tint colour of this class changes, updates the level tint colours and the gutter tint colours if the gutter tint colour is unset.
 */
- (void)tintColorDidChange{
    for (UIView *view in _levelViews){
        view.backgroundColor = self.tintColor;
    }
    if (!_levelGuttersColor) {
        [self setNeedsDisplay];
    }
}

/**
 *  Removes the level views and creates them using the properties and instance variables set within this class.
 */
- (void)_reloadLevelViews{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    _levelViews = [NSMutableArray array];
    for (int i = 0; i < _numberOfLevels; i++) {
        CGFloat x = i * (_levelWidth + _interLevelSpacing);
        CGFloat y = _maximumLevelHeight;
        CGRect frame = CGRectMake(x, y, _levelWidth, 0);
        
        UIView *view = [[UIView alloc] initWithFrame:frame];
        view.backgroundColor = self.tintColor;
        view.layer.anchorPoint = CGPointMake(0.5, 1);
        view.layer.cornerRadius = _levelCornerRadius;
        [_levelViews addObject:view];
        [self addSubview:view];
    }
    [self _updateLevelAnimations];
    [self setNeedsDisplay];
}

/**
 *  Draws the gutters if they are enabled, if not, returns immediately.
 *
 *  @param rect the rect in which the drawing is limited to.
 */
- (void)drawRect:(CGRect)rect{
    if (self.hidden) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    if (self.backgroundColor) {
        CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
        CGContextFillRect(context, rect);
    }
    if (_showsLevelGutters) {
        CGColorRef gutterColour = _levelGuttersColor ? _levelGuttersColor.CGColor : [self.tintColor colorWithAlphaComponent:0.2f].CGColor;
        for (int i = 0; i < _numberOfLevels; i++) {
            CGFloat x = i * (_levelWidth + _interLevelSpacing);
            CGRect rect = CGRectMake(x, 0, _levelWidth, _maximumLevelHeight);
            CGContextSetFillColorWithColor(context, gutterColour);
            CGContextFillRect(context, rect);
        }
    }
}

/**
 *  Removes animations for the levels.
 *
 *  @param animated whether the animations should "wind down"
 */
- (void)_removeAllAnimations:(BOOL)animated{
    for (UIView *view in _levelViews){
        [view.layer removeAllAnimations];
        if (animated) {
            
        }
    }
}

/**
 *  Returns the optimimum size for the view, given it's subviews.
 *
 *  @param size the size of the view it aims to fit into, this is ignored.
 *
 *  @return the calculated size.
 */
- (CGSize)sizeThatFits:(CGSize)size{
    CGFloat width = 0;
    if (_numberOfLevels <= 1) {
        width = _numberOfLevels * _levelWidth;
    }else{
        width = _numberOfLevels * _levelWidth + (_numberOfLevels - 1) * _interLevelSpacing;
    }
    return CGSizeMake(width, _maximumLevelHeight);
}

/**
 *  Sets the anchor point and resizes the view to fit the levels.
 */
- (void)layoutSubviews{
    [super layoutSubviews];
    [self sizeToFit];
}

/**
 *  Setup view with default values.
 *
 *  @param frame frame in which the view should encompass.
 *
 *  @return the configured view.
 */
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _numberOfLevels = 3;
        _minimumLevelHeight = 3;
        _maximumLevelHeight = 13;
        _levelWidth = 3;
        _levelCornerRadius = 0.5f;
        _interLevelSpacing = 1.5f;
        _playbackState = 0;
        self.opaque = NO;
        [self _reloadLevelViews];
    }
    return self;
}

@end
