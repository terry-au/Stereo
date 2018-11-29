//
//  NIFSearchResultsTableViewController.m
//  Stereo
//
//  Created by Terry Lewis on 20/10/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import "NIFSearchResultsTableViewController.h"
#import "NIFImageSongCell.h"
#import "NIFImageAlbumCell.h"
#import "NIFImageArtistCell.h"
#import "NIFSharedMethods.h"
#import "NIFSettingsManager.h"
#import "NIFNowPlayingViewController.h"
#import "NIFNowPlayingDeepState.h"
#import "NIFAlbumViewController.h"

@interface NIFSearchResultsTableViewController (){
    NSArray *_splitDataSource;
    NSArray *_searchedDataSource;
}

@end

typedef NS_ENUM(NSUInteger, NIFSearchResultsSection){
    NIFSearchResultsSectionSongs,
    NIFSearchResultsSectionAlbums,
    NIFSearchResultsSectionArtists
};

@implementation NIFSearchResultsTableViewController

/**
 *  Returns a singleton of NIFSearchResultsTableViewController
 *
 *  @return a shared instance of NIFSearchResultsTableViewController
 */
+ (instancetype)sharedController{
    static NIFSearchResultsTableViewController *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[NIFSearchResultsTableViewController alloc] init];
    });
    return sharedController;
}

/**
 *  Sets up the data source.
 */
- (void)setupDataSource{
    _splitDataSource = @[[sharedMusicManager songs], [sharedMusicManager albums], [sharedMusicManager albumArtists]];
    NSMutableArray *combined = [NSMutableArray array];
    for (NSArray *array in _splitDataSource) {
        [combined addObjectsFromArray:array];
    }
}


static NSString *SongCellIdentifier = @"SongCellIdentifier";
static NSString *AlbumCellIdentifier = @"AlbumCellIdentifier";
static NSString *ArtistCellIdentifier = @"ArtistCellIdentifier";

/**
 *  Configure the view controller, and register the cell classes.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.tableView registerClass:[NIFImageSongCell class] forCellReuseIdentifier:SongCellIdentifier];
    [self.tableView registerClass:[NIFImageSongCell class] forCellReuseIdentifier:AlbumCellIdentifier];
    [self.tableView registerClass:[NIFImageSongCell class] forCellReuseIdentifier:ArtistCellIdentifier];
    
    [self setupDataSource];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/**
 *  Returns the number of sections for a table.
 *
 *  @param tableView the table.
 *
 *  @return the number of sections.
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _searchedDataSource.count;
}

/**
 *  Returns the number of rows in a given section.
 *
 *  @param tableView the table view containing the section.
 *  @param section   the section
 *
 *  @return the number of rows
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_searchedDataSource objectAtIndex:section] count];
}

/**
 *  Returns the reuse identifier for the provided section
 *
 *  @param section the section
 *
 *  @return the reuse identifier
 */
- (nullable NSString *)identifierForSection:(NSUInteger)section{
    switch (section) {
        case NIFSearchResultsSectionSongs:
            return SongCellIdentifier;
            break;
        case NIFSearchResultsSectionAlbums:
            return AlbumCellIdentifier;
            break;
        case NIFSearchResultsSectionArtists:
            return ArtistCellIdentifier;
            break;
    }
    return nil;
}

/**
 *  Returns the appropriate class for the provided section
 *
 *  @param section the section
 *
 *  @return the appropriate class.
 */
- (nullable Class)cellClassForSection:(NSUInteger)section{
    switch (section) {
        case NIFSearchResultsSectionSongs:
            return [NIFImageSongCell class];
            break;
        case NIFSearchResultsSectionAlbums:
            return [NIFImageSongCell class];
            break;
        case NIFSearchResultsSectionArtists:
            return [NIFImageSongCell class];
            break;
    }
    return nil;
}

//- (CGFloat)cellHeightForSection:(NSUInteger)section{
//    switch (section) {
//        case 0:
//            return 58.0f;
//            break;
//        case 1:
//            return 64.0f;
//            break;
//        case 2:
//            return 96.0f;
//            break;
//    }
//    return UITableViewAutomaticDimension;
//}

/**
 *  Returns the height for the row at a given index path on the provided table.
 *
 *  @param tableView the table containing the cell.
 *  @param indexPath the index path of the cell.
 *
 *  @return the height of the cell.
 */
