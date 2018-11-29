//
//  NIFStereoTabBarController.h
//  Stereo
//
//  Created by Terry Lewis on 13/08/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NIFStereoTabBarController : UITabBarController

@property (nonatomic, readonly) BOOL showsBottomBar;
@property (nonatomic, readonly) CGFloat bottomBarHeight;
@property (nonatomic) BOOL bottomBarHidden;

#ifdef Experimental
@property (nonatomic) BOOL disableInteractivePlayerTransitioning;
#endif

@end
