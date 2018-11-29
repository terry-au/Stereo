//
//  NIFSongViewController.h
//  Stereo
//
//  Created by Terry Lewis on 13/08/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import "NIFMediaTableViewController.h"
#import "NIFConstants.h"

@interface NIFSongViewController : NIFMediaTableViewController

/**
 *  Whether the table will show -all- songs in library
 *
 *  @param allSongs whether all songs should be shown
 *
 *  @return the view controller
 */
- (instancetype)initWithAllSongs:(BOOL)allSongs;

- (instancetype)initWithPlaybackGroup:(NIFMediaPlaybackGroup)playbackGroup sortingEnabled:(BOOL)sortingEnabled;

/**
 *  Whether the view controller shows all songs.
 */
@property (nonatomic) BOOL showingAllMusic;

/**
 *  Whether the songs are displayed independent of album. If yes, the cells display the album artwork and contain the album name. If no, the albums show the track number, title and duration.
 */
@property (nonatomic) BOOL sourceIsAlbumIndepentent;

@property (nonatomic) MPMediaEntityPersistentID playlistIdentifier;
@property (nonatomic, strong) NSIndexPath *indexPathOfNowPlayingSong;
//@property (nonatomic) BOOL sourceIsPlaylist;

/**
 *  The playback group that the controller represents.
 *
 *  @return the playback group that the controller represents.
 */
- (NIFMediaPlaybackGroup)playbackGroup;

/**
 *  The active indicator view for the currently playing or paused song.
 *
 *  @return the active indicator view.
 */
- (NIFNowPlayingIndicatorView *)activeIndicatorView;

@end
