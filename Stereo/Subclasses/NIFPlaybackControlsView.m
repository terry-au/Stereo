//
//  NIFPlaybackControlsView.m
//  Stereo
//
//  Created by Terry Lewis on 4/09/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import "NIFPlaybackControlsView.h"

@implementation NIFPlaybackControlsView{
    UIImage *_playImage, *_pauseImage;
    CGFloat _holdDuration;
}

#ifdef DEBUG
#ifdef DEBUGHITRECTS
/**
 *  Debug method used in order to highlight the hitzones of the playback controls.
 *
 *  @param rect the frame in which to draw in.
 */
- (void)drawRect:(CGRect)rect{
    NSArray *tmpviews = @[self, _previousButton, _playPauseButton, _nextButton];
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (NIFExtendedButton *view in tmpviews) {
        CGRect hitFrame;
        if ([view isKindOfClass:[NIFExtendedButton class]]) {
            hitFrame = UIEdgeInsetsInsetRect(hitFrame, view.hitTestEdgeInsets);
        }else{
            hitFrame = rect;
        }
        CGContextSetRGBFillColor(context, 1, 1, 1, 1);   //this is the transparent color
        CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 0.5);
        CGContextFillRect(context, hitFrame);
        CGContextStrokeRect(context, hitFrame);    //this will draw the border
    }
    [super drawRect:rect];
}
#endif
#endif

/**
 *  Sets up the view with the provided frame.
 *
 *  @param frame the frame.
 *
 *  @return the view, encompassing the provided frame.
 */
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        [self setupViews];
    }
    return self;
}

/**
 *  Caches the play and pause images in memory.
 */
- (void)_cachePlayButtonImages{
    _playImage = [UIImage imageNamed:@"now-playing-play"];
    _pauseImage = [UIImage imageNamed:@"now-playing-pause"];
}

/**
 *  Called when the playback state changes.
 *
 *  @param notification the notification, object is the playback controller.
 */
- (void)playbackStateDidChange:(NSNotification *)notification{
    //    [self refreshPlayButtonImagePlaying:[NIFMusicManager sharedManager]];
    MPMusicPlayerController *controller = notification.object;
    [self refreshPlayButtonImagePlaying:[self musicControllerIsPlaying:controller]];
    //    NSLog(@"%@", );
}

/**
 *  Determines whether the music control is playing
 *
 *  @param controller the playback controller
 *
 *  @return whether playback is occurring.
 */
- (BOOL)musicControllerIsPlaying:(id)controller{
    MPMusicPlayerController *tmpController = (MPMusicPlayerController *)controller;
    if (tmpController.playbackState == MPMusicPlaybackStatePlaying || tmpController.playbackState == MPMusicPlaybackStateSeekingBackward || tmpController.playbackState == MPMusicPlaybackStateSeekingForward) {
        return YES;
    }
    return NO;
}

/**
 *  Updates the play/pause image depending on the playback state.
 *
 *  @param playing the playback state
 */
- (void)refreshPlayButtonImagePlaying:(BOOL)playing{
    if (playing) {
        [_playPauseButton setImage:_pauseImage forState:UIControlStateNormal];
    }else{
        [_playPauseButton setImage:_playImage forState:UIControlStateNormal];
    }
}

/**
 *  Unregisters this view from notifications.
 */
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  Sets up and configures the views.
 */
- (void)setupViews{
    _playPauseButton = [NIFExtendedButton buttonWithType:UIButtonTypeSystem];
    _playPauseButton.translatesAutoresizingMaskIntoConstraints = NO;
    _nextButton = [NIFExtendedButton buttonWithType:UIButtonTypeSystem];
    _nextButton.translatesAutoresizingMaskIntoConstraints = NO;
    _previousButton = [NIFExtendedButton buttonWithType:UIButtonTypeSystem];
    _previousButton.translatesAutoresizingMaskIntoConstraints = NO;
    _playPauseButton.hitTestEdgeInsets = UIEdgeInsetsMake(-20.0f, -8.0f, -20.0f, -8.0f);
    _previousButton.hitTestEdgeInsets = UIEdgeInsetsMake(-20.0f, -140.0f, -20.0f, 0.0f);
    _nextButton.hitTestEdgeInsets = UIEdgeInsetsMake(-20.0f, 0.0f, -20.0f, -140.0f);
//    self.backgroundColor = UIColor.greenColor
//    _playPauseButton.backgroundColor = _nextButton.backgroundColor = _previousButton.backgroundColor = UIColor.redColor;
    
    _playPauseButton.tintColor = _previousButton.tintColor = _nextButton.tintColor = [UIColor blackColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackStateDidChange:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:nil];
    
    [self _cachePlayButtonImages];
    [self refreshPlayButtonImagePlaying:[self musicControllerIsPlaying:[NIFMusicManager playerController]]];
    [_nextButton setImage:[UIImage imageNamed:@"now-playing-fastforward"] forState:UIControlStateNormal];
    [_previousButton setImage:[UIImage imageNamed:@"now-playing-rewind"] forState:UIControlStateNormal];
    
    [self addSubview:_playPauseButton];
    [self addSubview:_nextButton];
    [self addSubview:_previousButton];
    [self setupConstraints];
    [self setupActions];
}

/**
 *  Sets up the actions and selectors that are called when interacting with buttons.
 */
