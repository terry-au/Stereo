//
//  NIFMusicPlayerController.m
//  Stereo
//
//  Created by Terry Lewis on 11/10/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import "NIFMusicPlayerController.h"
#import <AVFoundation/AVFoundation.h>
//#import "NIFPrivateMusicController.h"

@interface GVMusicPlayerController (Private)

@property (strong, nonatomic) AVPlayer *player;
@property (nonatomic, readwrite) NSUInteger indexOfNowPlayingItem;

@end

@interface NIFMusicPlayerController () <GVMusicPlayerControllerDelegate>{
//    NIFMusicPlayerControllerNotifier *_notificationHandler;
    NSTimer *_seekTimer;
    BOOL _shouldGeneratePlaybackNotifications;
    CGFloat _seekMultiplier;
}
@end

typedef enum{
    NIFMediaSeekModeReverse,
    NIFMediaSeekModeForward
} NIFMediaSeekMode;

@implementation NIFMusicPlayerController

/**
 *  Initialises a new instance of the NIFMusicPlayerController class.
 *
 *  @return the newly initialised instance.
 */
- (instancetype)init{
    if (self = [super init]) {
    //        _notificationHandler = [[NIFMusicPlayerControllerNotifier alloc] init];
        self.repeatMode = [NIFSharedSettingsManager repeatMode];
        self.shuffleMode = [NIFSharedSettingsManager shuffleMode];
//        NSLog(@"REPEAT MODE: %i", [NIFSharedSettingsManager repeatMode]);
//        [self setValue:@([NIFSharedSettingsManager repeatMode]) forKey:@"_repeatMode"];
        [self addDelegate:self];
        [self beginGeneratingPlaybackNotifications];
        _seekMultiplier = 1;
//        self.repeatMode = ;
    }
    return self;
}

- (void)setRepeatMode:(MPMusicRepeatMode)repeatMode{
    [super setRepeatMode:repeatMode];
    [NIFSharedSettingsManager setRepeatMode:repeatMode];
}

- (void)setShuffleMode:(MPMusicShuffleMode)shuffleMode{
    [super setShuffleMode:shuffleMode];
    [NIFSharedSettingsManager setShuffleMode:shuffleMode];
}

/**
 *  Returns a singleton of the NIFMusicPlayerController class.
 *
 *  @return A singleton of the NIFMusicPlayerController class.
 */
+ (instancetype)sharedInstance{
//    return [NIFPrivateMusicController sharedInstance];
    static NIFMusicPlayerController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NIFMusicPlayerController alloc] init];
        [sharedInstance registerForRemoteControlEvents];
    });
    return sharedInstance;
}

/**
 *  Sets up remote control and other common methods. This allows the player to be controlled using the headphones and control centre when the application is not focused. This also allows the now playing item and its artwork to be presented on the lockscreen.
 */
- (void)registerForRemoteControlEvents{
    MPRemoteCommandCenter *center = [MPRemoteCommandCenter sharedCommandCenter];
    
    [center.playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
        [self play];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [center.pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
        [self pause];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [center.togglePlayPauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
        [self togglePlayPause];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [center.nextTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
        [self skipToNextItem];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [center.previousTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
        [self skipToPreviousItem];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [center.seekBackwardCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
        if ([(MPSeekCommandEvent *)event type] == MPSeekCommandEventTypeBeginSeeking) {
            [self beginSeekingBackward];
        }else{
            [self endSeeking];
        }
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [center.seekForwardCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
        if ([(MPSeekCommandEvent *)event type] == MPSeekCommandEventTypeBeginSeeking) {
            [self beginSeekingForward];
        }else{
            [self endSeeking];
        }
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [center.seekBackwardCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
        [self beginSeekingBackward];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    [center.changePlaybackPositionCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        MPChangePlaybackPositionCommandEvent *castedEvent = (MPChangePlaybackPositionCommandEvent *)event;
        NSLog(@"Position: %f", castedEvent.positionTime);
        [self setCurrentPlaybackTime:castedEvent.positionTime];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
//    [center.changePlaybackPositionCommand addTarget:self action:@selector(remoteChangePlaybackPosition:)];
    
    [center.changePlaybackRateCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
       return MPRemoteCommandHandlerStatusSuccess;
    }];
}

- (MPRemoteCommandHandlerStatus)remoteChangePlaybackPosition:(MPChangePlaybackPositionCommandEvent *)event{
    MPChangePlaybackPositionCommandEvent *castedEvent = event;
    NSLog(@"Position: %f", castedEvent.positionTime);
    [self setCurrentPlaybackTime:castedEvent.positionTime];
    return MPRemoteCommandHandlerStatusSuccess;
}

/**
 *  Pauses if playing. Plays if paused. Simple?
 */
- (void)togglePlayPause{
    if (self.playbackState == MPMusicPlaybackStatePlaying) {
        [self pause];
    }else{
        [self play];
    }
}

/**
 *  Compatibility method. Notifies when the playback state.
 *
 *  @param musicPlayer           the music player that changed playback state.
 *  @param playbackState         the new playback state.
 *  @param previousPlaybackState the previous playback state.
 */
- (void)musicPlayer:(GVMusicPlayerController *)musicPlayer playbackStateChanged:(MPMusicPlaybackState)playbackState previousPlaybackState:(MPMusicPlaybackState)previousPlaybackState{
    if (_shouldGeneratePlaybackNotifications) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:self];
    }
}

/**
 *  Compatibility method. Notifies when track changes.
 *
 *  @param musicPlayer    the music player that changed the track.
 *  @param nowPlayingItem the new now playing item.
 *  @param previousTrack  the previously playing item.
 */
- (void)musicPlayer:(GVMusicPlayerController *)musicPlayer trackDidChange:(MPMediaItem *)nowPlayingItem previousTrack:(MPMediaItem *)previousTrack{
    if (_shouldGeneratePlaybackNotifications) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:nil];
    }
}
/**
 *  Compatibility method. Notifies when volume changes.
 *
 *  @param musicPlayer the music player that changed the volume.
 *  @param volume      the new volume level.
 */
- (void)musicPlayer:(GVMusicPlayerController *)musicPlayer volumeChanged:(float)volume{
    if (_shouldGeneratePlaybackNotifications) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MPMusicPlayerControllerVolumeDidChangeNotification object:nil];
    }
}


/**
 *  Begins the generation of playback notifications.
 *  Mostly for a compatibility layer between MPMusicPlayerController
 */
- (void)beginGeneratingPlaybackNotifications{
    _shouldGeneratePlaybackNotifications = YES;
}

/**
 *  Stops the generation of playback notifications.
 *  Mostly for a compatibility layer between MPMusicPlayerController
 */
- (void)endGeneratingPlaybackNotifications{
    _shouldGeneratePlaybackNotifications = NO;
}

/**
 *  Skips to the previous item, override of the original method. This allows skipping back on the current playing song to restart the song if more than 4.0f seconds have played.
 */
- (void)skipToPreviousItem{
    [self endSeeking];
    if (self.nowPlayingItem) {
        if (self.currentPlaybackTime < 4.0f){
            [super skipToPreviousItem];
        }else{
            [self skipToBeginning];
        }
    }
}

/**
 *  Constructs a seek timer for either backwards or forwards seeking.
 *
 *  @param seekMode the seek timer direction.
 */
- (void)_constructSeekTimerForSeekMode:(NIFMediaSeekMode)seekMode{
    /**
     * I hate timers.
     */
    switch (seekMode) {
        case NIFMediaSeekModeReverse:
            [self _seekBackward];
            _seekTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(_seekBackward) userInfo:nil repeats:YES];
            break;
        case NIFMediaSeekModeForward:
            [self _seekForward];
            _seekTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(_seekForward) userInfo:nil repeats:YES];
            break;
    }
}

