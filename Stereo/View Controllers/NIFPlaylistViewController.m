//
//  NIFPlaylistViewController.m
//  Stereo
//
//  Created by Terry Lewis on 13/08/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import "NIFPlaylistViewController.h"
#import "NIFSongViewController.h"

@interface NIFPlaylistViewController ()

@end

@implementation NIFPlaylistViewController

/**
 *  the name of the tab bar icon image
 *
 *  @return the name of the tab bar icon image
 */
- (NSString *)tabBarIconName{
    return @"Playlists";
}

/**
 *  the title of the tab bar item
 *
 *  @return the title of the tab bar item
 */
- (NSString *)tabBarTitle{
    return NIFLocStr(@"PLAYLISTS");
}

/**
 *  the type of controller, used for sorting
 *
 *  @return the type of controller, used for sorting
 */
- (NIFControllerType)controllerType{
    return NIFControllerTypePlaylists;
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
    return @selector(playlists);
}

/**
 *  Allows for customising the sort property or returning function. Sorts are completed alphabetically, this allows customisation of the property in which the sort function bases its comparison off of.
 *
 *  @return The name of the selector used to sort the media items.
 */
- (SEL)sortFieldName{
    return nil;
}

/**
 *  Whether the items should be sorted into sections
 *
 *  @return YES if they should be sorted into sections, NO if they should not be sorted into sections.
 */
- (BOOL)sort{
    return NO;
}

/**
 *  The mediaItem associated with the provided indexPath.
 *
 *  @param indexPath the indexPath
 *
 *  @return the mediaItem associated with the provided index path.
 */
- (MPMediaPlaylist *)mediaItemForIndexPath:(NSIndexPath *)indexPath{
    return (MPMediaPlaylist *)[super mediaItemForIndexPath:indexPath];
}

/**
 *  Configures a given cell using the MPMediaItem provided.
 *
 *  @param cell      the cell
 *  @param mediaItem the media item pertaining to the index of the cell
 */
- (void)configureCell:(UITableViewCell *)cell withMediaItem:(MPMediaPlaylist *)mediaItem{
//    NSLog(@"%@", mediaItem);
    cell.textLabel.text = mediaItem.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)selectedCellPertainingToMediaItem:(MPMediaPlaylist *)playlist{
    NSArray *songs = playlist.items;
    NIFSongViewController *songController = [[NIFSongViewController alloc] initWithPlaybackGroup:NIFMediaPlaybackGroupPlaylist sortingEnabled:NO];
    [songController setExternalDataSource:songs];
    [songController setPlaylistIdentifier:[[playlist valueForProperty:MPMediaEntityPropertyPersistentID] unsignedIntegerValue]];
    [songController setTitle:[playlist name]];
    songController.sourceIsAlbumIndepentent = YES;
//    NSLog(@"Set sorting to: %@", songController.sort ? @"On" : @"Off");
    
    [self.navigationController pushViewController:songController animated:YES];
}

@end
