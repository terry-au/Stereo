//
//  NIFSongViewController.m
//  Stereo
//
//  Created by Terry Lewis on 13/08/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import "NIFSongViewController.h"
#import "NIFSongCell.h"
#import "NIFNowPlayingViewController.h"
#import "NIFImageSongCell.h"
#import "NIFNowPlayingDeepState.h"
#import "NIFSharedMethods.h"

@interface NIFSongViewController (){
    NIFMediaPlaybackGroup _playbackGroup;
    BOOL _updatePlayingIndicator;
    BOOL _showsMetaButton;
}

@end

@implementation NIFSongViewController

- (instancetype)init{
    if (self = [super init]) {
        _updatePlayingIndicator = YES;
    }
    return self;
}

- (NSString *)metaCellText{
    return @"Shuffle";
}

/**
 *  Whether the table will show -all- songs in library
 *
 *  @param allSongs whether all songs should be shown
 *
 *  @return the view controller
 */
- (instancetype)initWithAllSongs:(BOOL)allSongs{
    if (self = [self initWithSortingEnabled:YES]) {
        _showingAllMusic = allSongs;
        _playbackGroup = NIFMediaPlaybackGroupSong;
        _playlistIdentifier = NSNotFound;
//        _showsMetaButton = NO;
    }
    return self;
}

