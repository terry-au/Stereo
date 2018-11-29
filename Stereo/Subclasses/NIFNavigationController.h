//
//  NIFNavigationController.h
//  Stereo
//
//  Created by Terry Lewis on 13/08/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIFTabTableViewController.h"

@interface NIFNavigationController : UINavigationController

/**
 *  weak reference to the root view controller that is set during initialisation
 */
@property (nonatomic, weak, readonly) NIFTabTableViewController *initialViewController;

/**
 *  Saves the root controller in a weak reference upon initialisation
 *
 *  @param rootViewController the view controller that resides at the bottom of the navigation stack
 *
 *  @return the navigation controller
 */
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController;

@end
