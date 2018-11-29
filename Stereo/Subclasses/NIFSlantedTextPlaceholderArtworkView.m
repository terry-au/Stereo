//
//  NIFSlantedTextPlaceholderArtworkView.m
//  Stereo
//
//  Created by Terry Lewis on 7/09/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import "NIFSlantedTextPlaceholderArtworkView.h"
#import "UIView+Snapshot.h"

static const CGFloat kAnimationDuration = 0.25f;

@implementation NIFSlantedTextPlaceholderArtworkView{
    UILabel *_placeholderTitleLabel/*, *_placeholderSubtitleLabel*/;
    UIView *_labelBoundingView;
    UIImageView *_forwardOverlayImageView, *_backwardOverlayImageView;
    BOOL _showOverlayViews, _is35inch, _isAnimating;
    CGFloat iphone4Margin;
    NSLayoutConstraint *_backwardOffsetConstraint, *_forwardOffsetConstraint;
    CGFloat _scaledTitleSize, _scaledSubtitleSize;
    NSMutableArray *_animationBlocks;
}

/**
 *  Block that is used to store animations.
 *
 *  @param completion block that is called upon completion.
 */
typedef void(^aggregatedAnimationUnit)(BOOL completion);

/**
 *  Obtains the next animation that is queued.
 *
 *  @return the next animation block
 */
- (aggregatedAnimationUnit)getNextAnimation{
    aggregatedAnimationUnit block = (aggregatedAnimationUnit)[_animationBlocks firstObject];
    if (block){
        _isAnimating = YES;
        [_animationBlocks removeObjectAtIndex:0];
        return block;
    }else{
        _isAnimating = NO;
        return ^(BOOL finished){};
    }
}

//- (void)spinLabel{
//    _labelBoundingView.transform = CGAffineTransformMakeRotation(M_PI);
//    [UIView animateWithDuration:3 animations:^{
//        _labelBoundingView.transform = CGAffineTransformMakeRotation(8*M_PI);
//    }];
//}

/**
 *  Creates a view with a given frame and whether or now overlays should be shown.
 *
 *  @param frame            the size and location of the view
 *  @param showOverlayViews whether overlay (transition) views should be shown
 *
 *  @return the configured view.
 */
- (instancetype)initWithFrame:(CGRect)frame showOverlayViews:(BOOL)showOverlayViews{
    if (self = [super initWithFrame:frame]) {
        _animationBlocks = [NSMutableArray array];
        _showOverlayViews = showOverlayViews;
        _is35inch = IS_IPHONE4;
        [self setupViews];
    }
    return self;
}

/**
 *  Updates margins to ensure ensure smoothness on devices where the image view doesn't encompass the entire width of the screen, but animations still occur.
 */
- (void)_updateSideMargins{
    if (self.superview && _parentViewWidth == 0) {
        _parentViewWidth = self.superview.frame.size.width;
    }
    if (_is35inch) {
        iphone4Margin = (_parentViewWidth - _constrainedWidth) / 2;
    }else{
        iphone4Margin = 0;
    }
    if (_backwardOffsetConstraint && _forwardOffsetConstraint) {
        _forwardOffsetConstraint.constant = iphone4Margin;
        _backwardOffsetConstraint.constant = -iphone4Margin;
    }
//    NSLog(@"MARGIN %f", iphone4Margin);
}

/**
 *  It is important that the content mode between all of the image views is shared.
 *
 *  @param contentMode the content mode to be used on this view and the image views inside of it.
 */
- (void)setContentMode:(UIViewContentMode)contentMode{
    [super setContentMode:contentMode];
    _forwardOverlayImageView.contentMode = contentMode;
    _backwardOverlayImageView.contentMode = contentMode;
}

/**
 *  Sets the parent width in order to ensure smoothness on devices where the image view doesn't encompass the entire width of the screen, but animations still occur.
 *
 *  @param parentViewWidth the width
 */
