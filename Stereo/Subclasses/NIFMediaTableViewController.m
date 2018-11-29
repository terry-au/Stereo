//
//  NIFMediaTableViewController.m
//  Stereo
//
//  Created by Terry Lewis on 25/08/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import "NIFMediaTableViewController.h"
#import "NIFSearchResultsTableViewController.h"
#import "NIFVignetteBackgroundView.h"
#import "UISearchBar+Fix.h"

@interface NIFMediaTableViewController () <UISearchBarDelegate, UISearchControllerDelegate>

@property (nonatomic, strong) NIFSearchResultsTableViewController *searchResultsController;

@end

@implementation NIFMediaTableViewController{
    BOOL setsDataSource;
    BOOL _forceHideIndex;
    NSUInteger _tableRowCount, _minimumRowCount;
    BOOL _allowsDeletion;
    BOOL _sortingModeSet;
}

static NSString *CellIdentifier = @"SongCell";
static NSString *MetaCellIdentifier = @"MetaCell";

- (instancetype)initWithStyle:(UITableViewStyle)style{
    if (self = [super initWithStyle:style]) {
        _allowsDeletion = [self allowsDeletion];
    }
    return self;
}

/**
 *  Initialises a view controller with sorting enables.
 *
 *  @param sortingEnabled YES if sorting is enabled. NO if sorting is disabled.
 *
 *  @return the viewcontroller, with the sorting property set.
 */
- (instancetype)initWithSortingEnabled:(BOOL)sortingEnabled{
    if (self = [super init]) {
        _sort = sortingEnabled;
        _sortingModeSet = YES;
    }
    return self;
}

/**
 *  Whether or not to display the vignette image view as the background. (Default is YES)
 *
 *  @return YES if the vignette image view should be displayed. NO if the vignette image view should be hidden.
 */
- (BOOL)shouldDisplayVignetteBackgroundView{
    return YES;
}

/**
 *  Whether or not to display the search controller and thus the search bar. (Default is YES)
 *
 *  @return YES if the search controller should be shown, NO if the search controller should be hidden.
 */
- (BOOL)shouldDisplaySearchController{
    return YES;
}

/**
 *  Whether the cells are able to have the deletion action shown. (Default is YES)
 *
 *  @return YES if deletion is enabled, NO if deletion is disabled.
 */
- (BOOL)allowsDeletion{
    return YES;
}

/**
 *  Sets up the search controller and search bar.
 */
- (void)setupSearchController{
    _searchResultsController = [NIFSearchResultsTableViewController sharedController];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:_searchResultsController];
    self.searchController.delegate = self;
    UISearchBar *searchBar = self.searchController.searchBar;
    [searchBar setSearchBarStyle:UISearchBarStyleMinimal];
    
    searchBar.delegate = self;
    searchBar.barStyle = UIBarStyleDefault;
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.tableView.tableHeaderView = searchBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self shouldDisplayVignetteBackgroundView]) {
        NIFVignetteBackgroundView *vig = [[NIFVignetteBackgroundView alloc] initWithFrame:self.tableView.frame];
        self.tableView.backgroundView = vig;
    }
//    self.tableView.backgroundColor = [UIColor clearColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_handleMediaLibraryChanged:) name:MPMediaLibraryDidChangeNotification object:nil];
    [self loadData];
    
    if ([self shouldDisplaySearchController]) {
        [self setupSearchController];
    }
    
    self.tableView.rowHeight = 44;
    
    [self.tableView reloadData];
}

- (void)_handleMediaLibraryChanged:(NSNotification *)notification{
    if (self.view && self.view.window) {
        [self loadData];
        [self.tableView reloadData];
    }
}

/**
 *  Called when view will appear, deselects the selected row, animated, if required.
 *
 *  @param animated whether or not to animate transitions within this method.
 */
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  Loads up the datasource.
 */
