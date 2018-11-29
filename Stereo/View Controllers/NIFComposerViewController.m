//
//  NIFComposerViewController.m
//  Stereo
//
//  Created by Terry Lewis on 13/08/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import "NIFComposerViewController.h"
#import "NIFSongViewController.h"

@interface NIFComposerViewController ()

@end

@implementation NIFComposerViewController

/**
 *  the name of the tab bar icon image
 *
 *  @return the name of the tab bar icon image
 */
- (NSString *)tabBarIconName{
    return @"Composers";
}

/**
 *  the title of the tab bar item
 *
 *  @return the title of the tab bar item
 */
- (NSString *)tabBarTitle{
    return NIFLocStr(@"COMPOSERS");
}

/**
 *  the type of controller, used for sorting
 *
 *  @return the type of controller, used for sorting
 */
- (NIFControllerType)controllerType{
    return NIFControllerTypeComposers;
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
    return @selector(composers);
}

/**
 *  Allows for customising the sort property or returning function. Sorts are completed alphabetically, this allows customisation of the property in which the sort function bases its comparison off of.
 *
 *  @return The name of the selector used to sort the media items.
 */
- (SEL)sortFieldName{
    return @selector(composerSafety);
}

/**
 *  Configures a given cell using the MPMediaItem provided.
 *
 *  @param cell      the cell
 *  @param mediaItem the media item pertaining to the index of the cell
 */
- (void)configureCell:(UITableViewCell *)cell withMediaItem:(MPMediaItem *)mediaItem{
    cell.textLabel.text = mediaItem.composerSafety;
}

/**
 *  Action to be performed when the cell at the index path has been selected
 *
 *  @param tableView the table view containing the cell
 *  @param indexPath the indexpath of the cell
 */
- (void)selectedCellPertainingToMediaItem:(MPMediaItem *)mediaItem{
    
    NSArray *albums = [sharedMusicManager songsForComposer:[mediaItem valueForProperty:MPMediaItemPropertyComposerPersistentID]];
    
    NIFSongViewController *songController = [[NIFSongViewController alloc] initWithPlaybackGroup:NIFMediaPlaybackGroupComposer sortingEnabled:NO];
    [songController setExternalDataSource:albums];
    [songController setTitle:[mediaItem albumTitle]];
    songController.sourceIsAlbumIndepentent = YES;
    
    [self.navigationController pushViewController:songController animated:YES];
}

@end
