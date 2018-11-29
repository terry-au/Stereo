//
//  NIFDetailSlider.m
//  Stereo
//
//  Created by Terry Lewis on 5/09/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import "NIFDetailSlider.h"
#import "NIFDetailScrubber.h"
#import "UIFont+MonospaceCompat.h"

@interface NIFDetailSlider () <NIFDetailScrubberDelegate>

@end

@implementation NIFDetailSlider{
    NIFDetailScrubber *_slider;
    UILabel *_currentTimeLabel, *_currentTimeInverseLabel;
    CGFloat _minTimeLabelWidth;
    NSTimer *_playbackTimer;
    BOOL _updateSlider;
}

/**
 *  Sets up the detail slider and registers for playback state changing notifications.
 *
 *  @param frame the frame in which the view should encompass.
 *
 *  @return the slider, configured.
 */
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _minTimeLabelWidth = 41;
        [self setupViews];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackStateDidChange:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nowPlayingItemDidChangeNotification:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:nil];
    }
    return self;
}

/**
 *  Unregisters from all noitifications.
 */
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//- (void)updateScrubbingSpeeds{
//    _slider.scrubbingSpeeds = @{@(0.0f) : @(1.0f),
//                                @(50.0f) : @(0.5f),
//                                @(100.0f) : @(0.25f),
//                                @(150.0f) : @(1.0f/_slider.maximumValue)};
//}

/**
 *  Sets up the views with all the default details and settings.
 */