- (void)loadData{
//    this is somewhat hacky, but it saves us from checking the datasource structure /every/ single time.
//    basically, the idea is that if the table has more than 10 rows, the index titles and index section
//    headers return nil strings.
    
    _minimumRowCount = 10;
    if (!setsDataSource) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        NSArray *data = [[self dataTarget] performSelector:[self dataSelector]];
        if ([self sort]) {
            self.dataSource = [[NIFMediaCollator sharedCollator] configureSectionsForArray:data fieldName:[self sortFieldName]];
        }else{
            self.dataSource = data;
        }
#pragma cland diagnostic pop
    }else{
        //NSLog(@"Implement reloading capability here.");
    }
}

/**
 *  Updates the number of rows in the table.
 *  If multiple sections, it adds each section's row count.
 */
- (void)_updateRowCount{
    NSUInteger sections = [self.tableView numberOfSections];
    
    NSUInteger rows = 0;
    
    for(NSUInteger i = 0; i < sections; i++)
    {
        rows += [self.tableView numberOfRowsInSection:i];
    }
    
    _tableRowCount = rows;
}

/**
 *  Sets an external dataSource, this overrides the inherited dataSource.
 *
 *  @param externalDataSource array of MPMediaItems.
 */
- (void)setExternalDataSource:(NSArray *)externalDataSource{
    setsDataSource = YES;
    _externalDataSource = externalDataSource;
    self.dataSource = externalDataSource;
}

/**
 *  Whether or not to show the meta cell. This button may, for example show "All Songs" or "All Songs" for artist, etc.
 *
 *  @return YES if the meta cell should be shown. NO if the meta cell should be hidden.
 */
- (BOOL)showsMetaCell{
    return NO;
}

/**
 *  The number of sections in the tableView.
 *
 *  @param tableView the tableView.
 *
 *  @return The number of sections in the tableView.
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.sort) {
        return [self.dataSource count] + [self showsMetaCell];
    }else{
        return 1 + [self showsMetaCell];
    }
}

NSInteger offsetSectionFromSection(NIFMediaTableViewController *mvc, NSInteger section){
    return section + [mvc showsMetaCell];
}

NSInteger onsetSectionFromSection(NIFMediaTableViewController *mvc, NSInteger section){
    return section - [mvc showsMetaCell];
}

/**
 *  Returns the number of rows that exist in the section in the tableView.
 *
 *  @param tableView the tableView
 *  @param section   the section index
 *
 *  @return the number of rows in the seciont in the tableView.
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([self showsMetaCell]) {
        if (section == 0) {
            return 1;
        }
        section = onsetSectionFromSection(self, section);
    }
    
    if ([self sort] == NO) {
        return [self.dataSource count];
    }
//    NSLog(@"Sort: %@", self.sort ? @"Yes" : @"No");
    NSArray *timeZonesInSection = self.dataSource[section];
    NSInteger returnValue = [timeZonesInSection count];
    
    return returnValue;
}

/**
 *  The title to be used for the header at the section index provided.
 *
 *  @param tableView tableView
 *  @param section   section index
 *
 *  @return the title for the aforementioned section index.
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ((_minimumRowCount > _tableRowCount) || _forceHideIndex) {
        return nil;
    }
    
    if ([self showsMetaCell]) {
        if (section == 0) {
            return nil;
        }
    }
    
    NSInteger onsetSection = onsetSectionFromSection(self, section);
    if (self.sort && [self tableView:tableView numberOfRowsInSection:section]) {
//        NSLog(@"%li", onsetSection);
        return NIFMediaCollator.sharedCollator.collation.sectionTitles[onsetSection];
    }
    return nil;
}

/**
 *  Array of strings. Titles to be used as section indexes
 *
 *  @param tableView tableView
 *
 *  @return the array of titles.
 */
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if ((_minimumRowCount > _tableRowCount) || _forceHideIndex) {
        return nil;
    }
    return [self sort] ? [[NIFMediaCollator sharedCollator].collation sectionIndexTitles] : nil;
}

/**
 *  Returns the index of the section
 *
 *  @param tableView tableView
 *  @param title     section title
 *  @param index     index of section
 *
 *  @return Index of the section
 */
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [[NIFMediaCollator sharedCollator].collation sectionForSectionIndexTitleAtIndex:index];
}