- (instancetype)initWithPlaybackGroup:(NIFMediaPlaybackGroup)playbackGroup sortingEnabled:(BOOL)sortingEnabled{
    if (self = [super initWithSortingEnabled:sortingEnabled]) {
        _playbackGroup = playbackGroup;
        if (_playbackGroup != NIFMediaPlaybackGroupPlaylist) {
            _playlistIdentifier = NSNotFound;
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)setPlaylistIdentifier:(MPMediaEntityPersistentID)playlistIdentifier{
    _playlistIdentifier = playlistIdentifier;
    if (_playlistIdentifier != NSNotFound) {
        _playbackGroup = NIFMediaPlaybackGroupPlaylist;
    }
}

/**
 *  the name of the tab bar icon image
 *
 *  @return the name of the tab bar icon image
 */
- (NSString *)tabBarIconName{
    return @"Songs";
}

/**
 *  the title of the tab bar item
 *
 *  @return the title of the tab bar item
 */
- (NSString *)tabBarTitle{
    return NIFLocStr(@"SONGS");
}

- (BOOL)useGraphicalCells{
    return _showingAllMusic || _sourceIsAlbumIndepentent;
}

/**
 *  the type of controller, used for sorting
 *
 *  @return the type of controller, used for sorting
 */
- (NIFControllerType)controllerType{
    return NIFControllerTypeSongs;
}

/**
 *  Allows defining a cell class. This class is used as the class for all cells within the table view.
 *
 *  @return The cell class to be used in the table view
 */
- (Class)cellClass{
    return [self useGraphicalCells] ? [NIFImageSongCell class] : [NIFSongCell class];
}

- (BOOL)indexIsValidForNowPlayingIdentifier:(NSUInteger)index{
    if (_playbackGroup == NIFMediaPlaybackGroupPlaylist) {
        if (index != [[NIFMusicPlayerController sharedInstance] indexOfNowPlayingItem]) {
            return NO;
        }
//        NSLog(@"The Index: %lu/%lu", index, [[NIFMusicPlayerController sharedInstance] indexOfNowPlayingItem]);
    }
    return YES;
}

/**
 *  Configures a given cell using the MPMediaItem provided.
 *
 *  @param cell      the cell
 *  @param mediaItem the media item pertaining to the index of the cell
 */
- (void)configureCell:(UITableViewCell *)cell withMediaItem:(MPMediaItem *)mediaItem indexPath:(NSIndexPath *)indexPath{
    if ([self useGraphicalCells]) {
        NIFImageSongCell *graphicalCell = (NIFImageSongCell *)cell;
        graphicalCell.textLabel.text = mediaItem.title;
        graphicalCell.detailTextLabel.attributedText = [NIFSharedMethods attributedStringForArtist:mediaItem.artistSafety album:mediaItem.albumSafety];
        if ([mediaItem artwork]) {
            graphicalCell.artworkImageView.image = [[mediaItem artwork] imageWithSize:CGSizeMake(50, 50)];
        }else{
            graphicalCell.artworkImageView.image = [UIImage imageNamed:@"SongPlaceholder.png"];
        }
        if ([self indexIsValidForNowPlayingIdentifier:indexPath.row]) {
            BOOL isNowPlayingItem = [[NIFNowPlayingDeepState sharedInstance] identifierMatches:[mediaItem persistentID] inGroup:_playbackGroup inPlaylist:_playlistIdentifier];
            graphicalCell.playing = isNowPlayingItem;
        }
    }else{
        NIFSongCell *simpleCell = (NIFSongCell *)cell;
        simpleCell.titleLabel.text = mediaItem.title;
        simpleCell.trackNumberLabel.text = [NIFSharedMethods stringFromTrackNumber:mediaItem.albumTrackNumber];
        simpleCell.durationLabel.text = stringFromTimeInterval(mediaItem.playbackDuration);
        if ([self indexIsValidForNowPlayingIdentifier:indexPath.row]) {
            BOOL isNowPlayingItem = [[NIFNowPlayingDeepState sharedInstance] identifierMatches:[mediaItem persistentID] inGroup:_playbackGroup inPlaylist:_playlistIdentifier];
            simpleCell.playing = isNowPlayingItem;
        }
    }
}

/**
 *  Action to be performed when the cell at the index path has been selected
 *
 *  @param tableView the table view containing the cell
 *  @param indexPath the indexpath of the cell
 */
- (void)selectedCellPertainingToMediaItem:(MPMediaItem *)mediaItem index:(NSUInteger)index{
//    NSLog(@"%li", index);
    [NIFNowPlayingViewController presentSharedInstanceFromViewController:self completion:nil];
    sharedNowPlayingController.queueIsAlbumIndependent = _sourceIsAlbumIndepentent;
    [sharedNowPlayingController processMediaItemAtIndex:index inQueue:[self allMediaItems]];
}

/**
 *  Returns the now playing cell's indexPath if no cell is related to the now playing item, a null value is returns.
 *
 *  @return the now playing indexPath or a null value.
 */
- (nullable NSIndexPath *)updateNowPlayingCell{
    __block NSIndexPath *playingIndexPath = nil;
    [self iterateCellsWithBlock:^(MPMediaItem *mediaItem, NSIndexPath *indexPath) {
        BOOL isNowPlayingItem = [[NIFNowPlayingDeepState sharedInstance] identifierMatches:[mediaItem persistentID] inGroup:_playbackGroup inPlaylist:_playlistIdentifier];
        if (isNowPlayingItem) {
            playingIndexPath = indexPath;
            return;
        }
    }];
    return playingIndexPath;
}

/**
 *  The active indicator view for the currently playing or paused song.
 *
 *  @return the active indicator view.
 */
- (NIFNowPlayingIndicatorView *)activeIndicatorView{
    _updatePlayingIndicator = NO;
    NIFSongCell *cell = [self.tableView cellForRowAtIndexPath:[self updateNowPlayingCell]];
    _updatePlayingIndicator = YES;
    return [cell nowPlayingIndicator];
}

/**
 *  Customises the height of the cell.
 *
 *  @param tableView the table view containing the cell
 *  @param indexPath the indexpath of the cell
 *
 *  @return the height of the cell.
 */
- (CGFloat)heightForStandardCell{
    return [self useGraphicalCells] ? 58.0f : [super heightForStandardCell];
}

/**
 *  The playback group that the controller represents.
 *
 *  @return the playback group that the controller represents.
 */
- (NIFMediaPlaybackGroup)playbackGroup{
    return _playbackGroup;
}

@end
