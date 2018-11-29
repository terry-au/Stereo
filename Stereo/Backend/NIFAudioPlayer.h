//
//  NIFAudioPlayer.h
//  Stereo
//
//  Created by Terry Lewis on 7/09/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

//@interface NIFAudioPlayer : NSObject{
//    MPMusicPlayerController *dummy;
//}
//
//// Plays items from the current queue, resuming paused playback if possible.
//- (void)play;
//
//// Pauses playback if playing.
//- (void)pause;
//
//// Ends playback. Calling -play again will start from the beginnning of the queue.
//- (void)stop;
//
//// The current playback time of the now playing item in seconds.
//@property(nonatomic) NSTimeInterval currentPlaybackTime;
//
//// The current playback rate of the now playing item. Default is 1.0 (normal speed).
//// Pausing will set the rate to 0.0. Setting the rate to non-zero implies playing.
//@property(nonatomic) float currentPlaybackRate;
//
//// The seeking rate will increase the longer scanning is active.
//- (void)beginSeekingForward;
//- (void)beginSeekingBackward;
//- (void)endSeeking;
//
//// See MPMediaPlayback.h for basic playback control.
//
//// Returns the current playback state of the music player
//@property (nonatomic, readonly) MPMusicPlaybackState playbackState;
//
//// Determines how music repeats after playback completes. Defaults to MPMusicRepeatModeDefault.
//@property (nonatomic) MPMusicRepeatMode repeatMode;
//
//// Determines how music is shuffled when playing. Defaults to MPMusicShuffleModeDefault.
//@property (nonatomic) MPMusicShuffleMode shuffleMode;
//
//// Returns the currently playing media item, or nil if none is playing.
//// Setting the nowPlayingItem to an item in the current queue will begin playback at that item.
//@property (nonatomic, copy) MPMediaItem *nowPlayingItem;
//
//// Returns the index of the now playing item in the current playback queue.
//// May return NSNotFound if the index is not valid (e.g. an empty queue or an infinite playlist).
//@property (nonatomic, readonly) NSUInteger indexOfNowPlayingItem NS_AVAILABLE_IOS(5_0);
//
//- (void)skipToNextItem;
//
//- (void)skipToBeginning;
//
//- (void)skipToPreviousItem;
//
//- (void)beginGeneratingPlaybackNotifications;
//- (void)endGeneratingPlaybackNotifications;
//
//// Posted when the playback state changes, either programatically or by the user.
//extern NSString * const NIFMusicPlayerControllerPlaybackStateDidChangeNotification;
//
//// Posted when the currently playing media item changes.
//extern NSString * const NIFMusicPlayerControllerNowPlayingItemDidChangeNotification;
//
//// Posted when the current volume changes.
//extern NSString * const NIFMusicPlayerControllerVolumeDidChangeNotification;
//
//@end