- (void)setupActions{
    [_playPauseButton addTarget:self action:@selector(playbackControlsDidTapPlayPause) forControlEvents:UIControlEventTouchUpInside];
    [_previousButton addTarget:self action:@selector(playbackControlsDidTapPrevious) forControlEvents:UIControlEventTouchUpInside];
    [_nextButton addTarget:self action:@selector(playbackControlsDidTapNext) forControlEvents:UIControlEventTouchUpInside];
    
    //    [_previousButton addTarget:self action:@selector(didTouchDownPrevious) forControlEvents:UIControlEventTouchDown];
    //    [_nextButton addTarget:self action:@selector(didTouchDownNext) forControlEvents:UIControlEventTouchDown];
    //
    //    [_previousButton addTarget:self action:@selector(playbackControlsDidReleasePrevious) forControlEvents:UIControlEventTouchUpOutside];
    //    [_nextButton addTarget:self action:@selector(playbackControlsDidReleaseNext) forControlEvents:UIControlEventTouchUpOutside];
    
    _holdDuration = 1.0f;
    
    UILongPressGestureRecognizer *longPressPrevious = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchDownPrevious:)];
    [longPressPrevious setMinimumPressDuration:_holdDuration];
    [_previousButton addGestureRecognizer:longPressPrevious];
    
    UILongPressGestureRecognizer *longPressNext = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchDownNext:)];
    [longPressNext setMinimumPressDuration:_holdDuration];
    [_nextButton addGestureRecognizer:longPressNext];
}

/**
 *  Sets up the view constraints.
 */
- (void)setupConstraints{
    NSArray *constraints = [UIView autoCreateConstraintsWithoutInstalling:^{
        [_playPauseButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_playPauseButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [_nextButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_playPauseButton withOffset:19];
        [_nextButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_previousButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_playPauseButton withOffset:-19];
        [_previousButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_previousButton autoSetDimension:ALDimensionHeight toSize:25.0f];
        [_nextButton autoSetDimension:ALDimensionHeight toSize:25.0f];
        [_playPauseButton autoSetDimension:ALDimensionHeight toSize:27.0f];
        
        [_previousButton autoSetDimension:ALDimensionWidth toSize:68.5f];
        [_nextButton autoSetDimension:ALDimensionWidth toSize:68.5f];
        [_playPauseButton autoSetDimension:ALDimensionWidth toSize:68.5f];
    }];
    [self addConstraints:constraints];
}

/**
 *  Called when the user taps the play/pause button.
 */
- (void)playbackControlsDidTapPlayPause{
    BOOL isPlaying = [self musicControllerIsPlaying:[NIFMusicManager playerController]];
    if (isPlaying) {
        [[NIFMusicManager playerController] pause];
    }else{
        [[NIFMusicManager playerController] play];
    }
    if ([self.delegate respondsToSelector:@selector(playbackControlsDidTapPlayPause:)]) {
        [self.delegate playbackControlsDidTapPlayPause:self];
    }
}

/**
 *  Called when the user taps the next button.
 */
- (void)playbackControlsDidTapNext{
    [[NIFMusicManager playerController] skipToNextItem];
    if ([self.delegate respondsToSelector:@selector(playbackControlsDidTapNext:)]) {
        [self.delegate playbackControlsDidTapNext:self];
    }
}

/**
 *  Called when the user taps the previous button.
 */
- (void)playbackControlsDidTapPrevious{
    [[NIFMusicManager playerController] skipToPreviousItem];
    if ([self.delegate respondsToSelector:@selector(playbackControlsDidTapPrevious:)]) {
        [self.delegate playbackControlsDidTapPrevious:self];
    }
}

/**
 *  Called when the user holds the next button.
 */
- (void)playbackControlsDidHoldNext{
    if ([self.delegate respondsToSelector:@selector(playbackControlsDidHoldNext:)]) {
        [self.delegate playbackControlsDidHoldNext:self];
    }
}

/**
 *  Called when the user releases the next button.
 */
- (void)playbackControlsDidReleaseNext{
    if ([self.delegate respondsToSelector:@selector(playbackControlsDidReleaseNext:)]) {
        [self.delegate playbackControlsDidReleaseNext:self];
    }
}

/**
 *  Called when the user holds the previous button.
 */
- (void)playbackControlsDidHoldPrevious{
    if ([self.delegate respondsToSelector:@selector(playbackControlsDidHoldPrevious:)]) {
        [self.delegate playbackControlsDidHoldPrevious:self];
    }
}

/**
 *  Called when the user releases the previous button.
 */
- (void)playbackControlsDidReleasePrevious{
    if ([self.delegate respondsToSelector:@selector(playbackControlsDidReleasePrevious:)]) {
        [self.delegate playbackControlsDidReleasePrevious:self];
    }
}

/**
 *  Called when the user touches down the previous button. Stops seeking or starts it.
 */
- (void)didTouchDownPrevious:(UILongPressGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [[NIFMusicManager playerController] beginSeekingBackward];
    }else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [[NIFMusicManager playerController] endSeeking];
    }
}

/**
 *  Called when the user touches down the next button. Stops seeking or starts it.
 */
- (void)didTouchDownNext:(UILongPressGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [[NIFMusicManager playerController] beginSeekingForward];
    }else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [[NIFMusicManager playerController] endSeeking];
    }
}


@end
