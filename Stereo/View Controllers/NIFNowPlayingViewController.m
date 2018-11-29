//
//  NIFNowPlayingViewController.m
//  Stereo
//
//  Created by Terry Lewis on 29/08/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import "NIFNowPlayingViewController.h"
#import "NIFPlaybackControlsView.h"
#import "NIFNowPlayingTitlesView.h"
#import "NIFDetailSlider.h"
#import "NIFMarqueeLabel.h"
#import "UIKit+Debug.h"
#import "NIFNavigationController.h"
#import "UINavigationItem+ClearTitle.h"
#import "NIFSongViewController.h"
#import "NIFNowPlayingDeepState.h"
#import "NIFVignetteBackgroundView.h"
#import "NIFActiveQueueViewController.h"
#import "UIFont+MonospaceCompat.h"

@interface MPDetailSlider : UIView

@end
//Macro to quickly obtain an instance of playerController.
#define controller [NIFMusicManager playerController]

@interface NIFNowPlayingViewController (){
    NIFPlaybackControlsView *_playbackControlsView;
    NIFVolumeView *_volumeView;
    NIFNowPlayingTitlesView *_nowPlayingTitlesView;
    NIFDetailSlider *_detailSlider;
    MPMediaEntityPersistentID _lastMediaItemIndex, _lastMediaItemIdentifier, _lastMediaItemAlbumIdentifier;
    NSLayoutConstraint *_controlsViewTopConstraint, *_volumeViewTopConstraint, *_artworkViewWidth;
    BOOL _isiphone4;
    BOOL _stubBool;
    BOOL _viewIsActive;
    NIFVignetteBackgroundView *_vignetteImageView;
    UILabel *_titleLabel;
}

@property (nonatomic, strong) UIViewController *oldViewController;

@end

@implementation NIFNowPlayingViewController

/**
 *  Returns a singleton of the Now Playing controller. This is required, especially due to the presence of the "Now Playing" button used throughout the application
 *
 *  @return shared instance of Now Playing controller
 */
+ (void)presentSharedInstanceFromViewController:(nonnull UIViewController *)viewController{
    [self presentSharedInstanceFromViewController:viewController completion:nil];
}

/**
 *  Presents the shared instance from a view controller containing a navigation controller.
 *
 *  @param viewController the parent view controller.
 *  @param completion the completion block to be called upon the presentation animation completing.
 */
+ (void)presentSharedInstanceFromViewController:(UIViewController *)viewController completion:(void (^)(void))completion{
    if ([viewController isKindOfClass:[NIFSongViewController class]]) {
        NIFSongViewController *songViewController = (NIFSongViewController *)viewController;
        [NIFMusicPlayerController sharedInstance].activeSongViewController = songViewController;
        [songViewController.tableView reloadData];
        [[NIFNowPlayingDeepState sharedInstance] setPlaybackGroup:[songViewController playbackGroup]];
        if (songViewController.playbackGroup == NIFMediaPlaybackGroupPlaylist) {
            [[NIFNowPlayingDeepState sharedInstance] setPlaylistIdentifier:songViewController.playlistIdentifier];
        }
    }
    [sharedNowPlayingController destroyBackButtonOnParentViewController];
    [NIFNowPlayingViewController sharedInstance].oldViewController = viewController;
//    [[viewController navigationItem] setBackBarButtonItem:back];
    [CATransaction begin];
    [CATransaction setCompletionBlock:completion];
    [viewController.navigationController pushViewController:[NIFNowPlayingViewController sharedInstance] animated:YES];
    [CATransaction commit];
//    NSLog(@"%@", [NIFNowPlayingDeepState sharedInstance].description);
}

/**
 *  Called when the view controller is about to be presented or popped.
 *  This method is used to restore th back button of the parent view controller.
 *
 *  @param parent The parent view controller (nullable).
 */
- (void)willMoveToParentViewController:(UIViewController *)parent{
    [super willMoveToParentViewController:parent];
    if (!parent) {
//        setting the old view controllers backBarButtonItem to nil created one that uses the title of the previous view controller as its title.
        _oldViewController.navigationItem.backBarButtonItem = nil;
    }
}

