//
//  NIFArtistViewController.m
//  Stereo
//
//  Created by Terry Lewis on 13/08/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import "NIFArtistViewController.h"
#import "NIFAlbumViewController.h"
#import "NIFImageArtistCell.h"

@interface NIFArtistViewController (){
    BOOL _showAlbumArtist;
}

@end

@implementation NIFArtistViewController

- (instancetype)init{
    if (self = [super init]) {
        _showAlbumArtist = [NIFSharedSettingsManager groupByAlbumArtist];
    }
    return self;
}

/**
 *  the name of the tab bar icon image
 *
 *  @return the name of the tab bar icon image
 */
- (NSString *)tabBarIconName{
    return @"Artists";
}

/**
 *  the title of the tab bar item
 *
 *  @return the title of the tab bar item
 */
- (NSString *)tabBarTitle{
    return NIFLocStr(@"ARTISTS");
}

/**
 *  the type of controller, used for sorting
 *
 *  @return the type of controller, used for sorting
 */
- (NIFControllerType)controllerType{
    return NIFControllerTypeArtists;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

/**
 *  Allows for customising the data source.
 *
 *  @return The name of the selector that returns an array of data pertaining to the view controller.
 */
- (SEL)dataSelector{
    return _showAlbumArtist ? @selector(albumArtists) : @selector(artists);
}

/**
 *  Allows for customising the sort property or returning function. Sorts are completed alphabetically, this allows customisation of the property in which the sort function bases its comparison off of.
 *
 *  @return The name of the selector used to sort the media items.
 */
- (SEL)sortFieldName{
    return _showAlbumArtist ? @selector(albumArtist) : @selector(artist);
}

/**
 *  Allows defining a cell class. This class is used as the class for all cells within the table view.
 *
 *  @return The cell class to be used in the table view
 */
- (Class)cellClass{
    return [NIFImageArtistCell class];
}

/**
 *  Configures a given cell using the MPMediaItem provided.
 *
 *  @param cell      the cell
 *  @param mediaItem the media item pertaining to the index of the cell
 */
- (void)configureCell:(NIFImageArtistCell *)cell withMediaItem:(MPMediaItem *)mediaItem{
    cell.textLabel.text = _showAlbumArtist ? mediaItem.albumArtistSafety : mediaItem.artistSafety;
    NSString *propertyIdentifier = _showAlbumArtist ? MPMediaItemPropertyAlbumArtistPersistentID : MPMediaItemPropertyArtistPersistentID;
    NSInteger albumsCount = [sharedMusicManager numberOfAlbumsForArtist:[mediaItem valueForProperty:propertyIdentifier]];
    NSInteger songsCount = [sharedMusicManager numberOfSongsForArtist:[mediaItem valueForProperty:propertyIdentifier]];
    [cell setAlbumsCount:albumsCount songsCount:songsCount];
    if ([mediaItem artwork]) {
        CGFloat size = [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath nullInstance]];
        UIImage *artworkImage = [[mediaItem artwork] imageWithSize:CGSizeMake(size, size)];
        cell.artworkImageView.image = artworkImage;
    }else{
        cell.artworkImageView.image = [UIImage imageNamed:@"ArtistPlaceholder.png"];
//        [cell.artworkImageView setPlaceholderTitle:mediaItem.artist
//                               placeholderSubtitle:@""
//                                         direction:NIFDirectionForward
//                                          animated:NO
//                                        completion:^(BOOL finished) {
//                                            
//                                        }];
    }
}

/**
 *  Action to be performed when the cell at the index path has been selected
 *
 *  @param tableView the table view containing the cell
 *  @param indexPath the indexpath of the cell
 */
- (void)selectedCellPertainingToMediaItem:(MPMediaItem *)mediaItem{

    NSArray *albums = nil;
    if (_showAlbumArtist) {
        albums = [sharedMusicManager albumsForAlbumArtist:[mediaItem valueForProperty:MPMediaItemPropertyAlbumArtistPersistentID]];
    }else{
        albums = [sharedMusicManager albumsForArtist:[mediaItem valueForProperty:MPMediaItemPropertyArtistPersistentID]];
    }
    
    NSArray *dataSource = [[NIFMediaCollator sharedCollator] configureSectionsForArray:albums fieldName:@selector(albumTitle)];
    
    NIFAlbumViewController *albumController = [[NIFAlbumViewController alloc] init];
    albumController.artistPersistentID = _showAlbumArtist ? [mediaItem valueForProperty:MPMediaItemPropertyAlbumArtistPersistentID] : [mediaItem valueForProperty:MPMediaItemPropertyArtistPersistentID];
    albumController.showingAlbumArtist = _showAlbumArtist;
    [albumController setExternalDataSource:dataSource];
    [albumController setTitle:_showAlbumArtist ? [mediaItem albumArtist] : [mediaItem artist]];
    
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
    return 96.0f;
}

- (BOOL)deletedCellPertainingToMediaItem:(MPMediaItem *)mediaItem{
    self.tabBarController.bottomBarHidden = !self.tabBarController.bottomBarHidden;
    return NO;
}

@end
