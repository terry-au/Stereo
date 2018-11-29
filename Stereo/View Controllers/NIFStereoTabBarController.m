//
//  NIFStereoTabBarController.m
//  Stereo
//
//  Created by Terry Lewis on 13/08/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import "NIFStereoTabBarController.h"
#import "NIFTabTableViewController.h"
#import "NIFNowPlayingViewController.h"
#import "NIFMiniPlayerModalTransitionAnimator.h"

@interface NIFStereoTabBarController ()
#ifdef Experimental
<UIViewControllerTransitioningDelegate>
#endif
{
    
#ifdef Experimental
    UIView *_bottomBar;
#endif
//    UIPanGestureRecognizer *_bottomBarPanGestureRecogniser;
//    UIView *_indicator;
}
#ifdef Experimental
@property (nonatomic) NIFMiniPlayerModalTransitionAnimator *presentInteractor;
@property (nonatomic) NIFMiniPlayerModalTransitionAnimator *dismissInteractor;
@property (nonatomic) NIFNowPlayingViewController *nowPlayingController;
#endif

@end

@implementation NIFStereoTabBarController

- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.tintColor = [UIColor _stereoOrangeColour];
#ifdef Experimental
    _showsBottomBar = YES;
    if (_showsBottomBar) {
        _bottomBar = [UIView newAutoLayoutView];
        _bottomBar.backgroundColor = [UIColor grayColor];
        [self.view insertSubview:_bottomBar belowSubview:self.tabBar];
        
        [UIView autoSetPriority:UILayoutPriorityDefaultLow forConstraints:^{
            [_bottomBar autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.tabBar];
        }];
        [_bottomBar autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_bottomBar autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [_bottomBar autoSetDimension:ALDimensionHeight toSize:[self bottomBarHeight]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomButtonTapped)];
        [_bottomBar addGestureRecognizer:tap];
        
        //            _bottomBarPanGestureRecogniser = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognised:)];
        //            [_bottomBar addGestureRecognizer:_bottomBarPanGestureRecogniser];
        
        //            _indicator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 2.0f)];
        //            _indicator.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        //            _indicator.backgroundColor = [UIColor redColor];
        //            [self.view insertSubview:_indicator aboveSubview:_bottomBar];
    }
    
    self.nowPlayingController = [[NIFNowPlayingViewController alloc] init];
    self.nowPlayingController.transitioningDelegate = self;
    self.nowPlayingController.modalTransitionStyle = UIModalPresentationCustom;
    self.nowPlayingController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    self.presentInteractor = [[NIFMiniPlayerModalTransitionAnimator alloc] init];
    [self.presentInteractor attachToViewController:self withView:_bottomBar presentViewController:self.nowPlayingController];
    self.dismissInteractor = [[NIFMiniPlayerModalTransitionAnimator alloc] init];
    [self.dismissInteractor attachToViewController:self.nowPlayingController withView:self.nowPlayingController.artworkView presentViewController:nil];
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#ifdef Experimental
- (CGFloat)bottomBarHeight{
    return 40;
}

- (CGAffineTransform)hiddenTransform{
    return CGAffineTransformMakeTranslation(0, CGRectGetHeight(_bottomBar.frame) + CGRectGetHeight(self.tabBar.frame));
}

- (CGAffineTransform)visibleTransform{
    return CGAffineTransformIdentity;
}

- (void)setBottomBarHidden:(BOOL)hidden{
    _bottomBarHidden = hidden;
    
    _bottomBar.hidden = NO;
    CGAffineTransform targetTransform, beginTransform;
    if (hidden) {
        targetTransform = [self hiddenTransform];
        beginTransform = [self visibleTransform];
    }else{
        targetTransform = [self visibleTransform];
        beginTransform = [self hiddenTransform];
    }
    
    _bottomBar.transform = beginTransform;
    [UIView animateWithDuration:0.3f animations:^{
        _bottomBar.transform = targetTransform;
    } completion:^(BOOL finished) {
        _bottomBar.hidden = hidden;
    }];
}

//- (void)setIndicatorY:(CGFloat)y{
//    CGRect rect = _indicator.frame;
//    rect.origin.y = y;
//    _indicator.frame = rect;
//}