/**
 *  Returns a singleton of the Now Playing controller. This is required, especially due to the presence of the "Now Playing" button used throughout the application
 *
 *  @return shared instance of Now Playing controller
 */
+ (instancetype)sharedInstance{
    static NIFNowPlayingViewController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NIFNowPlayingViewController alloc] init];
        [sharedInstance loadView];
    });
    return sharedInstance;
}

- (BOOL)hidesBottomBarWhenPushed{
    return YES;
}

/**
 *  Sets up views and creates all necessary placeholder information.
 */
- (void)setupViews{
    _vignetteImageView = [NIFVignetteBackgroundView newAutoLayoutView];
    [self.view addSubview:_vignetteImageView];
    
    [controller beginGeneratingPlaybackNotifications];
    _artworkView = [[NIFSlantedTextPlaceholderArtworkView alloc] initWithFrame:CGRectZero showOverlayViews:YES];
    _artworkView.translatesAutoresizingMaskIntoConstraints = NO;
    _artworkView.contentMode = UIViewContentModeScaleAspectFit;
    _artworkView.userInteractionEnabled = YES;
    
//    double tap to show the active queue, just like the real music app.
    UITapGestureRecognizer *artworkDoubleTapGestureRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showNowPlayingQueue)];
    artworkDoubleTapGestureRecogniser.numberOfTapsRequired = 2;
    [_artworkView addGestureRecognizer:artworkDoubleTapGestureRecogniser];
    
    _playbackControlsView = [NIFPlaybackControlsView newAutoLayoutView];
    
    UIFont *buttonFont = [UIFont systemFontOfSize:13.0f];
    
    _repeatButton = [NIFHighlightButton buttonWithType:UIButtonTypeSystem];
    _repeatButton.translatesAutoresizingMaskIntoConstraints = NO;
    _repeatButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    _repeatButton.titleLabel.font = buttonFont;
    [_repeatButton addTarget:self action:@selector(changeRepeatMode) forControlEvents:UIControlEventTouchUpInside];
    
    _shuffleButton = [NIFHighlightButton buttonWithType:UIButtonTypeSystem];
    _shuffleButton.translatesAutoresizingMaskIntoConstraints = NO;
    _shuffleButton.titleLabel.textAlignment = NSTextAlignmentRight;
    _shuffleButton.titleLabel.font = buttonFont;
    [_shuffleButton addTarget:self action:@selector(changeShuffleMode) forControlEvents:UIControlEventTouchUpInside];
    
    [_repeatButton setTitle:NIFLocStr(@"REPEAT") forState:UIControlStateNormal];
    [_shuffleButton setTitle:NIFLocStr(@"SHUFFLE") forState:UIControlStateNormal];
    
    _volumeView = [[NIFVolumeView alloc] initWithFrame:CGRectZero];
    _volumeView.translatesAutoresizingMaskIntoConstraints = NO;
    _volumeView.showsRouteButton = _volumeView.areWirelessRoutesAvailable;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wirelessRoutesAvailabilityChanged:) name:MPVolumeViewWirelessRoutesAvailableDidChangeNotification object:nil];
    
    
    _nowPlayingTitlesView = [NIFNowPlayingTitlesView newAutoLayoutView];
    _detailSlider = [NIFDetailSlider newAutoLayoutView];
    _detailSlider.nowPlayingTitlesView = _nowPlayingTitlesView;
    
    [self.view addSubview:_nowPlayingTitlesView];
    [self.view addSubview:_repeatButton];
    [self.view addSubview:_shuffleButton];
    [self.view addSubview:_detailSlider];
    
    [self.view addSubview:_artworkView];
    [self.view addSubview:_playbackControlsView];
    [self.view addSubview:_volumeView];
    
    /**
     
     Just some notes regarding the layout in the official music app...
     
     ** insets seem to be 8 **
     
     titles view:
     52.5 high
     363 from top
     top is 21 high
     bottom is 15 high
     
     playback controls view:
     27 high
     436.5 from top
     
     21 difference, vertically between both.
     */
    [self setupConstraints];
}