- (void)setParentViewWidth:(CGFloat)parentViewWidth{
    _parentViewWidth = parentViewWidth;
    [self _updateSideMargins];
}

/**
 *  Sets the constrained width in order to ensure smoothness on devices where the image view doesn't encompass the entire width of the screen, but animations still occur.
 *
 *  @param constrainedWidth the width
 */
- (void)setConstrainedWidth:(CGFloat)constrainedWidth{
    _constrainedWidth = constrainedWidth;
    [self _updateSideMargins];
}

/**
 *  Updates label minimum sizes so they shrink to become visible in the current view, regardless of the view size.
 */
- (void)_updateLabelScaling{
    CGFloat multiplier = fmin(self.bounds.size.width, self.bounds.size.height) / 320;
    _placeholderTitleLabel.minimumScaleFactor = 0.1f;
    _scaledTitleSize = 40 * multiplier;
    _scaledSubtitleSize = 30 * multiplier;
    [self _updateTitles];
}

/**
 *  Updates the label scaling to reflect the new size, if any.
 */
- (void)layoutSubviews{
    [super layoutSubviews];
    [self _updateLabelScaling];
}

static UIColor *greyCharcoalColour;

/**
 *  Sets up placeholder views, the main view and transition views.
 */
- (void)setupViews{
    static CGFloat greyWhite = 242.0f/255.0f;
    static CGFloat greyCharcoal = 85.0f/255.0f;
    greyCharcoalColour = [UIColor colorWithRed:greyCharcoal green:greyCharcoal blue:greyCharcoal alpha:1.0f];
    self.backgroundColor = [UIColor colorWithRed:greyWhite green:greyWhite blue:greyWhite alpha:1.0f];
    
    _labelBoundingView = [UIView newAutoLayoutView];
    _placeholderTitleLabel = [UILabel newAutoLayoutView];
    _placeholderTitleLabel.numberOfLines = 0;
    _placeholderTitleLabel.textAlignment = NSTextAlignmentCenter;
    
//    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(spinLabel)]];
    
//    CGPoint center = _labelBoundingView.center;
    
    _labelBoundingView.clipsToBounds = YES;
    _labelBoundingView.transform = CGAffineTransformMakeRotation(-M_PI/4);
//    _labelBoundingView.center = center;
    [self _updateSideMargins];
    
    if (_showOverlayViews) {
        _forwardOverlayImageView = [UIImageView newAutoLayoutView];
        _backwardOverlayImageView = [UIImageView newAutoLayoutView];
        //    _forwardOverlayImageView.backgroundColor = _backwardOverlayImageView.backgroundColor = UIColor.redColor;
        
        [self addSubview:_forwardOverlayImageView];
        [self addSubview:_backwardOverlayImageView];
    }
    
    [self addSubview:_labelBoundingView];
    [_labelBoundingView addSubview:_placeholderTitleLabel];
//    [_labelBoundingView addSubview:_placeholderSubtitleLabel];
    
    [self setupConstraints];
}

/**
 *  Sets up constraints for placeholder views, the main view and transition views.
 */
