//
//  NIFNowPlayingViewController.h
//  Stereo
//
//  Created by Terry Lewis on 29/08/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "NIFHighlightButton.h"
#import "NIFVolumeView.h"
#import "NIFSlantedTextPlaceholderArtworkView.h"

@interface NIFNowPlayingViewController : UIViewController

@property (nonatomic, strong) NIFSlantedTextPlaceholderArtworkView *_Nonnull artworkView;
@property (nonatomic, strong) NIFHighlightButton *_Nonnull repeatButton, *_Nonnull shuffleButton;

/**
 *  Returns a singleton of the Now Playing controller. This is required, especially due to the presence of the "Now Playing" button used throughout the application
 *
 *  @return shared instance of Now Playing controller
 */
+ (nonnull instancetype)sharedInstance;


/**
 *  Presents the shared instance from a view controller containing a navigation controller.
 *
 *  @param viewController the parent view controller.
 */
+ (void)presentSharedInstanceFromViewController:(nonnull UIViewController *)viewController;

/**
 *  Presents the shared instance from a view controller containing a navigation controller.
 *
 *  @param viewController the parent view controller.
 *  @param completion the completion block to be called upon the presentation animation completing.
 */
+ (void)presentSharedInstanceFromViewController:(nonnull UIViewController *)viewController completion:(nullable void (^)(void))completion;
#define sharedNowPlayingController [NIFNowPlayingViewController sharedInstance]

/**
 *  Processes and platy media item and sets the now playing details using the media item in question. A queue is also specified, allowing for skipping back and forth between items within the queue.
 *
 *  @param index     the index of the media item
 *  @param queue     the queue of MPMediaItems.
 */
- (void)processMediaItemAtIndex:(NSUInteger)index inQueue:(nonnull NSArray *)queue;

/**
 *  Processes and platy media item and sets the now playing details using the media item in question. A queue is also specified, allowing for skipping back and forth between items within the queue.
 *
 *  @param mediaItem the media item
 *  @param queue     the queue of MPMediaItems.
 */
- (void)processMediaItem:(nonnull MPMediaItem *)mediaItem inQueue:(nonnull NSArray *)queue;

/**
 *  The repeat mode of the controller.
 *
 *  @return current playback repeat mode.
 */
- (MPMusicRepeatMode)currentRepeatMode;

/**
 *  Issues a change to the repeat mode
 */
- (void)changeRepeatMode;

/**
 *  The shuffle mode of the controller.
 *
 *  @return current playback shuffle mode.
 */
- (MPMusicShuffleMode)currentShuffleMode;

/**
 *  Issues a change to the shuffle mode
 */
- (void)changeShuffleMode;

/**
 *  YES if the queue is a part of an album or compilation, otherwise, NO.
 */
@property (nonatomic) BOOL queueIsAlbumIndependent;

@end
