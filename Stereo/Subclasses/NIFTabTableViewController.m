//
//  NIFTabTableViewController.m
//  Stereo
//
//  Created by Terry Lewis on 13/08/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import "NIFTabTableViewController.h"
#import "NIFNowPlayingForwardButton.h"
#import "NIFNowPlayingViewController.h"

@interface NIFTabTableViewController (){
    UIBarButtonItem *_nowPlayingButton;
}

@end

NSString *const NIFUpdateNowPlayingButton = @"NIFUpdateNowPlayingButton";

@implementation NIFTabTableViewController

@dynamic tabBarController;

- (instancetype)init{
    if ([self tabBarIconName]) {
        self = [self initWithTabBarIconName:[self tabBarIconName] selected:[self hasSelectedIcon]];
    }else{
        self = [super init];
    }
    return self;
}

/**
 *  Sets up the tab bar table view controller and registers now playing changes.
 *
 *
 *  @param tabBarIconName the name of the icon to use for the tab bar icon image.
 *  @param selected       whether the tab is selected
 *
 *  @return the configured controller
 */
- (instancetype)initWithTabBarIconName:(NSString *)tabBarIconName selected:(BOOL)selected{
    self = [super init];
    if (self) {
        UIImage *selectedImage = [UIImage imageNamed:tabBarIconName];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-off", tabBarIconName]];
        if (image) {
            self.tabBarItem.image = image;
        }else{
            self.tabBarItem.image = selectedImage;
        }
        self.tabBarItem.selectedImage = selectedImage;
        self.tabBarItem.title = [self tabBarTitle];
        self.title = [self tabBarTitle];
        [self _registerNowPlaying];
        [self _setupNowPlayingButton];
    }
    return self;
}

/**
 *  Sets up the now playing button and makes it visible if an item is currently playing
 */
- (void)_setupNowPlayingButton{
    NIFNowPlayingForwardButton *nowPlayingButtonBase = [NIFNowPlayingForwardButton nowPlayingButton];
    [nowPlayingButtonBase addTarget:self action:@selector(_showNowPlayingViewController) forControlEvents:UIControlEventTouchUpInside];
    
    _nowPlayingButton = [[UIBarButtonItem alloc] initWithCustomView:nowPlayingButtonBase];
    
    [self _updateNavigationItemButtons];
}

/**
 *  Makes the now playing button visible if a current item is playing
 */
- (void)_updateNavigationItemButtons{
    if ([[NIFMusicManager playerController] playbackState] == MPMoviePlaybackStateStopped) {
        [self.navigationItem setRightBarButtonItem:nil animated:NO];
    }else{
        [self.navigationItem setRightBarButtonItem:_nowPlayingButton animated:NO];
    }
}

/**
 *  Method called when playback state changes
 *
 *  @param notification the notification, object is a reference to the currently playing player controller
 */
- (void)_nowPlayingStateDidChange:(NSNotification *)notification{
    [self _updateNavigationItemButtons];
}

/**
 *  Registers notifications for both the manual now playing update and the one issues when the playback state changes
 */
- (void)_registerNowPlaying{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_nowPlayingStateDidChange:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_nowPlayingStateDidChange:) name:NIFUpdateNowPlayingButton object:nil];
    
}

/**
 *  Pushes the now playing view controller (shared instance/singleton)
 */
- (void)_showNowPlayingViewController{
    [NIFNowPlayingViewController presentSharedInstanceFromViewController:self completion:nil];
}

/**
 *  Calls the re-implemented method and invokes setup
 *
 *  @param tabBarIconName the name of the image to use as an icon
 *
 *  @return the initialised controller
 */
- (instancetype)initWithTabBarIconName:(NSString *)tabBarIconName{
    return [self initWithTabBarIconName:tabBarIconName selected:NO];
}

/**
 *  the title of the tab bar item
 *
 *  @return the title of the tab bar item
 */
- (NSString *)tabBarTitle{
//    implement in subclass
    return nil;
}

/**
 *  the name of the tab bar icon image
 *
 *  @return the name of the tab bar icon image
 */
- (NSString *)tabBarIconName{
//    implement in subclass
    return nil;
}

/**
 *  whether a selected icon for this tab bar item exists
 *
 *  @return whether a selected icon for this tab bar item exists
 */
- (BOOL)hasSelectedIcon{
    return NO;
}

/**
 *  the type of controller, used for sorting
 *
 *  @return the type of controller, used for sorting
 */
- (NIFControllerType)controllerType{
    return NIFControllerTypeUndefined;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if (self.tabBarController.showsBottomBar) {
        UIEdgeInsets contentInsets = self.tableView.contentInset;
        contentInsets.bottom += self.tabBarController.bottomBarHeight;
        self.tableView.contentInset = contentInsets;
        
        UIEdgeInsets scrollIndicatorInsets = self.tableView.scrollIndicatorInsets;
        scrollIndicatorInsets.bottom += self.tabBarController.bottomBarHeight;
        self.tableView.contentInset = scrollIndicatorInsets;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
