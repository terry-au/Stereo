//
//  NIFAlbumViewController.m
//  Stereo
//
//  Created by Terry Lewis on 13/08/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import "NIFAlbumViewController.h"
#import "NIFSongViewController.h"
#import "NIFImageAlbumCell.h"

@interface NIFAlbumViewController (){
}

@end

@implementation NIFAlbumViewController

- (instancetype)init{
    if (self = [super init]) {
        _artistPersistentID = nil;
    }
    return self;
}

- (instancetype)initWithFullAlbums:(BOOL)fullAlbums{
    if (self = [self init]) {
        _showingAlbumArtist = YES;
    }
    return self;
}

/**
 *  the name of the tab bar icon image
 *
 *  @return the name of the tab bar icon image
 */
- (NSString *)tabBarIconName{
    return @"Albums";
}

/**
 *  the title of the tab bar item
 *
 *  @return the title of the tab bar item
 */
- (NSString *)tabBarTitle{
    return NIFLocStr(@"ALBUMS");
}

/**
 *  the type of controller, used for sorting
 *
 *  @return the type of controller, used for sorting
 */
- (NIFControllerType)controllerType{
    return NIFControllerTypeAlbums;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  Allows for customising the data source.
 *
 *  @return The name of the selector that returns an array of data pertaining to the view controller.
 */
- (SEL)dataSelector{
    return @selector(albums);
}

/**
 *  Allows for customising the sort property or returning function. Sorts are completed alphabetically, this allows customisation of the property in which the sort function bases its comparison off of.
 *
 *  @return The name of the selector used to sort the media items.
 */
- (SEL)sortFieldName{
    return @selector(albumSafety);
}

/**
 *  Allows defining a cell class. This class is used as the class for all cells within the table view.
 *
 *  @return The cell class to be used in the table view
 */
- (Class)cellClass{
    return [NIFImageAlbumCell class];
}

/**
 *  Configures a given cell using the MPMediaItem provided.
 *
 *  @param cell      the cell
 *  @param mediaItem the media item pertaining to the index of the cell
 */
- (void)configureCell:(NIFImageAlbumCell *)cell withMediaItem:(MPMediaItem *)mediaItem{
//    cell.imageView.backgroundColor = [UIColor greenColor];
    if (mediaItem.artwork) {
        cell.imageView.image = [mediaItem.artwork imageWithSize:CGSizeMake(56.0f, 56.0f)];
    }else{
        cell.imageView.image = [UIImage imageNamed:@"AlbumPlaceholder.png"];
    }
    cell.textLabel.text = mediaItem.albumSafety;
    cell.detailTextLabel.text = _showingAlbumArtist ? mediaItem.albumArtistSafety : mediaItem.artistSafety;
}

/**
 *  Action to be performed when the cell at the index path has been selected
 *
 *  @param tableView the table view containing the cell
 *  @param indexPath the indexpath of the cell
 */
- (void)selectedCellPertainingToMediaItem:(MPMediaItem *)mediaItem{
    
    NSArray *albums = nil;
    if (_showingAlbumArtist) {
        albums = [sharedMusicManager songsForAlbum:[mediaItem valueForProperty:MPMediaItemPropertyAlbumPersistentID]];
    }else{
        albums = [sharedMusicManager songsForArtist:[mediaItem valueForProperty:MPMediaItemPropertyArtistPersistentID] inAlbum:[mediaItem valueForProperty:MPMediaItemPropertyAlbumPersistentID]];
    }
    
    NIFSongViewController *albumController = [[NIFSongViewController alloc] initWithPlaybackGroup:_artistPersistentID ? NIFMediaPlaybackGroupAlbumInArtist : NIFMediaPlaybackGroupAlbum sortingEnabled:NO];
    [albumController setExternalDataSource:albums];
    [albumController setTitle:[mediaItem albumTitle]];
    
    [self.navigationController pushViewController:albumController animated:YES];
}

- (void)showAllSongsForArtist{
    NSArray *songs;
    if (_showingAlbumArtist) {
        songs = [sharedMusicManager songsForAlbumArtist:_artistPersistentID];
    }else{
        songs = [sharedMusicManager songsForAlbumArtist:_artistPersistentID];
    }
    
    NIFSongViewController *albumController = [[NIFSongViewController alloc] initWithPlaybackGroup:NIFMediaPlaybackGroupArtist sortingEnabled:NO];
    [albumController setExternalDataSource:songs];
//    [albumController setTitle:[mediaItem albumTitle]];
    [self.navigationController pushViewController:albumController animated:YES];
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
    return 64.0f;
}

@end