/**
 *  The mediaItem associated with the provided indexPath.
 *
 *  @param indexPath the indexPath
 *
 *  @return the mediaItem associated with the provided index path.
 */
- (MPMediaItem *)mediaItemForIndexPath:(NSIndexPath *)indexPath{
    if ([self sort]) {
        NSInteger section = onsetSectionFromSection(self, indexPath.section);
        NSArray *itemsInSection = self.dataSource[section];
        return itemsInSection[indexPath.row];
    }else{
        return self.dataSource[indexPath.row];
    }
}

/**
 *  Iterates accross all cells in the table view, with the associated MPMediaItem for each cell.
 *
 *  @param block block of methods to perform, may use MPMediaItem provided.
 */
- (void)iterateCellsWithBlock:(void(^)(MPMediaItem *mediaItem, NSIndexPath *indexPath))block{
    for (NSInteger section = offsetSectionFromSection(self, 0); section < [self.tableView numberOfSections]; section++) {
        for (NSInteger row = 0; row < [self.tableView numberOfRowsInSection:section]; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:section];
            MPMediaItem *mediaItem = [self mediaItemForIndexPath:indexPath];
            block(mediaItem, indexPath);
        }
    }
}

/**
 *  Flattens the dataSource of sub-arrays into one array. Used when disabling the section titles and indexes.
 *
 *  @param array the array of arrays to flatten
 *
 *  @return flattened array
 */
NSArray *flatArrayFromArray(NSArray *array){
    NSMutableArray *mainArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count ; i++)
    {
        [mainArray addObjectsFromArray:[array objectAtIndex:i]];
    }
    return mainArray;
}

/**
 *  An array of items in the dataSource. This array is flattened, i.e. it is not an array of arrays.
 *
 *  @return the flattened array.
 */
- (NSArray *)allMediaItems{
    if ([self sort]) {
        return flatArrayFromArray(self.dataSource);
    }else{
        return [self.dataSource mutableCopy];
    }
}

/**
 *  Returns a cell at a given indexPath, the cell is configured in a subclass using the media item.
 *
 *  @param tableView the tableView containing the cell
 *  @param indexPath the indexPath of the cell
 *
 *  @return the cell, configured.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BOOL handlingMetaCell = [self showsMetaCell] && indexPath.section == 0;
    UITableViewCell *cell = nil;
    
    if (handlingMetaCell) {
        cell = [tableView dequeueReusableCellWithIdentifier:MetaCellIdentifier];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    if (!cell) {
        if (handlingMetaCell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MetaCellIdentifier];
        }else{
            cell = [[[self cellClass] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.backgroundColor = [UIColor clearColor];
    }
    
    if (handlingMetaCell) {
        cell.textLabel.text = [self metaCellText];
        return cell;
    }
    
    MPMediaItem *mediaItem = [self mediaItemForIndexPath:indexPath];
    [self configureCell:cell withMediaItem:mediaItem indexPath:indexPath];
    return cell;
}

/*
 * Subclassable
 */

- (instancetype)init{
    self = [super init];
    if (self) {
        if (!_sortingModeSet) {
            _sort = YES;
        }
    }
    return self;
}

/**
 *  Allows defining a cell class. This class is used as the class for all cells within the table view.
 *
 *  @return The cell class to be used in the table view
 */
- (Class)cellClass{
    return [UITableViewCell class];
}

/**
 *  Registers the cell class for the table view.
 */
- (void)registerCellClass{
    [self.tableView registerClass:[self cellClass] forCellReuseIdentifier:CellIdentifier];
}

/**
 *  The target in which to execute the dataSelector method on.
 *
 *  @return the dataSelector method's target.
 */
- (id)dataTarget{
    return sharedMusicManager;
}

/**
 *  Allows for customising the data source.
 *
 *  @return The name of the selector that returns an array of data pertaining to the view controller.
 */
- (SEL)dataSelector{
    return @selector(songs);
}