- (void)setupConstraints{
    NSArray *boundingConstraints = [UIView autoCreateConstraintsWithoutInstalling:^{
        [_placeholderTitleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(marginInset(), marginInset(), marginInset(), marginInset())];
        [_placeholderTitleLabel autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:_placeholderTitleLabel withMultiplier:1 relation:NSLayoutRelationGreaterThanOrEqual];
        [_placeholderTitleLabel autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:_placeholderTitleLabel withMultiplier:1 relation:NSLayoutRelationGreaterThanOrEqual];
//        [_placeholderTitleLabel autoCenterInSuperview];
//        [_placeholderTitleLabel autoPinEdgesToSuperviewEdgesWithInsets:marginInsets() excludingEdge:ALEdgeBottom];
//        [_placeholderSubtitleLabel autoPinEdgesToSuperviewEdgesWithInsets:marginInsets() excludingEdge:ALEdgeTop];
//        [_placeholderSubtitleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_placeholderTitleLabel];
    }];
    [_labelBoundingView addConstraints:boundingConstraints];
    
    NSArray *constraints = [UIView autoCreateConstraintsWithoutInstalling:^{
        if (_showOverlayViews) {
            _forwardOffsetConstraint = [_forwardOverlayImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self withOffset:_is35inch ? iphone4Margin : 0];
            [_forwardOverlayImageView autoPinEdgeToSuperviewEdge:ALEdgeTop];
            [_forwardOverlayImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
            [_forwardOverlayImageView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:_forwardOverlayImageView];
            
            _backwardOffsetConstraint = [_backwardOverlayImageView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self withOffset:_is35inch ? -iphone4Margin : 0];
            [_backwardOverlayImageView autoPinEdgeToSuperviewEdge:ALEdgeTop];
            [_backwardOverlayImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
            [_backwardOverlayImageView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:_forwardOverlayImageView];
        }
        
        [_labelBoundingView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:1 relation:NSLayoutRelationLessThanOrEqual];
        [_labelBoundingView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_labelBoundingView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    }];
    [self addConstraints:constraints];
}

- (void)setPlaceholdersHidden:(BOOL)hidden{
    _labelBoundingView.hidden = /*_placeholderSubtitleLabel.hidden = */hidden;
}

/**
 *  Updates the placeholder titles using the data that exists in the instance variables.
 */
- (void)_updateTitles{
    BOOL bothStrings = NO;
    if (_placeholderSubtitle.length && _placeholderTitle.length) {
        bothStrings = YES;
    }else if(!_placeholderSubtitle && !_placeholderTitle){
        return;
    }
    NSMutableAttributedString *string = nil;
    NSDictionary *titleAttributes, *subtitleAttributes;
    titleAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:_scaledTitleSize],
                        NSForegroundColorAttributeName : greyCharcoalColour};
    subtitleAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:_scaledSubtitleSize],
                           NSForegroundColorAttributeName : greyCharcoalColour};
    if (bothStrings) {
        string = [[NSMutableAttributedString alloc] initWithString:_placeholderTitle attributes:titleAttributes];
        NSAttributedString *appendage = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@", _placeholderSubtitle] attributes:subtitleAttributes];
        [string appendAttributedString:appendage];
    }else{
        string = [[NSMutableAttributedString alloc] initWithString:_placeholderTitle ? : _placeholderSubtitle attributes:titleAttributes];
    }
    _placeholderTitleLabel.attributedText = string;
}

/**
 *  Sets subtitle of placeholder text
 *
 *  @param placeholderSubtitle subtitle of the placeholder text
 */
- (void)setPlaceholderSubtitle:(NSString *)placeholderSubtitle{
    _placeholderSubtitle = placeholderSubtitle;
//    _placeholderSubtitleLabel.text = _placeholderSubtitle;
    [self _updateTitles];
}

/**
 *  Sets title of placeholder text
 *
 *  @param placeholderTitle    title of the placeholder text
 */
- (void)setPlaceholderTitle:(NSString *)placeholderTitle{
    _placeholderTitle = placeholderTitle;
    [self _updateTitles];
}

/**
 *  Sets the placeholder text for the artwork view.
 *
 *  @param placeholderTitle    title of the placeholder text
 *  @param placeholderSubtitle subtitle of the placeholder text
 *  @param direction  direction the next playing item is in the queue (forward = next item)
 *  @param animated   whether the transition should be animated
 *  @param completion the block to be called upon completion
 */