/**
 *  Sets up constrains to allow for interface to layout, hopefully independent of screen size.
 */
- (void)setupConstraints{
    CGFloat iphone4ArtWidth = _isiphone4 ? 273.0f : self.view.frame.size.width;
//    NSLog(@"%f", iphone4ArtWidth);
    NSArray *constraints = [UIView autoCreateConstraintsWithoutInstalling:^{
        [_vignetteImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        [_artworkView autoPinToTopLayoutGuideOfViewController:self withInset:0];
        if (_isiphone4) {
            _artworkViewWidth = [_artworkView autoSetDimension:ALDimensionWidth toSize:iphone4ArtWidth];
            [_artworkView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        }else{
            _artworkViewWidth = [_artworkView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
            [_artworkView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        }
        _artworkView.constrainedWidth = iphone4ArtWidth;
        _artworkView.parentViewWidth = self.view.frame.size.width;
        [_artworkView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:_artworkView];
        
        [_detailSlider autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_artworkView withOffset:marginInset()];
        [_detailSlider autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:4.0f];
        [_detailSlider autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:4.0f];
        
        [_nowPlayingTitlesView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_detailSlider];
        [_nowPlayingTitlesView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_nowPlayingTitlesView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        
        [_repeatButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:14];
        [_repeatButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:2];
        
        [_shuffleButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:14];
        [_shuffleButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:2];
        
        [_playbackControlsView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_playbackControlsView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [_playbackControlsView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_nowPlayingTitlesView withOffset:marginInset()+2];
//        [_playbackControlsView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_volumeView];
        
//        [_playbackControlsView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:marginInset()];
//        [_playbackControlsView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:marginInset()];
//        [_playbackControlsView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
//        [_playbackControlsView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_nowPlayingTitlesView withOffset:marginInset() relation:NSLayoutRelationLessThanOrEqual];
//        [_playbackControlsView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_volumeView withOffset:marginInset() relation:NSLayoutRelationLessThanOrEqual];
//        [_playbackControlsView autoSetDimension:ALDimensionHeight toSize:30.0f];
        
        [_volumeView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:21.0f];
        [_volumeView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:21.0f];
//        [_volumeView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_shuffleButton];
        _volumeViewTopConstraint = [_volumeView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_playbackControlsView];
        [_volumeView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_repeatButton];
//        [_volumeView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_shuffleButton withOffset:-marginInset()];
        [_volumeView autoSetDimension:ALDimensionHeight toSize:28.0f];
    }];
    [self.view addConstraints:constraints];
    [self.view addConstraint:_volumeViewTopConstraint];
}

/**
 *  Shows AirPlay button if wireless route is available.
 *
 *  @param aNotification the notification.
 */
- (void)wirelessRoutesAvailabilityChanged:(NSNotification *)aNotification{
    _volumeView.showsRouteButton = _volumeView.wirelessRoutesAvailable;
}

/**
 *  Changes the repeat mode to next "in line"
 */
- (void)changeRepeatMode{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *repeatOff = [UIAlertAction actionWithTitle:NIFLocStr(@"REPEAT_OFF")
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          [self setRepeatMode:MPMusicRepeatModeNone];
                                                      }];
    UIAlertAction *repeatSong = [UIAlertAction actionWithTitle:NIFLocStr(@"REPEAT_SONG")
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          [self setRepeatMode:MPMusicRepeatModeOne];
                                                      }];
    UIAlertAction *repeatAll = [UIAlertAction actionWithTitle:NIFLocStr(@"REPEAT_ALL")
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          [self setRepeatMode:MPMusicRepeatModeAll];
                                                      }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NIFLocStr(@"CANCEL")
                             style:UIAlertActionStyleCancel
                           handler:nil];
    
    [alert addAction:repeatOff];
    [alert addAction:repeatSong];
    [alert addAction:repeatAll];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)setRepeatMode:(MPMusicRepeatMode)repeatMode{
    [controller setRepeatMode:repeatMode];
    [self determineRepeatMode];
}

/**
 *  Returns current repeat mode
 *
 *  @return current repeat mode
 */
- (MPMusicRepeatMode)currentRepeatMode{
    MPMusicRepeatMode repeatMode = controller.repeatMode;
    if (repeatMode == MPMusicRepeatModeDefault) {
        repeatMode = [controller repeatMode];
    }
    return repeatMode;
}

/**
 *  Returns current shuffle mode
 *
 *  @return current shuffle mode
 */
- (MPMusicShuffleMode)currentShuffleMode{
    MPMusicShuffleMode shuffleMode = controller.shuffleMode;
    if (shuffleMode == MPMusicShuffleModeDefault) {
        shuffleMode = [controller shuffleMode];
    }
    return shuffleMode;
}

/**
 *  Determines current repeat mode and applies string to repeat button.
 */
- (void)determineRepeatMode{
    MPMusicRepeatMode repeatMode = [self currentRepeatMode];
    switch (repeatMode) {
        case MPMusicRepeatModeDefault:
            
            break;
        case MPMusicRepeatModeNone:
            _repeatButton.selected = NO;
            [_repeatButton setTitle:NIFLocStr(@"REPEAT") forState:UIControlStateNormal];
            break;
        case MPMusicRepeatModeOne:
            _repeatButton.selected = YES;
            [_repeatButton setTitle:NIFLocStr(@"REPEAT_SONG") forState:UIControlStateNormal];
            break;
        case MPMusicRepeatModeAll:
            _repeatButton.selected = YES;
            [_repeatButton setTitle:NIFLocStr(@"REPEAT_ALL") forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

- (void)determineShuffleMode{
    MPMusicShuffleMode shuffleMode = [self currentShuffleMode];
    if (shuffleMode == MPMusicShuffleModeOff) {
        _shuffleButton.selected = NO;
        [_shuffleButton setTitle:NIFLocStr(@"SHUFFLE") forState:UIControlStateNormal];
    }else{
        _shuffleButton.selected = YES;
        [_shuffleButton setTitle:NIFLocStr(@"SHUFFLE_ALL") forState:UIControlStateNormal];
    }
    [self _updateTitleLabel];
    _lastMediaItemIndex = [controller indexOfNowPlayingItem];
}

/**
 *  Changes shuffle mode to the next "in line"
 */
- (void)changeShuffleMode{
    MPMusicShuffleMode shuffleMode = [self currentShuffleMode];
    if (shuffleMode == MPMusicShuffleModeOff) {
        shuffleMode = MPMusicShuffleModeSongs;
    }else{
        shuffleMode = MPMusicShuffleModeOff;
    }
    [controller setShuffleMode:shuffleMode];
    [self determineShuffleMode];
}

/**
 *  Sets up view and registers notifications.
 */
- (void)loadView{
    _isiphone4 = IS_IPHONE4;
    [super loadView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNowPlayingInformation:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarChanged:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    [self setupViews];
    self.hidesBottomBarWhenPushed = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *listButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UIButtonBarListIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showNowPlayingQueue)];
    [self.navigationItem setRightBarButtonItem:listButton];
    [self determineRepeatMode];
    [self determineShuffleMode];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [[UIFont systemFontOfSize:14.0f] monospaceFontVariant];
    self.navigationItem.titleView = _titleLabel;
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)showNowPlayingQueue{
    NIFActiveQueueViewController *activeQueue = [[NIFActiveQueueViewController alloc] init];
    activeQueue.showsTrackNumbers = !_queueIsAlbumIndependent;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:activeQueue];
    navigationController.view.tintColor = self.view.tintColor;
    navigationController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:navigationController animated:YES completion:nil];
}

/**
 *  Called when statusbar height changes, for example when incoming call changes to double statusbar.
 *
 *  @param aNotification notification. userinfo contains frame of new statusbar.
 */
- (void)statusBarChanged:(NSNotification *)aNotification{
//    CGFloat difference
//    NSLog(@"%@", aNotification.userInfo);
    CGRect oldFrame = [[UIApplication sharedApplication] statusBarFrame];
    CGRect newFrame = [[[aNotification userInfo] objectForKey:UIApplicationStatusBarFrameUserInfoKey] CGRectValue];
    CGFloat heightDelta = newFrame.size.height - oldFrame.size.height;
//    NSLog(@"%f", heightDelta);
    if (_isiphone4) {
        _artworkViewWidth.constant += heightDelta;
        _artworkView.constrainedWidth += heightDelta;
    }
    [UIView animateWithDuration:0.3 animations:^{
        if (newFrame.size.height > 10 && newFrame.size.height < 30) {
            _volumeViewTopConstraint.constant = 4.0f;
            _controlsViewTopConstraint.constant = 4.0f;
        }else{
            _volumeViewTopConstraint.constant = marginInset();
            _controlsViewTopConstraint.constant = 17.0f;
        }
    }];
}

/**
 *  Resets marquee label position to avoid issues with CoreAnimation queueing. Also updates now playing information.
 *
 *  @param animated whether the appearance will be animated.
 */
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [NIFMarqueeLabel controllerViewWillAppear:self];
    [self updateNowPlayingInformationWithMediaItem:[NIFMusicManager playerController].nowPlayingItem];
    [self destroyBackButtonOnParentViewController];
//    [_nowPlayingTitlesView willAppear];
}

/**
 *  Resets marquee label position to avoid issues with CoreAnimation queueing.
 *
 *  @param animated whether the disappearance was animated.
 */
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _viewIsActive = NO;
//    self.navigationController.navigationBar.backItem.title = @"Custom text";
//    [[UIApplication sharedApplication] setDoubleStatusBarEnabled:NO];
//    [_nowPlayingTitlesView willDisappear];
}

- (void)destroyBackButtonOnParentViewController{
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@""
                                                             style:UIBarButtonItemStylePlain
                                                            target:[self.oldViewController navigationController]
                                                            action:@selector(popViewControllerAnimated:)
                             ];
    [[self.oldViewController navigationItem] setBackBarButtonItem:back];
    /**
     *  Yeah, I know this is bad.
     */
//    [self.oldViewController.navigationItem setValue:@"" forKey:@"_backButtonTitle"];
}

