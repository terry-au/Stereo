//
//  NIFNowPlayingTitlesView.m
//  Stereo
//
//  Created by Terry Lewis on 5/09/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import "NIFNowPlayingTitlesView.h"

@implementation NIFNowPlayingTitlesView{
    NSString *_artistText, *_albumText, *_titleText;
    UIFont *_classicFont, *_classicFontBold;
    BOOL _is35Inch;
}

/**
 *  Initialises the view and sets some values.
 *
 *  @param frame frame in which the view should encompass.
 *
 *  @return the setup view.
 */
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _is35Inch = IS_IPHONE4;
        [self setupViews];
    }
    return self;
}

//- (void)createAuxilaryLabel{
//    _auxilaryLabel = [UILabel newAutoLayoutView];
//    _auxilaryLabel.font = _is35Inch ? _titleLabel.font : _artistLabel.font;
//    _auxilaryLabel.hidden = YES;
//    [self addSubview:_auxilaryLabel];
//}

//- (NSArray *)_constraintsForAuxilaryLabel{
//    NSArray *constraints;
//    if (_is35Inch) {
//        constraints = [UIView autoCreateConstraintsWithoutInstalling:^{
//            [_auxilaryLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
//            [_auxilaryLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
//            [_auxilaryLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
//            [_auxilaryLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom];
//        }];
//    }else{
//        constraints = [UIView autoCreateConstraintsWithoutInstalling:^{
//            [_auxilaryLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
//            [_auxilaryLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
//            [_auxilaryLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
//        }];
//    }
//    return constraints;
//}

/**
 *  Sets up the views and configures them as required.
 */
- (void)setupViews{
    static CGFloat trailingBuffer = 80.0f;
    static CGFloat fadeLength = 0.0f;
    static CGFloat rate = 50.0f;
    _artistLabel = [NIFMarqueeLabel newAutoLayoutView];
    _artistLabel.rate = rate;
    _artistLabel.fadeLength = fadeLength;
    _artistLabel.marqueeType = MLContinuous;
    _artistLabel.textAlignment = NSTextAlignmentCenter;
    _classicFontBold = [UIFont boldSystemFontOfSize:14.0f];
    _classicFont = [UIFont systemFontOfSize:14.0f];
    _artistLabel.font = _is35Inch ? _classicFontBold : _classicFont;
    _artistLabel.animationDelay = 2.0f;
    _artistLabel.trailingBuffer = trailingBuffer;
    _artistLabel.delegate = _is35Inch ? nil : self;
    
    if (!_is35Inch) {
        _titleLabel = [NIFMarqueeLabel newAutoLayoutView];
        _titleLabel.rate = rate;
        _titleLabel.fadeLength = fadeLength;
        _titleLabel.marqueeType = MLContinuous;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
        _titleLabel.animationDelay = 2.0f;
        _titleLabel.trailingBuffer = trailingBuffer;
        _titleLabel.delegate = self;
        [self addSubview:_titleLabel];
    }
    
    [self addSubview:_artistLabel];
    
    [self setupConstraints];
}

/**
 *  Sets up the view constraints.
 */
