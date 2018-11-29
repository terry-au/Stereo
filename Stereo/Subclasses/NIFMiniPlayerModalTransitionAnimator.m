//
//  NIFMiniPlayerModalTransitionAnimator.m
//  Stereo
//
//  Created by Terry Lewis on 26/12/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import "NIFMiniPlayerModalTransitionAnimator.h"

@interface NIFMiniPlayerModalTransitionAnimator ()

@property (nonatomic) BOOL shouldComplete;

@end

@implementation NIFMiniPlayerModalTransitionAnimator

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    if (self.transitionType == NIFModalAnimatedTransitioningTypePresenting) {
        [self animatePresentingInContext:transitionContext toVC:to fromVC:from];
    } else if (self.transitionType == NIFModalAnimatedTransitioningTypeDismissing) {
        [self animateDismissingInContext:transitionContext toVC:to fromVC:from];
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.3f;
}

- (void)animatePresentingInContext:(id<UIViewControllerContextTransitioning>)transitionContext toVC:(UIViewController *)toVC fromVC:(UIViewController *)fromVC{
    CGRect fromVCRect = [transitionContext initialFrameForViewController:fromVC];
    CGRect toVCRect = fromVCRect;
    toVCRect.origin.y = toVCRect.size.height - self.initialY;
    
    toVC.view.frame = toVCRect;
    UIView *container = [transitionContext containerView];
    UIView *imageView = [self fakeMiniView];
    [toVC.view addSubview:imageView];
    [container addSubview:fromVC.view];
    [container addSubview:toVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         toVC.view.frame = fromVCRect;
                         imageView.alpha = 0.f;
                     } completion:^(BOOL finished) {
                         [imageView removeFromSuperview];
                         if ([transitionContext transitionWasCancelled]) {
                             [transitionContext completeTransition:NO];
                         } else {
                             [transitionContext completeTransition:YES];
                         }
                     }];
}

- (void)animateDismissingInContext:(id<UIViewControllerContextTransitioning>)transitionContext toVC:(UIViewController *)toVC fromVC:(UIViewController *)fromVC{
    CGRect fromVCRect = [transitionContext initialFrameForViewController:fromVC];
    fromVCRect.origin.y = fromVCRect.size.height - self.initialY;
    
    UIView *imageView = [self fakeMiniView];
    [fromVC.view addSubview:imageView];
    UIView *container = [transitionContext containerView];
    [container addSubview:toVC.view];
    [container addSubview:fromVC.view];
    imageView.alpha = 0.f;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         fromVC.view.frame = fromVCRect;
                         imageView.alpha = 1.f;
                     } completion:^(BOOL finished) {
                         [imageView removeFromSuperview];
                         if ([transitionContext transitionWasCancelled]) {
                             [transitionContext completeTransition:NO];
                             [toVC.view removeFromSuperview];
                         } else {
                             [transitionContext completeTransition:YES];
                         }
                     }];
}

- (UIView *)fakeMiniView
{
    // Fake a mini view, two ways:
    // 1. create a new certain one
    // 2. snapshot old one.
    
    UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, [[UIScreen mainScreen] bounds].size.width, 50.f)];
    dummyView.backgroundColor = [UIColor redColor];
    return dummyView;
}

- (void)attachToViewController:(UIViewController *)viewController withView:(UIView *)view presentViewController:(UIViewController *)presentViewController
{
    self.viewController = viewController;
    self.presentViewController = presentViewController;
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [view addGestureRecognizer:self.pan];
}

- (void)onPan:(UIPanGestureRecognizer *)pan
{
    CGPoint translation = [pan translationInView:pan.view.superview];
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            if (!self.presentViewController) {
                [self.viewController dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self.viewController presentViewController:self.presentViewController animated:YES completion:nil];
            }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            const CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height - 50.f;
            const CGFloat DragAmount = !self.presentViewController ? screenHeight : - screenHeight;
            const CGFloat Threshold = .3f;
            CGFloat percent = translation.y / DragAmount;
            
            percent = fmaxf(percent, 0.f);
            percent = fminf(percent, 1.f);
            [self updateInteractiveTransition:percent];
            
            self.shouldComplete = percent > Threshold;
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            if (pan.state == UIGestureRecognizerStateCancelled || !self.shouldComplete) {
                [self cancelInteractiveTransition];
            } else {
                [self finishInteractiveTransition];
            }
        }
            break;
        default:
            break;
    }
}

- (CGFloat)completionSpeed
{
    return 1.f - self.percentComplete;
}

@end