/**
 *  Calculates the speed multiplier, which is the previous seek multiplier multiplied by two.
 *
 *  @return the calculated seek multiplier.
 */
- (CGFloat)_calculatedSeekMultiplier{
    // we do not want to go crazy, 16x speed is /more/ than enough.
    _seekMultiplier = fmin(_seekMultiplier * 2, 16.0f);
    return  _seekMultiplier;
}

/**
 *  Sets the playback rate to -1 times the seek speed multiplier.
 */
- (void)_seekBackward{
    [self.player setRate:-1.0f * [self _calculatedSeekMultiplier]];
}

/**
 *  Sets the playback speed to 1 times the seek speed multiplier.
 */
- (void)_seekForward{
    [self.player setRate:1.0f * [self _calculatedSeekMultiplier]];
}

/**
 *  Sets the playback rate to 1.0f.
 */
- (void)_endSeeking{
    if (self.playbackState == MPMusicPlaybackStatePlaying || self.player.rate > 1.0f || self.player.rate < 0.0f) {
        [self.player setRate:1.0f];
    }
}

/**
 *  Called to stop the seek timer, which increases the seek rate, as the seek function is executing.
 */
- (void)_destroySeekTimer{
    [_seekTimer invalidate];
    _seekTimer = nil;
    _seekMultiplier = 1;
}

/**
 *  It's important to ensure that the seek timer is destroyed.
 */
- (void)play{
    [super play];
    [self endSeeking];
}

/**
 *  It's important to ensure that the seek timer is destroyed.
 */
- (void)pause{
    [super pause];
    [self endSeeking];
}

/**
 *  It's important to ensure that the seek timer is destroyed.
 */
- (void)skipToBeginning{
    [super skipToBeginning];
    [self endSeeking];
}

/**
 *  It's important to ensure that the seek timer is destroyed.
 */
- (void)skipToNextItem{
    [super skipToNextItem];
    [self endSeeking];
}

/**
 *  Begin seeking backwards.
 */
- (void)beginSeekingBackward {
    [self _constructSeekTimerForSeekMode:NIFMediaSeekModeReverse];
}

/**
 *  Begin seeking forward.
 */
- (void)beginSeekingForward {
    [self _constructSeekTimerForSeekMode:NIFMediaSeekModeForward];
}

/**
 *  Stop seeking the current track.
 */
- (void)endSeeking {
    [self _destroySeekTimer];
    [self _endSeeking];
}

/**
 *  New method to allow backwards compatibility with MPMusicPlayerController
 *
 *  @param mediaItem the media item to play
 */
- (void)setNowPlayingItem:(MPMediaItem *)mediaItem{
    [self playItem:mediaItem];
}

/**
 *  Sets the index of the now playing item in the current playback queue. Updates the now playing indicator to the cell representing the now playing item.
 *
 *  @param indexOfNowPlayingItem the index of the now playing item in the queue.
 */
- (void)setIndexOfNowPlayingItem:(NSUInteger)indexOfNowPlayingItem{
    [super setIndexOfNowPlayingItem:indexOfNowPlayingItem];
    [_activeSongViewController.tableView reloadData];
}

/**
 *  Sets the playback state and updates the now playing indicator.
 *
 *  @param playbackState the playback state to be set to.
 */
- (void)setPlaybackState:(MPMusicPlaybackState)playbackState{
    [super setPlaybackState:playbackState];
    [[_activeSongViewController activeIndicatorView] setPlaybackState:playbackState];
}

/**
 *  Although unused, it can be important to know if we are seeking.
 */
- (BOOL)isSeeking{
    return _seekTimer != nil && _seekMultiplier != 1;
}

@end