- (CGFloat)heightForStandardCell{
    return 58.0f;
//    return [self cellHeightForSection:indexPath.section];
}

/**
 *  Configures a song cell
 *
 *  @param cell      the cell to configure
 *  @param mediaItem the media item represented by the cell.
 */
- (void)configureSongCell:(UITableViewCell *)cell withMediaItem:(MPMediaItem *)mediaItem{
    cell.textLabel.text = mediaItem.titleSafety;
    cell.detailTextLabel.attributedText = [NIFSharedMethods attributedStringForArtist:mediaItem.artistSafety album:mediaItem.albumSafety];
}

/**
 *  Configures an album cell
 *
 *  @param cell      the cell to configure
 *  @param mediaItem the media item represented by the cell.
 */
- (void)configureAlbumCell:(UITableViewCell *)cell withMediaItem:(MPMediaItem *)mediaItem{
    cell.textLabel.text = mediaItem.albumSafety;
    cell.detailTextLabel.text = mediaItem.albumArtist;
}

/**
 *  Configures an artist cell
 *
 *  @param cell      the cell to configure
 *  @param mediaItem the media item represented by the cell.
 */
- (void)configureArtistCell:(UITableViewCell *)cell withMediaItem:(MPMediaItem *)mediaItem{
    cell.detailTextLabel.text = nil;
    cell.textLabel.text = mediaItem.albumArtistSafety;
}

/**
 *  Configures a cell, depending on the section.
 *
 *  @param cell      the cell to configure.
 *  @param section   the section the cell is within.
 *  @param mediaItem the media item represented by the cell.
 */
- (void)configureCell:(UITableViewCell *)cell forSection:(NSUInteger)section withMediaItem:(MPMediaItem *)mediaItem{
    switch (section) {
        case NIFSearchResultsSectionSongs:
            [self configureSongCell:cell withMediaItem:mediaItem];
            break;
        case NIFSearchResultsSectionAlbums:
            [self configureAlbumCell:cell withMediaItem:mediaItem];
            break;
        case NIFSearchResultsSectionArtists:
            [self configureArtistCell:cell withMediaItem:mediaItem];
            break;
    }

    if ([mediaItem artwork]) {
        cell.imageView.image = [[mediaItem artwork] imageWithSize:CGSizeMake(50, 50)];
    }else{
        cell.imageView.image = [UIImage imageNamed:@"SongPlaceholder.png"];
    }
}

