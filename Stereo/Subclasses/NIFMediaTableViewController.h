//
//  NIFMediaTableViewController.h
//  Stereo
//
//  Created by Terry Lewis on 25/08/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import "NIFTabTableViewController.h"

@interface NIFMediaTableViewController : NIFTabTableViewController

/**
 *  Initialises a view controller with sorting enables.
 *
 *  @param sortingEnabled YES if sorting is enabled. NO if sorting is disabled.
 *
 *  @return the viewcontroller, with the sorting property set.
 */
- (instancetype)initWithSortingEnabled:(BOOL)sortingEnabled;

/**
 *  An array of items in the dataSource. This array is flattened, i.e. it is not an array of arrays.
 *
 *  @return the flattened array.
 */
- (NSArray *)allMediaItems;


/**
 *  The mediaItem associated with the provided indexPath.
 *
 *  @param indexPath the indexPath
 *
 *  @return the mediaItem associated with the provided index path.
 */
- (MPMediaItem *)mediaItemForIndexPath:(NSIndexPath *)indexPath;

/**
 *  Configures a given cell using the MPMediaItem provided.
 *
 *  @param cell      the cell
 *  @param mediaItem the media item pertaining to the index of the cell
 *  @param indexPath the index path of the cell.
 */
- (void)configureCell:(UITableViewCell *)cell withMediaItem:(MPMediaItem *)mediaItem indexPath:(NSIndexPath *)indexPath;

/**
 *  Configures a given cell using the MPMediaItem provided.
 *
 *  @param cell      the cell
 *  @param mediaItem the media item pertaining to the index of the cell
 */
- (void)configureCell:(UITableViewCell *)cell withMediaItem:(MPMediaItem *)mediaItem;

/**
 *  Allows defining a cell class. This class is used as the class for all cells within the table view.
 *
 *  @return The cell class to be used in the table view
 */
- (Class)cellClass;

/**
 *  The target in which to execute the dataSelector method on.
 *
 *  @return the dataSelector method's target.
 */
- (id)dataTarget;

/**
 *  Allows for customising the data source.
 *
 *  @return The name of the selector that returns an array of data pertaining to the view controller.
 */
- (SEL)dataSelector;

/**
 *  Allows for customising the sort property or returning function. Sorts are completed alphabetically, this allows customisation of the property in which the sort function bases its comparison off of.
 *
 *  @return The name of the selector used to sort the media items.
 */
- (SEL)sortFieldName;

/**
 *  The text that will be displayed in the meta cell. (Override in subclass).
 *
 *  @return the meta cell text.
 */
- (NSString *)metaCellText;

/**
 *  The height of "normal" cells in the table view.
 *
 *  @return the height of cells.
 */
- (CGFloat)heightForStandardCell;

/**
 *  The height of the meta cell.
 *
 *  @return the height of the meta cell.
 */
- (CGFloat)heightForMetaCell;

/**
 *  Action to perform when a cell is selected.
 *
 *  @param mediaItem the media item pertaining to the selected cell.
 *  @param index the index of the media item in the current table data source.
 */
- (void)selectedCellPertainingToMediaItem:(MPMediaItem *)mediaItem index:(NSUInteger)index;

/**
 *  Called when a cell is selected.
 *
 *  @param mediaItem the media item associated with the deleted cell.
 */
- (void)selectedCellPertainingToMediaItem:(MPMediaItem *)mediaItem;

/**
 *  Whether or not to show the meta cell. This button may, for example show "All Songs" or "All Songs" for artist, etc.
 *
 *  @return YES if the meta cell should be shown. NO if the meta cell should be hidden.
 */
- (BOOL)showsMetaCell;

/**
 *  Action to perform when the meta-cell is selected.
 */
- (void)selectedMetaCell;

/**
 *  Iterates accross all cells in the table view, with the associated MPMediaItem for each cell.
 *
 *  @param block block of methods to perform, may use MPMediaItem provided.
 */
- (void)iterateCellsWithBlock:(void(^)(MPMediaItem *mediaItem, NSIndexPath *indexPath))block;

/**
 *  Whether the cells are able to have the deletion action shown. (Default is YES)
 *
 *  @return YES if deletion is enabled, NO if deletion is disabled.
 */
- (BOOL)allowsDeletion;

/**
 *  Called when a cell is deleted.
 *
 *  @param mediaItem the media item associated with the deleted cell.
 */
- (BOOL)deletedCellPertainingToMediaItem:(MPMediaItem *)mediaItem;

/**
 *  Whether or not to display the vignette image view as the background. (Default is YES)
 *
 *  @return YES if the vignette image view should be displayed. NO if the vignette image view should be hidden.
 */
- (BOOL)shouldDisplayVignetteBackgroundView;

/**
 *  Whether or not to display the search controller and thus the search bar. (Default is YES)
 *
 *  @return YES if the search controller should be shown, NO if the search controller should be hidden.
 */
- (BOOL)shouldDisplaySearchController;

/**
 *  A datasource that can be used to override the dataSelector source.
 */
@property (nonatomic, strong) NSArray *externalDataSource;

/**
 *  The search controller.
 */
@property (nonatomic, strong, readonly) UISearchController *searchController;

/**
 *  The current dataSource.
 */
@property (nonatomic, strong, readonly) NSArray *dataSource;

/**
 *  Whether or not the cells should be sorted into sections.
 */
@property (nonatomic, readonly) BOOL sort;

@end