/**
 *  Resets marquee label position to avoid issues with CoreAnimation queueing.
 *
 *  @param animated whether the appearance was animated.
 */
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [NIFMarqueeLabel controllerViewDidAppear:self];
    _viewIsActive = YES;
    [self destroyBackButtonOnParentViewController];
//    [_nowPlayingTitlesView didAppear];
}

/**
 *  Unregister all notification listeners that call selectors in this controller.
 */
- (void)dealloc{
    [controller endGeneratingPlaybackNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  Processes and platy media item and sets the now playing details using the media item in question. A queue is also specified, allowing for skipping back and forth between items within the queue.
 *
 *  @param index     the index of the media item
 *  @param queue     the queue of MPMediaItems.
 */
- (void)processMediaItemAtIndex:(NSUInteger)index inQueue:(NSArray *)queue{
    MPMediaItemCollection *collection = [[MPMediaItemCollection alloc] initWithItems:queue];
    [controller setQueueWithItemCollection:collection];
    MPMediaItem *mediaItem = [controller.queue objectAtIndex:index];
//    [controller setNowPlayingItem:mediaItem];
    [controller playItemAtIndex:index];
    _lastMediaItemIndex = index;
    [self updateNowPlayingInformationWithMediaItem:mediaItem];
    [controller play];
}

/**
 *  Processes and platy media item and sets the now playing details using the media item in question. A queue is also specified, allowing for skipping back and forth between items within the queue.
 *
 *  @param mediaItem the media item
 *  @param queue     the queue of MPMediaItems.
 */
- (void)processMediaItem:(MPMediaItem *)mediaItem inQueue:(NSArray *)queue{
    NSUInteger index = [queue indexOfObject:mediaItem];
    [self processMediaItemAtIndex:index inQueue:queue];
}

- (void)_updateTitleLabel{
    static UIFont *boldTitleFont = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        boldTitleFont = [[UIFont boldSystemFontOfSize:14.0f] monospaceFontVariant];
    });
    
    NSUInteger queueCurrentIndex = [controller indexOfNowPlayingItem] + 1;
    NSString *queueCurrentIndexString = [NSString stringWithFormat:@"%li", (unsigned long)queueCurrentIndex];
    
    NSUInteger queueLength = [controller queue].count;
    NSString *queueLengthString = [NSString stringWithFormat:@"%li", (unsigned long)queueLength];
    
    NSString *string = [NSString stringWithFormat:NIFLocStr(@"%@_OF_%@"), queueCurrentIndexString, queueLengthString];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSRange firstRange = [string rangeOfString:queueCurrentIndexString];
    NSRange secondRange = [string rangeOfString:queueLengthString];
    
    [attributedString addAttribute:NSFontAttributeName value:boldTitleFont range:firstRange];
    [attributedString addAttribute:NSFontAttributeName value:boldTitleFont range:secondRange];
    
    _titleLabel.attributedText = attributedString;
    [_titleLabel sizeToFit];
}