/**
 *  Allows for customising the sort property or returning function. Sorts are completed alphabetically, this allows customisation of the property in which the sort function bases its comparison off of.
 *
 *  @return The name of the selector used to sort the media items.
 */
- (SEL)sortFieldName{
    return @selector(title);
}

/**
 *  Configures a given cell using the MPMediaItem provided.
 *
 *  @param cell      the cell
 *  @param mediaItem the media item pertaining to the index of the cell
 *  @param indexPath the index path of the cell.
 */
- (void)configureCell:(UITableViewCell *)cell withMediaItem:(MPMediaItem *)mediaItem indexPath:(NSIndexPath *)indexPath{
//    NSLog(@"Subclass this!");
    [self configureCell:cell withMediaItem:mediaItem];
}

/**
 *  Configures a given cell using the MPMediaItem provided.
 *
 *  @param cell      the cell
 *  @param mediaItem the media item pertaining to the index of the cell
 */
- (void)configureCell:(UITableViewCell *)cell withMediaItem:(MPMediaItem *)mediaItem{
//    NSLog(@"Subclass this!");
}

/**
 *  Sets the datasource
 *
 *  @param aDataSource the new datasource
 */
- (void)setDataSource:(NSArray *)aDataSource{
    _dataSource = aDataSource;
    [self _updateRowCount];
//    NSLog(@"Row count: %lu", (unsigned long)_tableRowCount);
}

#pragma mark - UISearchBarDelegate

/**
 *  Action to perform when search bar text changes.
 *
 *  @param searchBar  the searchBar.
 *  @param searchText the new text.
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [((NIFSearchResultsTableViewController *)self.searchController.searchResultsController) performSearchQueryWithText:searchText];
}

/**
 *  Sets the search bar background to a colourised state or not.
 *
 *  @param colourised YES if colourised, NO if transparent.
 */
- (void)setSearchBarColourised:(BOOL)colourised{
//    an excellent hack, thank-you, Apple, for kindly shipping bugs that need this type of fix,
    UIColor *newColour = colourised ? [UIColor whiteColor] : [UIColor clearColor];
    [UIView animateWithDuration:0.1f animations:^{
        [self.searchController.searchBar performMethodsWithOverride:^(UIView *fixBackgroundView) {
            fixBackgroundView.backgroundColor = newColour;
        }];
    }];
}

#pragma mark - UISearchControllerDelegate

- (void)NIF_setTabBarHidden:(BOOL)hidden{
    UITabBar *tabBar = self.tabBarController.tabBar;
    [UIView animateWithDuration:0.3f animations:^{
        if (hidden) {
            tabBar.layer.transform = CATransform3DMakeTranslation(0, CGRectGetHeight(tabBar.bounds), 0);
        }else{
            tabBar.hidden = hidden;
            tabBar.layer.transform = CATransform3DIdentity;
        }
    } completion:^(BOOL finished) {
        tabBar.hidden = hidden;
    }];
}

/**
 *  Action to perform before dismissing search controller.
 *
 *  @param searchController the searchController.
 */
- (void)willDismissSearchController:(UISearchController *)searchController{
//    _forceHideIndex = NO;
    [self NIF_setTabBarHidden:NO];
    [((NIFSearchResultsTableViewController *)self.searchController.searchResultsController) setParentToSearchViewController:nil];
    [self.tableView reloadSectionIndexTitles];
    [self setSearchBarColourised:NO];
}

/**
 *  Action to perform before presenting search controller.
 *
 *  @param searchController the searchController.
 */
- (void)willPresentSearchController:(UISearchController *)searchController{
    //    _forceHideIndex = YES;
    [self NIF_setTabBarHidden:YES];
    [((NIFSearchResultsTableViewController *)self.searchController.searchResultsController) setParentToSearchViewController:self];
//    NSLog(@"%@", [((NIFSearchResultsTableViewController *)self.searchController.searchResultsController) parentToSearchViewController]);
    [self.tableView reloadSectionIndexTitles];
    [self setSearchBarColourised:YES];
}


/**
 *  The height of "normal" cells in the table view.
 *
 *  @return the height of cells.
 */