- (void)handlePanGestureRecogniserChanged:(UIPanGestureRecognizer *)panGestureRecogniser{
    
    CGFloat parentHeight = CGRectGetHeight(self.view.frame);
    CGFloat recogniserViewHeight = CGRectGetHeight(panGestureRecogniser.view.frame);
    CGPoint translation = [panGestureRecogniser translationInView:self.view];
    CGPoint center = CGPointMake(panGestureRecogniser.view.center.x + translation.x,
                                 panGestureRecogniser.view.center.y + translation.y);
    if(center.y + recogniserViewHeight / 2 > parentHeight - CGRectGetHeight(self.tabBar.frame)){
        center.y = parentHeight - CGRectGetHeight(self.tabBar.frame) - recogniserViewHeight/2;
    }
    
    CGPoint adjustedCentre = panGestureRecogniser.view.center;
    adjustedCentre.y = center.y;
    panGestureRecogniser.view.center = adjustedCentre;
//    [self setIndicatorY:center.y];
    [panGestureRecogniser setTranslation:CGPointMake(0, 0) inView:self.view];
}

- (CGFloat)_minimumBottomBarPosition{
    return CGRectGetHeight(self.view.frame)
    - CGRectGetHeight(self.tabBar.frame)
    - CGRectGetHeight(_bottomBar.frame);
}

- (CGFloat)_maximumBottomBarPosition{
    return -CGRectGetHeight(_bottomBar.frame) + 100;
}

- (CGFloat)_bottomBarCompletionPositionPercentage{
    return 1.0f - (_bottomBar.frame.origin.y / [self _minimumBottomBarPosition]);
}

- (void)setToolbarCompletedTransition:(BOOL)completed withPanGestureRecogniser:(UIPanGestureRecognizer *)panGestureRecogniser{
    CGRect rect = _bottomBar.frame;
    if (completed) {
        rect.origin.y = [self _maximumBottomBarPosition];
    }else{
        rect.origin.y = [self _minimumBottomBarPosition];
        
    }
    CGPoint velocity = [panGestureRecogniser velocityInView:panGestureRecogniser.view];
    CGFloat yVel = ABS(velocity.y)/CGRectGetHeight(panGestureRecogniser.view.frame);
    
    [UIView animateWithDuration:0.3f
                          delay:0
         usingSpringWithDamping:0.98f
          initialSpringVelocity:yVel/2
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _bottomBar.frame = rect;
                     } completion:^(BOOL finished) {
                         NSLog(@"Completion: %f", [self _bottomBarCompletionPositionPercentage]);
                     }];
}

- (void)panGestureRecognised:(UIPanGestureRecognizer *)panGestureRecogniser{
    NSLog(@"%f", [self _bottomBarCompletionPositionPercentage]);
    switch (panGestureRecogniser.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
            [self handlePanGestureRecogniserChanged:panGestureRecogniser];
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            CGFloat yVelocity = [panGestureRecogniser velocityInView:panGestureRecogniser.view].y;
            BOOL desirableAmountOfVelocity = ABS(yVelocity) > 2000.0f;
            BOOL shouldComplete = yVelocity > 0.0f;
            if (desirableAmountOfVelocity) {
                [self setToolbarCompletedTransition:shouldComplete withPanGestureRecogniser:panGestureRecogniser];
            }else{
                shouldComplete = ([self _bottomBarCompletionPositionPercentage] > 0.20f && yVelocity < 0.0f);
                [self setToolbarCompletedTransition:shouldComplete withPanGestureRecogniser:panGestureRecogniser];
            }
            break;
        }
        default:
            break;
    }
}

- (void)bottomButtonTapped
{
    self.disableInteractivePlayerTransitioning = YES;
    [self presentViewController:self.nowPlayingController animated:YES completion:^{
        self.disableInteractivePlayerTransitioning = NO;
    }];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    NIFMiniPlayerModalTransitionAnimator *animator = [[NIFMiniPlayerModalTransitionAnimator alloc] init];
    animator.initialY = CGRectGetHeight(self.tabBar.frame);
    animator.transitionType = NIFModalAnimatedTransitioningTypeDismissing;
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    NIFMiniPlayerModalTransitionAnimator *animator = [[NIFMiniPlayerModalTransitionAnimator alloc] init];
    animator.initialY = CGRectGetHeight(self.tabBar.frame);
    animator.transitionType = NIFModalAnimatedTransitioningTypePresenting;
    return animator;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    if (self.disableInteractivePlayerTransitioning) {
        return nil;
    }
    return self.presentInteractor;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    if (self.disableInteractivePlayerTransitioning) {
        return nil;
    }
    return self.dismissInteractor;
}

#endif

@end
