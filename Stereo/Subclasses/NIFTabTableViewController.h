//
//  NIFTabTableViewController.h
//  Stereo
//
//  Created by Terry Lewis on 13/08/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Types.h"
#import "NIFStereoTabBarController.h"

@interface NIFTabTableViewController : UITableViewController

/**
 *  Calls the re-implemented method and invokes setup
 *
 *  @param tabBarIconName the name of the image to use as an icon
 *
 *  @return the initialised controller
 */
- (instancetype)initWithTabBarIconName:(NSString *)tabBarIconName;

/**
 *  Sets up the tab bar table view controller and registers now playing changes.
 *
 *
 *  @param tabBarIconName the name of the icon to use for the tab bar icon image.
 *  @param selected       whether the tab is selected
 *
 *  @return the configured controller
 */
- (instancetype)initWithTabBarIconName:(NSString *)tabBarIconName selected:(BOOL)selected;

/**
 *  Whether the tab bar item has a selected icon (override in subclass)
 *
 *  @return Whether the tab bar item has a selected icon
 */
- (BOOL)hasSelectedIcon;

/**
 *  the name of the tab bar icon's image (override in subclass)
 *
 *  @return the name of the tab bar icon's image
 */
- (NSString *)tabBarIconName;

/**
 *  the title of the tab bar item
 *
 *  @return the title of the tab bar item
 */
- (NSString *)tabBarTitle;

/**
 *  The controller type, which is used for sorting (override in subclass)
 *
 *  @return The controller type, which is used for sorting
 */
- (NIFControllerType)controllerType;


//override
@property(nullable, nonatomic, readonly, strong) NIFStereoTabBarController *tabBarController;

@end

/**
 *  Notification used to invoke refresh of the now playing button visibility state.
 */
extern NSString * const NIFUpdateNowPlayingButton;
