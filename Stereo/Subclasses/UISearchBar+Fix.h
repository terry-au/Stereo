//
//  NIFMinimalColourisedSearchBar.h
//  Stereo
//
//  Created by Terry Lewis on 8/11/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISearchBar (Fix)

- (void)performMethodsWithOverride:(void(^)(UIView *fixBackgroundView))methods;

@end