- (CGFloat)heightForStandardCell{
    return self.tableView.rowHeight;
}

/**
 *  The height of the meta cell.
 *
 *  @return the height of the meta cell.
 */
- (CGFloat)heightForMetaCell{
    return self.tableView.rowHeight;
}

/**
 *  Returns the height for a given cell.
 *
 *  @param tableView the tableView.
 *  @param indexPath the indexPath of the cell.
 *
 *  @return the height of the cell in the tableView.
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self showsMetaCell] && [indexPath isKindOfClass:[NSIndexPath class]] && indexPath.section == 0 && indexPath.row == 0) {
        return [self heightForMetaCell];
    }
    return [self heightForStandardCell];
}

/**
 *  The text that will be displayed in the meta cell. (Override in subclass).
 *
 *  @return the meta cell text.
 */
- (NSString *)metaCellText{
    return nil;
}


/**
 *  Action to perform when a cell is selected.
 *
 *  @param tableView the tableView containing the cell.
 *  @param indexPath the indexPath of the cell.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self showsMetaCell] && indexPath.section == 0 && indexPath.row == 0) {
        [self selectedMetaCell];
    }else{
        MPMediaItem *mediaItem = [self mediaItemForIndexPath:indexPath];
        NSUInteger index = [self _queueIndexOfCellAtIndexPath:indexPath];
        [self selectedCellPertainingToMediaItem:mediaItem index:index];
    }
}

/**
 *  Action to perform upon deleting a cell.
 *
 *  @param tableView    the tableView containing the cell.
 *  @param editingStyle the editing style, delete is currently the only supported style.
 *  @param indexPath    the indexPath of the cell.
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        MPMediaItem *mediaItem = [self mediaItemForIndexPath:indexPath];
        BOOL success = [self deletedCellPertainingToMediaItem:mediaItem];
        if (success) {
            [self loadData];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

/**
 *  Called when a cell is deleted.
 *
 *  @param mediaItem the media item associated with the deleted cell.
 */
- (BOOL)deletedCellPertainingToMediaItem:(MPMediaItem *)mediaItem{
    return NO;
}

/**
 *  Action to perform when a cell is selected.
 *
 *  @param mediaItem the media item pertaining to the selected cell.
 */
- (void)selectedCellPertainingToMediaItem:(MPMediaItem *)mediaItem{
    
}

/**
 *  Returns the the index of an item in the data source given the indexpath.
 *
 *  @param indexPath the index path of the item.
 *
 *  @return the absolute index. i.e. the index if the datasource was a flat array.
 */
- (NSUInteger)_queueIndexOfCellAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger sectionCount = offsetSectionFromSection(self, indexPath.section);
    NSUInteger rowCount = -1;
    
    NSUInteger targetSection = indexPath.section;
    NSUInteger targetRow = indexPath.row;
    
    for (NSUInteger sectionStart = offsetSectionFromSection(self, 0); sectionStart <= sectionCount; sectionStart++) {
        NSUInteger numberOfRowsInCurrentSection = [self tableView:self.tableView numberOfRowsInSection:sectionStart];
        if (sectionStart != targetSection) {
            rowCount += numberOfRowsInCurrentSection;
        }else{
            rowCount += targetRow + 1;
            return rowCount;
        }
    }
    return NSNotFound;
}

/**
 *  Action to perform when a cell is selected.
 *
 *  @param mediaItem the media item pertaining to the selected cell.
 *  @param index the index of the media item in the current table data source.
 */
- (void)selectedCellPertainingToMediaItem:(MPMediaItem *)mediaItem index:(NSUInteger)index{
    [self selectedCellPertainingToMediaItem:mediaItem];
}

/**
 *  Action to perform when the meta-cell is selected.
 */
- (void)selectedMetaCell{
    
}

/**
 *  Determines whether a given cell can be deleted.
 *
 *  @param tableView the tableView containing the cell.
 *  @param indexPath the indexPath of the cell.
 *
 *  @return YES if the cell can be deleted, otherwise NO.
 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return _allowsDeletion;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

@end
