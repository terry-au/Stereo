//
//  NIFActiveQueueViewController.m
//  Stereo
//
//  Created by Terry Lewis on 9/11/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import "NIFActiveQueueViewController.h"
#import "NIFNowPlayingDeepState.h"
#import "NIFSongCell.h"
#import "NIFSharedMethods.h"

@implementation NIFActiveQueueViewController{
    BOOL _updatePlayingIndicator;
    BOOL _updateTableView;
}

- (instancetype)init{
    if (self = [super initWithSortingEnabled:NO]) {
        _updatePlayingIndicator = YES;
        _updateTableView = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackStateDidChangeNotification:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nowPlayingItemDidChangeNotification:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)playbackStateDidChangeNotification:(NSNotification *)aNotification{
    NIFMusicPlayerController *player = aNotification.object;
    [self activeIndicatorView].playbackState = player.playbackState;
}

- (void)nowPlayingItemDidChangeNotification:(NSNotification *)aNotification{
    if (_updateTableView) {
        [self.tableView reloadData];
    }
}

- (void)setupNavigationBar{
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.navigationController.navigationBar.translucent = YES;
//    
//    UINavigationBar *navigationBar = self.navigationController.navigationBar;
//    UIVisualEffectView *blurEffectView = [self visualEffectView];
//    [blurEffectView setFrame:navigationBar.bounds];
//    [navigationBar addSubview:blurEffectView];
//    [navigationBar sendSubviewToBack:blurEffectView];
}

- (UIVisualEffectView *)visualEffectView{
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    return blurEffectView;
}

- (void)setupTableViewBackground{
    self.view.backgroundColor = [UIColor clearColor];
    UIVisualEffectView *blurEffectView = [self visualEffectView];
    [blurEffectView setFrame:self.view.bounds];
    self.tableView.backgroundView = blurEffectView;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupTableViewBackground];
    [self setupNavigationBar];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)];
    self.navigationItem.rightBarButtonItem = doneButton;
    [self scrollToNowPlayingIndexPath];
}

- (void)scrollToNowPlayingIndexPath{
    NSIndexPath *indexPath = [self updateNowPlayingCell];
    if (indexPath) {
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

- (void)doneAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id)dataTarget{
    return self;
}

- (SEL)dataSelector{
    return @selector(activeQueue);
}

- (BOOL)shouldDisplaySearchController{
    return NO;
}

- (BOOL)shouldDisplayVignetteBackgroundView{
    return NO;
}

- (BOOL)showsMetaCell{
    return NO;
}

- (BOOL)allowsDeletion{
    return NO;
}

- (Class)cellClass{
    return [NIFSongCell class];
}

- (NSArray *)activeQueue{
    return [NIFMusicPlayerController sharedInstance].queue;
}

- (void)configureCell:(NIFSongCell *)cell withMediaItem:(MPMediaItem *)mediaItem{
    cell.titleLabel.text = mediaItem.titleSafety;
//    if (_showsTrackNumbers) {
    cell.trackNumberLabel.text = [NIFSharedMethods stringFromTrackNumber:mediaItem.albumTrackNumber];
//    }else{
//        cell.trackNumberLabel.text = nil;
//    }
    cell.durationLabel.text = stringFromTimeInterval(mediaItem.playbackDuration);
    
    if (_updatePlayingIndicator) {
        if ([[NIFNowPlayingDeepState sharedInstance] identifierMatches:mediaItem.persistentID]) {
            cell.playing = YES;
        }else{
            cell.playing = NO;
        }
        
        if ([NIFNowPlayingDeepState sharedInstance].playbackGroup == NIFMediaPlaybackGroupSong){
            [cell setLeftAccessoryViewHidden:!cell.playing];
        }
    }
}

- (nullable NSIndexPath *)updateNowPlayingCell{
    __block NSIndexPath *playingIndexPath = nil;
    [self iterateCellsWithBlock:^(MPMediaItem *mediaItem, NSIndexPath *indexPath) {
        BOOL isNowPlayingItem = [[NIFNowPlayingDeepState sharedInstance] identifierMatches:[mediaItem persistentID]];
        if (isNowPlayingItem) {
            playingIndexPath = indexPath;
            return;
        }
    }];
    return playingIndexPath;
}

- (NIFNowPlayingIndicatorView *)activeIndicatorView{
    _updatePlayingIndicator = NO;
    NIFSongCell *cell = [self.tableView cellForRowAtIndexPath:[self updateNowPlayingCell]];
    _updatePlayingIndicator = YES;
    return [cell nowPlayingIndicator];
}

- (void)selectedCellPertainingToMediaItem:(MPMediaItem *)mediaItem index:(NSUInteger)index{\
    NIFMusicPlayerController *controller = [NIFMusicPlayerController sharedInstance];
    if (controller.indexOfNowPlayingItem == index) {
        _updateTableView = NO;
    }
//    [controller playItem:mediaItem];
    [controller playItemAtIndex:index];
    [controller play];
    _updateTableView = YES;
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

@end
