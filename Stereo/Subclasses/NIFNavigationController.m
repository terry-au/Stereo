//
//  NIFNavigationController.m
//  Stereo
//
//  Created by Terry Lewis on 13/08/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import "NIFNavigationController.h"

@implementation NIFNavigationController

/**
 *  Saves the root controller in a weak reference upon initialisation
 *
 *  @param rootViewController the view controller that resides at the bottom of the navigation stack
 *
 *  @return the navigation controller
 */
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    _initialViewController = (NIFTabTableViewController *)rootViewController;
    return self;
}

@end
