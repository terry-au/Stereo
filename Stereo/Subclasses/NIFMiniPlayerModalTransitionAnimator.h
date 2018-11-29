//
//  NIFMiniPlayerModalTransitionAnimator.h
//  Stereo
//
//  Created by Terry Lewis on 26/12/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NIFModalAnimatedTransitioningType) {
    NIFModalAnimatedTransitioningTypePresenting,
    NIFModalAnimatedTransitioningTypeDismissing
};

@interface NIFMiniPlayerModalTransitionAnimator : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning>

@property (nonatomic) UIViewController *viewController;
@property (nonatomic) UIViewController *presentViewController;
@property (nonatomic) UIPanGestureRecognizer *pan;

- (void)attachToViewController:(UIViewController *)viewController withView:(UIView *)view presentViewController:(UIViewController *)presentViewController;

@property (nonatomic) NIFModalAnimatedTransitioningType transitionType;
@property (nonatomic) CGFloat initialY;

@end