- (void)setupViews{
    _updateSlider = YES;
    _slider = [NIFDetailScrubber newAutoLayoutView];
    _slider.delegate = self;
    _slider.scrubbingSpeeds = @{@(0.0f) : @(1.0f),
                                @(50.0f) : @(0.5f),
                                @(100.0f) : @(0.25f),
                                @(150.0f) : @(0.1f)};
    [_slider addTarget:self action:@selector(setCurrentTime:) forControlEvents:UIControlEventValueChanged];
    _currentTimeLabel = [UILabel newAutoLayoutView];
    _currentTimeInverseLabel = [UILabel newAutoLayoutView];
    UIImage *sliderThumb = [[UIImage imageNamed:@"Scrubber.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_slider setThumbImage:sliderThumb forState:UIControlStateNormal];
    
    UIImage *trackImage = [[UIImage imageNamed:@"NowPlayingProgress.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [_slider setMinimumTrackImage:trackImage forState:UIControlStateNormal];
    [_slider setMaximumTrackImage:trackImage forState:UIControlStateNormal];
    
//    UIFont *labelFont = [UIFont fontWithName:@"Menlo" size:10.0f];
    UIFont *labelFont = [[UIFont systemFontOfSize:10.0f] monospaceFontVariant];
    
//    oh wow, this just amazing!!!
//    UIFont *labelFont = [UIFont monospacedDigitSystemFontOfSize:10.0f weight:UIFontWeightRegular];
    _currentTimeLabel.text = _currentTimeInverseLabel.text = @"0:00";
    _currentTimeLabel.textAlignment = NSTextAlignmentRight;
    _currentTimeLabel.font = labelFont;
    _currentTimeInverseLabel.font = labelFont;
    _currentTimeInverseLabel.textAlignment = NSTextAlignmentLeft;
    [self _setupTimer];
    
    [self addSubview:_slider];
    [self addSubview:_currentTimeLabel];
    [self addSubview:_currentTimeInverseLabel];
    
    [self setupConstraints];
}

/**
 *  Sets up the current time update timer.
 */
- (void)_setupTimer{
    if (!_playbackTimer) {
        _playbackTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateNowPlayingTime) userInfo:nil repeats:YES];
    }
}

/**
 *  Stops the current time update timer.
 */
- (void)_destroyTimer{
    [_playbackTimer invalidate];
    _playbackTimer = nil;
}

/**
 *  Called when playback state changes, used to stop the update timer.
 *
 *  @param aNotification the notification containing the media controller as its object property.
 */
- (void)playbackStateDidChange:(NSNotification *)aNotification{
    MPMusicPlayerController *player = aNotification.object;
    if (player.playbackState == MPMoviePlaybackStatePlaying) {
        [self _setupTimer];
    }else{
        [self _destroyTimer];
    }
}

- (void)nowPlayingItemDidChangeNotification:(NSNotification *)aNotification{
//    [self updateScrubbingSpeeds];
}

/**
 *  Updates the labels and slider value to reflect the current playing item's current playback time.
 */
- (void)updateNowPlayingTime{
    float currentTime;
//    NSLog(@"%i", (int)[NIFMusicManager playerController].playbackState);
    if ([NIFMusicManager playerController].playbackState == MPMoviePlaybackStateStopped) {
        return;
    }
    if (_updateSlider) {
        currentTime = [NIFMusicManager playerController].currentPlaybackTime;
        _slider.value = currentTime;
    }else{
        currentTime = _slider.value;
    }
    NSNumber *duration = [[NIFMusicManager playerController].nowPlayingItem valueForProperty:MPMediaItemPropertyPlaybackDuration];
    float totalTime = [duration floatValue];
    NSString *currentTimeString = stringFromTimeInterval((unsigned long long)currentTime);
    NSString *inverseCurrentTimeString = stringFromTimeInterval((unsigned long long)(totalTime - currentTime));
    _currentTimeLabel.text = currentTimeString;
    _currentTimeInverseLabel.text = inverseCurrentTimeString;
}

/**
 *  Updates the slider's min and max to applicable values for the currently playing media item.
 *
 *  @param mediaItem <#mediaItem description#>
 */
- (void)updateScaleWithMediaItem:(MPMediaItem *)mediaItem{
    NSNumber *duration = [mediaItem valueForProperty:MPMediaItemPropertyPlaybackDuration];
    float totalTime = [duration floatValue];
    _slider.maximumValue = totalTime;
    _slider.value = [NIFMusicManager playerController].currentPlaybackTime;
}

/**
 *  Sets the currently playing media item to a time derived from the slider's value.
 *
 *  @param slider the slider/scrubber
 */
- (void)setCurrentTime:(NIFDetailScrubber *)slider{
    [[NIFMusicManager playerController] setCurrentPlaybackTime: [slider value]];
    _updateSlider = NO;
    [self updateNowPlayingTime];
    _updateSlider = YES;
}

/**
 *  Sets up the constraints for the views within this view.
 */
- (void)setupConstraints{
    NSArray *constraints = [UIView autoCreateConstraintsWithoutInstalling:^{
        [_currentTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:-2];
        [_currentTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:7];
        [_currentTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:7];
        [_currentTimeLabel autoSetDimension:ALDimensionWidth toSize:_minTimeLabelWidth relation:NSLayoutRelationGreaterThanOrEqual];
        
        [_currentTimeInverseLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:-2];
        [_currentTimeInverseLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:7];
        [_currentTimeInverseLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:7];
        [_currentTimeInverseLabel autoSetDimension:ALDimensionWidth toSize:_minTimeLabelWidth relation:NSLayoutRelationGreaterThanOrEqual];
        
        [_slider autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_currentTimeLabel withOffset:9];
        [_slider autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_currentTimeInverseLabel withOffset:-9];
        [_slider autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self];
    }];
    [self addConstraints:constraints];
}

#pragma JGDetailScrubberDelegate

/**
 *  Called when scrubber changes scrubbing speed. Used to adjust scrubber title and detail labels.
 *
 *  @param slider the slider/scrubber
 *  @param speed  the new speed
 */
- (void)scrubber:(JGDetailScrubber *)slider didChangeToScrubbingSpeed:(CGFloat)speed{
    [self _destroyTimer];
    NSString *text;
    if (speed == 1.0f) {
        text = NIFLocStr(@"HI_SPEED_SCRUBBING");
    }else if (speed == 0.50f){
        text = NIFLocStr(@"HALF_SPEED_SCRUBBING");
    }else if (speed == 0.25f){
        text = NIFLocStr(@"QUARTER_SPEED_SCRUBBING");
    }else if (speed == 0.1f){
        text = NIFLocStr(@"FINE_SCRUBBING");
    }
    [_nowPlayingTitlesView setAuxilaryText:text detail:NIFLocStr(@"SCRUBBING_DETAIL")];
}

/**
 *  Called when scrubber finishes scrubbing. Returns titles to information reflecting the now playing information.
 *
 *  @param slider the slider/scrubber.
 */
- (void)scrubberDidFinishScrubbing:(JGDetailScrubber *)slider{
//    NSLog(@"Finished scrubbing.");
    [_nowPlayingTitlesView hideAuxilaryText];
    [self _setupTimer];
}

@end
