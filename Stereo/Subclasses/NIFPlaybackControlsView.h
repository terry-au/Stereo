//
//  NIFPlaybackControlsView.h
//  Stereo
//
//  Created by Terry Lewis on 4/09/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIFExtendedButton.h"

@class NIFPlaybackControlsView;

@protocol NIFPlaybackControlsViewDelegate <NSObject>

@optional

/**
 *  Called when the user taps the play/pause button.
 *
 *  @param playnackControlsView the playback controls view in which the event occurred on.
 */
- (void)playbackControlsDidTapPlayPause:(NIFPlaybackControlsView *)playnackControlsView;

/**
 *  Called when the user taps the previous button.
 *
 *  @param playnackControlsView the playback controls view in which the event occurred on.
 */
- (void)playbackControlsDidTapPrevious:(NIFPlaybackControlsView *)playnackControlsView;

/**
 *  Called when the user taps the next button.
 *
 *  @param playnackControlsView the playback controls view in which the event occurred on.
 */
- (void)playbackControlsDidTapNext:(NIFPlaybackControlsView *)playnackControlsView;

/**
 *  Called when the user holds the previous button.
 *
 *  @param playnackControlsView the playback controls view in which the event occurred on.
 */
- (void)playbackControlsDidHoldPrevious:(NIFPlaybackControlsView *)playnackControlsView;

/**
 *  Called when the user holds the next button.
 *
 *  @param playnackControlsView the playback controls view in which the event occurred on.
 */
- (void)playbackControlsDidHoldNext:(NIFPlaybackControlsView *)playnackControlsView;

/**
 *  Called when the user releases the previous button.
 *
 *  @param playnackControlsView the playback controls view in which the event occurred on.
 */
- (void)playbackControlsDidReleasePrevious:(NIFPlaybackControlsView *)playnackControlsView;

/**
 *  Called when the user releases the next button.
 *
 *  @param playnackControlsView the playback controls view in which the event occurred on.
 */
- (void)playbackControlsDidReleaseNext:(NIFPlaybackControlsView *)playnackControlsView;

@end

@interface NIFPlaybackControlsView : UIView{
    
    
}

/**
 *  The playback control buttons.
 */
@property (nonatomic, retain) NIFExtendedButton *playPauseButton, *nextButton, *previousButton;

/**
 *  The delegate method, used to forward events.
 */
@property (nonatomic, assign) id<NIFPlaybackControlsViewDelegate> delegate;
//@property (nonatomic, retain) 

@end