/**
 *  Updates album artwork to that derived from media item. If media item contains none, placeholder will be generated from album and artist name.
 *
 *  @param mediaItem media item to obtain details from.
 */
- (void)updateAlbumArtworkWithMediaItem:(MPMediaItem *)mediaItem{
    UIImage *artworkImage = [[mediaItem artwork] imageWithSize:CGSizeMake(320, 320)];
    NIFDirection _lastDirectionMoved = 0;
    
    if (_lastMediaItemIndex > [controller indexOfNowPlayingItem]) {
        _lastDirectionMoved = NIFDirectionBackward;
    }else if (_lastMediaItemIndex < [controller indexOfNowPlayingItem]){
        _lastDirectionMoved = NIFDirectionForward;
    }
    _lastMediaItemIndex = [controller indexOfNowPlayingItem];
    if (artworkImage) {
        [_artworkView setImage:artworkImage direction:_lastDirectionMoved animated:_viewIsActive completion:nil];
    }else{
        [_artworkView setPlaceholderTitle:mediaItem.artistSafety placeholderSubtitle:mediaItem.albumSafety direction:_lastDirectionMoved animated:_viewIsActive completion:nil];
    }
}

/**
 *  Updates now playing information with details derived from media item.
 *
 *  @param mediaItem media item to obtain details from.
 */
- (void)updateNowPlayingInformationWithMediaItem:(MPMediaItem *)mediaItem{
    if (_lastMediaItemIdentifier == [controller nowPlayingItem].persistentID) {
        return;
    }
    _lastMediaItemIdentifier = [controller nowPlayingItem].persistentID;
    [_detailSlider updateScaleWithMediaItem:mediaItem];
    [_nowPlayingTitlesView setTitleText:mediaItem.titleSafety albumText:mediaItem.albumSafety artistText:mediaItem.artistSafety];
    if (_lastMediaItemAlbumIdentifier != [controller nowPlayingItem].albumPersistentID) {
        [self updateAlbumArtworkWithMediaItem:mediaItem];
    }
    _lastMediaItemAlbumIdentifier = [controller nowPlayingItem].albumPersistentID;
}

/**
 *  Called when notification of playback item change is issued.
 *
 *  @param notification notification specifying playback change, object is playback controller.
 */
- (void)updateNowPlayingInformation:(NSNotification *)notification{
    [self _updateTitleLabel];
    if (!self.isViewLoaded || !self.view.window) {
        return;
    }
    [self updateNowPlayingInformationWithMediaItem:[controller nowPlayingItem]];
}

@end