- (void)setupConstraints{
    NSArray *constraints = [UIView autoCreateConstraintsWithoutInstalling:^{
        if (!_is35Inch) {
            [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
            [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
            [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
        }
        
        if (_is35Inch) {
            [_artistLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
        }else{
            [_artistLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_titleLabel withOffset:1.5f];
        }
        [_artistLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_artistLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [_artistLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    }];
    [self addConstraints:constraints];
}

/**
 *  Calls the appropriate method for the current device and caches the inputs.
 *
 *  @param titleText  song title
 *  @param albumText  album title
 *  @param artistText artist name
 */
- (void)setTitleText:(NSString *)titleText albumText:(NSString *)albumText artistText:(NSString *)artistText{
    [self setTitleText:titleText albumText:albumText artistText:artistText cache:YES];
}

/**
 *  Calls the appropriate method for the current device and caches the inputs if specified.
 *
 *  @param titleText  song title
 *  @param albumText  album title
 *  @param artistText artist name
 *  @param cache      whether the values should be stored
 */
- (void)setTitleText:(NSString *)titleText albumText:(NSString *)albumText artistText:(NSString *)artistText cache:(BOOL)cache{
    if (cache) {
        _titleText = titleText;
        _albumText = albumText;
        _artistText = artistText;
    }
    
    if (_is35Inch) {
        [self _setupLabelsClassicWithTitleText:titleText albumText:albumText artistText:artistText];
    }else{
        [self _setupLabelsWithTitleText:titleText albumText:albumText artistText:artistText];
    }
}

/**
 *  Sets up the labels with classic attributed formatting, used mostly on smaller screens where there is only one label.
 *
 *  @param titleText  song title
 *  @param albumText  album title
 *  @param artistText artist name
 */
- (void)_setupLabelsClassicWithTitleText:(NSString *)titleText albumText:(NSString *)albumText artistText:(NSString *)artistText{
    NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", _titleText] attributes:@{NSFontAttributeName : _classicFont}];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:titleString];
    
    if (_albumText) {
        NSAttributedString *albumString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", _albumText] attributes:@{NSFontAttributeName : _classicFontBold}];
        [attributedString appendAttributedString:albumString];
    }
    
    if (artistText) {
        NSAttributedString *artistString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", _artistText] attributes:@{NSFontAttributeName : _classicFont}];
        [attributedString appendAttributedString:artistString];
    }
    _artistLabel.attributedText = attributedString;
}

/**
 *  Generates a formatted album and artist string
 *
 *  @param artist artist name
 *  @param album  album name
 *
 *  @return concatenated and formatted string
 */
- (NSString *)albumArtistStringWithArtist:(NSString *)artist album:(NSString *)album{
    if (artist && album) {
        return [NSString stringWithFormat:@"%@ — %@", artist, album];
    }else if (!artist && !album){
        return nil;
    }else{
        return [NSString stringWithFormat:@"%@", artist ? : album];
    }
}

/**
 *  Sets the labels text
 *
 *  @param titleText  song title
 *  @param albumText  album title
 *  @param artistText artist name
 */
- (void)_setupLabelsWithTitleText:(NSString *)titleText albumText:(NSString *)albumText artistText:(NSString *)artistText{
    _titleLabel.text = titleText;
    _artistLabel.text = [self albumArtistStringWithArtist:artistText album:albumText];
    
    /**
     *  Sets the leading buffer if the label is going to scroll. This provides a nice padding between the label and the superview's bounds.
     */
    if ([_titleLabel labelWillScrollIfNecessary]) {
        _titleLabel.leadingBuffer = 10.0f;
    }else{
        _titleLabel.leadingBuffer = 0.0f;
    }
    if ([_artistLabel labelWillScrollIfNecessary]) {
        _artistLabel.leadingBuffer = 10.0f;
    }else{
        _artistLabel.leadingBuffer = 0.0f;
    }
}

/**
 *  Obtains the other label in the view, provided one label.
 *
 *  @param marqueeLabel the label
 *
 *  @return the other label
 */
- (NIFMarqueeLabel *)inverseLabelFromLabel:(NIFMarqueeLabel *)marqueeLabel{
    return marqueeLabel == _titleLabel ? _artistLabel : _titleLabel;
}

/**
 *  Should be called when super view controller didAppear is called.
 */
- (void)didAppear{
    [_titleLabel setLabelize:NO];
    [_artistLabel setLabelize:NO];
}

/**
 *  Should be called when super view controller willAppear is called.
 */
- (void)willAppear{
    [_artistLabel restartLabel];
    [_artistLabel restartLabel];
}

/**
 *  Should be called when super view controller willDisappear is called.
 */
- (void)willDisappear{
    [_titleLabel setLabelize:YES];
    [_artistLabel setLabelize:YES];
}

/**
 *  Sets the auxilary text, this does not scroll.
 *
 *  @param text   the text for the title field.
 *  @param detail the detail text.
 */
- (void)setAuxilaryText:(NSString *)text detail:(NSString *)detail{
    [_artistLabel setLabelize:YES];
    [_titleLabel setLabelize:YES];
    [self setTitleText:text albumText:detail artistText:nil cache:NO];
    //    _auxilaryLabel.hidden = NO;
    //    [UIView animateWithDuration:0.2 animations:^{
    //        _artistLabel.alpha = 0.0f;
    //        _titleLabel.alpha = 1.0f;
    //        _auxilaryLabel.alpha = 1.0f;
    //    } completion:^(BOOL finished) {
    //        if (!_is35Inch) {
    //            _artistLabel.hidden = YES;
    //            _titleLabel.hidden = YES;
    //        }
    //    }];
}

/**
 *  Hides the auxilary text, such as scrubber details.
 */
- (void)hideAuxilaryText{
    [_artistLabel setLabelize:NO];
    [_titleLabel setLabelize:NO];
    [self setTitleText:_titleText albumText:_albumText artistText:_artistText cache:NO];
    //    _artistLabel.hidden = NO;
    //    _titleLabel.hidden = NO;
    //    [UIView animateWithDuration:0.2 animations:^{
    //        _auxilaryLabel.alpha = 0.0f;
    //        _artistLabel.alpha = 1.0f;
    //        _titleLabel.alpha = 1.0f;
    //    } completion:^(BOOL finished) {
    //        _auxilaryLabel.hidden = YES;
    //    }];
}

#pragma NIFMarqueeLabelDelegate

/**
 *  Called when label finishes scrolling. Used to pause the other label or wait until this one completes in order for them to begin animations at the same time.
 *
 *  @param marqueeLabel the label that finished scrolling
 */
- (void)marqueeLabelDidFinishScrolling:(NIFMarqueeLabel *)marqueeLabel{
    NIFMarqueeLabel *otherLabel = [self inverseLabelFromLabel:marqueeLabel];
    if ([otherLabel awayFromHome]) {
        [marqueeLabel pauseLabel];
    }
}

/**
 *  Called when label begins scrolling. Used to pause the other label or wait until this one completes in order for them to begin animations at the same time.
 *
 *  @param marqueeLabel the label that began scrolling
 */
- (void)marqueeLabelWillBeginScrolling:(NIFMarqueeLabel *)marqueeLabel{
    NIFMarqueeLabel *otherLabel = [self inverseLabelFromLabel:marqueeLabel];
    if ([otherLabel awayFromHome]) {
        [marqueeLabel pauseLabel];
    }else if([otherLabel isPaused]){
        [otherLabel unpauseLabel];
    }
    
}

@end
