//
//  AppDelegate.m
//  Stereo
//
//  Created by Terry Lewis on 13/08/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import "AppDelegate.h"
#import "NIFStereoTabBarController.h"
#import "Controllers.h"
#import "NIFNavigationController.h"
#import "NIFMusicManager.h"
#import "NIFTabTableViewController.h"
#import "NIFVignetteBackgroundView.h"

@class NIFPreciseSeekViewController;

@interface AppDelegate () <UITabBarControllerDelegate>{
//    NSMutableArray *_retainedDelegates;
}

@property (nonatomic, strong) NIFStereoTabBarController *tabBarController;

@end

/*
 Playlists
 Artists
 Songs
 Albums
 Genres
 Compilations
 Composers
 */

@implementation AppDelegate

- (NIFNavigationController *)navigationControllerWithController:(UIViewController *)viewController{
    NIFNavigationController *navigationController = [[NIFNavigationController alloc] initWithRootViewController:viewController];
//    NIFNavigationControllerDelegate *delegate = [[NIFNavigationControllerDelegate alloc] init];
//    [_retainedDelegates addObject:delegate];
//    navigationController.delegate = delegate;
    
    return navigationController;
}

/**
 *  Creates a tab bar controller of all the music player tabs.
 *
 *  @param arrange whether the order of tabs should be loaded if saved.
 *
 *  @return the tab bar controller.
 */
- (NIFStereoTabBarController *)tabBarControllerWithArrangement:(BOOL)arrange{
//    _retainedDelegates = [[NSMutableArray alloc] init];
    NIFStereoTabBarController *tabBarController = [[NIFStereoTabBarController alloc] init];
    tabBarController.delegate = self;
    
    NIFNavigationController *playlistController = [self navigationControllerWithController:[[NIFPlaylistViewController alloc] init]];
    NIFNavigationController *artistController = [self navigationControllerWithController:[[NIFArtistViewController alloc] init]];
    NIFNavigationController *songController = [self navigationControllerWithController:[[NIFSongViewController alloc] initWithAllSongs:YES]];
    NIFNavigationController *albumController = [self navigationControllerWithController:[[NIFAlbumViewController alloc] initWithFullAlbums:YES]];
    NIFNavigationController *genreController = [self navigationControllerWithController:[[NIFGenreViewController alloc] init]];
    NIFNavigationController *compilationController = [self navigationControllerWithController:[[NIFCompilationViewController alloc] init]];
    NIFNavigationController *composerController = [self navigationControllerWithController:[[NIFComposerViewController alloc] init]];
    
    NSArray *controllers = @[playlistController, artistController, songController, albumController, genreController, compilationController, composerController];
    
    if (arrange) {
        NSMutableArray *arrangedController = nil;
        NSArray *order = [[NSUserDefaults standardUserDefaults] objectForKey:@"TabBarOrder"];
        if (order) {
            arrangedController = [NSMutableArray array];
            for (NSNumber *index in order) {
                for (NIFNavigationController *controller in controllers) {
                    if ([index intValue] == [controller.initialViewController controllerType]) {
                        [arrangedController addObject:controller];
                        break;
                    }
                }
            }
            controllers = arrangedController;
        }
    }
    
    tabBarController.viewControllers = controllers;
    UITableView *view = (UITableView *)tabBarController.moreNavigationController.topViewController.view;
    NIFVignetteBackgroundView *vig = [[NIFVignetteBackgroundView alloc] initWithFrame:view.frame];
    view.backgroundView = vig;
    if ([[view subviews] count]) {
        for (UITableViewCell *cell in [view visibleCells]) {
            cell.backgroundColor = [UIColor clearColor];
        }
    }
    
    return tabBarController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    /**
     *  Register notifications for library changes.
     *  Allows updating library if a sync is completed while Stereo is opened.
     */
    [[MPMediaLibrary defaultMediaLibrary] beginGeneratingLibraryChangeNotifications];
    
//    setup main window.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.tabBarController = [self tabBarControllerWithArrangement:YES];
//    [vig autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
//    register for remote control input.
    [self becomeFirstResponder];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
//    regain remote control input.
    [self becomeFirstResponder];
//    Issue notification to update now playing information when the application enters the foreground.
    [[NSNotificationCenter defaultCenter] postNotificationName:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:[NIFMusicManager playerController]];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
//    [[NSNotificationCenter defaultCenter] postNotificationName:NIFUpdateNowPlayingButton object:nil];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
//    [[NIFMusicManager playerController] _setUseApplicationSpecificQueue:YES];
//    [[NIFMusicManager playerController] stop];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark UITabBarControllerDelegate

/**
 *  Saves the tab order when user changes it.
 *
 *  @param tabBarController the controller that will be saved
 *  @param viewControllers  the tabs respective controllers
 *  @param changed          whether or not a change was issued
 */
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed{
    NSMutableArray *order = [NSMutableArray array];
    for (NIFNavigationController *navController in viewControllers) {
        NIFTabTableViewController *controller = navController.initialViewController;
        if ([controller respondsToSelector:@selector(controllerType)]) {
            [order addObject:@([controller controllerType])];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:order forKey:@"TabBarOrder"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