- (MPMediaItem *)mediaItemForIndexPath:(NSIndexPath *)indexPath{
    return [[_searchedDataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

/**
 *  Returns a cell for the given index path.
 *
 *  @param tableView the table view containing the cell.
 *  @param indexPath the index path of the cell.
 *
 *  @return the cell, configured.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [self identifierForSection:indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
//        cell = [[[self cellClassForSection:indexPath.section] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    MPMediaItem *mediaItem = [self mediaItemForIndexPath:indexPath];
    [self configureCell:cell forSection:indexPath.section withMediaItem:mediaItem];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (![self tableView:tableView numberOfRowsInSection:section]) {
        return nil;
    }
    switch (section) {
        case NIFSearchResultsSectionSongs:
            return NIFLocStr(@"SONGS");
            break;
        case NIFSearchResultsSectionAlbums:
            return NIFLocStr(@"ALBUMS");
            break;
        case NIFSearchResultsSectionArtists:
            return NIFLocStr(@"ARTISTS");
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissViewControllerAnimated:YES completion:^{
        [self playMediaItemAtIndexPath:indexPath];
        [(NIFMediaTableViewController *)self.parentToSearchViewController searchController].active = NO;
    }];
}

- (void)pushArtistControllerForMediaItem:(MPMediaItem *)mediaItem{
    NSArray *albums = nil;
    BOOL showAlbumArtist = YES;
    if (showAlbumArtist) {
        albums = [sharedMusicManager albumsForAlbumArtist:[mediaItem valueForProperty:MPMediaItemPropertyAlbumArtistPersistentID]];
    }else{
        albums = [sharedMusicManager albumsForArtist:[mediaItem valueForProperty:MPMediaItemPropertyArtistPersistentID]];
    }
    
    NSArray *dataSource = [[NIFMediaCollator sharedCollator] configureSectionsForArray:albums fieldName:@selector(albumTitle)];
    
    NIFAlbumViewController *albumController = [[NIFAlbumViewController alloc] init];
    albumController.artistPersistentID = showAlbumArtist ? [mediaItem valueForProperty:MPMediaItemPropertyAlbumArtistPersistentID] : [mediaItem valueForProperty:MPMediaItemPropertyArtistPersistentID];
    albumController.showingAlbumArtist = showAlbumArtist;
    [albumController setExternalDataSource:dataSource];
    [albumController setTitle:showAlbumArtist ? [mediaItem albumArtist] : [mediaItem artist]];
    
    [self.parentToSearchViewController.navigationController pushViewController:albumController animated:YES];
}

- (void)pushAlbumControllerForMediaItem:(MPMediaItem *)mediaItem{
    NSArray *albums = [sharedMusicManager songsForAlbum:[mediaItem valueForProperty:MPMediaItemPropertyAlbumPersistentID]];
    
    NIFSongViewController *albumController = [[NIFSongViewController alloc] initWithPlaybackGroup:NIFMediaPlaybackGroupAlbum sortingEnabled:NO];
    [albumController setExternalDataSource:albums];
    [albumController setTitle:[mediaItem albumTitle]];
    
    [self.parentToSearchViewController.navigationController pushViewController:albumController animated:YES];
}

- (void)pushSongControllerForMediaItem:(MPMediaItem *)mediaItem{
    NIFNowPlayingViewController *nowPlayingViewController = [NIFNowPlayingViewController sharedInstance];
    NSArray *queue = [sharedMusicManager songs];
    [nowPlayingViewController processMediaItem:mediaItem inQueue:queue];
    [NIFNowPlayingDeepState sharedInstance].playbackGroup = NIFMediaPlaybackGroupSong;
    [NIFNowPlayingViewController sharedInstance].queueIsAlbumIndependent = YES;
    [NIFNowPlayingViewController presentSharedInstanceFromViewController:self.parentToSearchViewController completion:nil];
}

- (void)playMediaItemAtIndexPath:(NSIndexPath *)indexPath{
    MPMediaItem *selectedMediaItem = [self mediaItemForIndexPath:indexPath];
    switch (indexPath.section) {
        case NIFSearchResultsSectionSongs:
            [self pushSongControllerForMediaItem:selectedMediaItem];
            break;
        case NIFSearchResultsSectionAlbums:
            [self pushAlbumControllerForMediaItem:selectedMediaItem];
            break;
        case NIFSearchResultsSectionArtists:
            [self pushArtistControllerForMediaItem:selectedMediaItem];
            break;
    }
//    [self.parentToSearchViewController.navigationController pushViewController:nowPlayingViewController animated:YES];
}

- (void)setParentToSearchViewController:(UIViewController *)parentToSearchViewController{
    _parentToSearchViewController = parentToSearchViewController;
    NSLog(@"setParentToSearchViewController: %@", parentToSearchViewController);
}

/**
 *  Returns the array of songs.
 *
 *  @return array of songs
 */
- (NSArray *)songsArray{
    return _splitDataSource[0];
}

/**
 *  Returns the array of albums.
 *
 *  @return array of albums.
 */
- (NSArray *)albumsArray{
    return _splitDataSource[1];
}

/**
 *  Returns the array of artists or album artists.
 *
 *  @return array of artists or album artists.
 */
- (NSArray *)artistsArray{
    return _splitDataSource[2];
}

- (void)performSearchQueryWithText:(NSString *)searchQuery{
//    [NSPredicate predicateWithFormat:@"titleSafety = %@", searchQuery]
    NSArray *filteredSongs = [[self songsArray] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"titleSafety CONTAINS[cd] %@", searchQuery]];
    NSArray *filteredAlbums = [[self albumsArray] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"albumSafety CONTAINS[cd] %@", searchQuery]];
    NSArray *filteredArtists = [[self artistsArray] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"albumArtistSafety CONTAINS[cd] %@", searchQuery]];
//    if ([[NIFSettingsManager sharedSettingsManager] groupByAlbumArtist]) {
//        filteredArtists = [[self artistsArray] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"albumArtistSafety CONTAINS[cd] %@", searchQuery]];
//    }else{
//        filteredArtists = [[self artistsArray] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"artistSafety CONTAINS[cd] %@", searchQuery]];
//    }
    
    _searchedDataSource = @[filteredSongs, filteredAlbums, filteredArtists];
    [self.tableView reloadData];
}

@end
