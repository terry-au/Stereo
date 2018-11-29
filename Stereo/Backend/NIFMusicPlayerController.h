//
//  NIFMusicPlayerController.h
//  Stereo
//
//  Created by Terry Lewis on 11/10/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import "GVMusicPlayerController.h"
#import "NIFNowPlayingIndicatorView.h"
#import "NIFSongViewController.h"

@interface NIFMusicPlayerController : GVMusicPlayerController

+ (instancetype)sharedInstance;

/**
 *  Begins the generation of playback notifications.
 *  Mostly for a compatibility layer between MPMusicPlayerController
 */
- (void)beginGeneratingPlaybackNotifications;

/**
 *  Stops the generation of playback notifications.
 *  Mostly for a compatibility layer between MPMusicPlayerController
 */
- (void)endGeneratingPlaybackNotifications;

/**
 *  New method to allow backwards compatibility with MPMusicPlayerController
 *
 *  @param mediaItem the media item to play
 */
- (void)setNowPlayingItem:(MPMediaItem *)mediaItem;

/**
 *  Sets up remote control and other common methods. This allows the player to be controlled using the headphones and control centre when the application is not focused. This also allows the now playing item and its artwork to be presented on the lockscreen.
 */
- (void)registerForRemoteControlEvents;

//@property (nonatomic, strong) NIFNowPlayingIndicatorView *indicatorView;
/**
 *  The active song controller. This controller containins the now playing indicator and requires upates when the playback state changes or the song changes.a
 */
@property (nonatomic, weak) NIFSongViewController *activeSongViewController;
@property (nonatomic, readonly) BOOL isSeeking;

@end