- (void)setPlaceholderTitle:(NSString *)placeholderTitle placeholderSubtitle:(NSString *)placeholderSubtitle direction:(NIFDirection)direction animated:(BOOL)animated completion:(void (^)(BOOL finished))completion{
    [self setPlaceholdersHidden:NO];
//    if the previous image was also a placeholder, the image is nil, so we want a screenshot instead.
    UIImage *tmp = nil;
    if (self.image) {
        tmp = [self image];
    }else{
        tmp = [self layerContentsAsImage];
    }
    [self setPlaceholderTitle:placeholderTitle];
    [self setPlaceholderSubtitle:placeholderSubtitle];
    
    if (animated) {
        [self setImage:nil];
        UIImage *tempImage = [self layerContentsAsImage];
//        UIImage *oldImage = 
        self.image = tmp;
        [self setPlaceholdersHidden:YES];
//        we know this is a placeholder
        [self _setImageAnimated:tempImage direction:direction completion:completion isPlaceholder:YES];
    }else{
        [self setImage:nil];
        if (completion) {
            completion(YES);
        }
    }
}

/**
 *  Sets the image and animates the transition provided the direction.
 *
 *  @param image      image to be set
 *  @param direction  direction the next playing item is in the queue (forward = next item)
 *  @param animated   whether the transition should be animated
 *  @param completion the block to be called upon completion
 */
- (void)setImage:(UIImage *)image direction:(NIFDirection)direction animated:(BOOL)animated completion:(void (^)(BOOL finished))completion{
//    NSLog(@"Direction: %@", direction == NIFDirectionBackward ? @"Backward" : @"Forward");
    if (!animated) {
        [self setPlaceholdersHidden:YES];
        [self setImage:image];
        return;
    }
    [self _setImageAnimated:image direction:direction completion:completion isPlaceholder:NO];
}

/**
 *  Generates an image view for a given direction
 *
 *  @param direction  the direction the transition is occurring in
 *  @param multiplier a multiplier to be used for the transform, this allows changing forward to backward and vice-versa.
 *
 *  @return the generated imageview.
 */
- (UIImageView *)imageViewForDirection:(NIFDirection)direction multiplier:(CGFloat *)multiplier{
    BOOL isForward = direction == NIFDirectionForward;
    *multiplier = isForward ? 1.0f : -1.0f;
    return isForward ? _forwardOverlayImageView : _backwardOverlayImageView;
}

/**
 *  Hides overlay transition views
 *
 *  @param hidden whether they should be hidden
 */
- (void)setOverlayViewsHidden:(BOOL)hidden{
    _backwardOverlayImageView.hidden = _forwardOverlayImageView.hidden = hidden;
}

/**
 *  Probably the most haunting fucking thing I've ever written.
 *
 *  @param image                 the album artwork image
 *  @param direction             the direction the track is changing to
 *  @param completion            what is done upon completion
 */
- (void)_setImageAnimated:(UIImage *)image direction:(NIFDirection)direction completion:(void (^)(BOOL finished))completion isPlaceholder:(BOOL)isPlaceholder{
    
    __weak NIFSlantedTextPlaceholderArtworkView *weakSelf = self;
    [_animationBlocks addObject:^(BOOL isFinished){;
        [weakSelf setOverlayViewsHidden:NO];
        CGFloat mulitplier;
        UIImageView *workingView = [weakSelf imageViewForDirection:direction multiplier:&mulitplier];
        [workingView setImage:image];
//        BOOL presentingPlaceholder = image == nil;
        [UIView animateWithDuration:kAnimationDuration
                              delay:0
                            options:0
                         animations:^{
                             weakSelf.transform = CGAffineTransformMakeTranslation(mulitplier * -(self.frame.size.width + iphone4Margin), 0);
                         } completion:^(BOOL finished) {
                             weakSelf.image = workingView.image;
                             workingView.image = nil;
                             weakSelf.transform = CGAffineTransformMakeTranslation(0, 0);
                             if (isPlaceholder) {
                                 workingView.image = nil;
                                 weakSelf.image = nil;
                             }
                             [weakSelf setPlaceholdersHidden:!isPlaceholder];
                             //                         [self setOverlayViewsHidden:YES];
                             if (completion) {
                                 completion(finished);
                             }
                             [weakSelf getNextAnimation](YES);
                         }];
    }];
    if (!_isAnimating) {
        [self getNextAnimation](YES);
    }
}

@end
