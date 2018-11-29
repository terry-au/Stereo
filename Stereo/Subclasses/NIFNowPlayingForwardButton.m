//
//  NIFNowPlayingForwardButton.m
//  Stereo
//
//  Created by Terry Lewis on 16/09/2015.
//  Copyright (c) 2015 Terry Lewis. All rights reserved.
//

#import "NIFNowPlayingForwardButton.h"

@implementation NIFNowPlayingForwardButton{
    UILabel *_textLabel;
    UIImageView *_chevronImageView;
}

+ (instancetype)nowPlayingButton{
    NIFNowPlayingForwardButton *btn = [NIFNowPlayingForwardButton buttonWithType:UIButtonTypeSystem];
    if (btn) {
        [btn _setupViews];
    }
    return btn;
}

//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
//    return YES;
//}

//- (void)updateConstraints{
////    NSLog(@"%@", self.constraints);
//    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    NSArray *constraints = [UIView autoCreateConstraintsWithoutInstalling:^{
//        [self.imageView autoPinEdgeToSuperviewEdge:ALEdgeRight];
//        [self.imageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
//        [self.titleLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.imageView];
//        [self.titleLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
//    }];
//    [self addConstraints:constraints];
//    [super updateConstraints];
//}

/**
 *  Sets up the views and attempts to recreate what Apple probably did with private APIs.
 */
- (void)_setupViews{
//    UIButton *nowPlayingButtonBase = [UIButton buttonWithType:UIButtonTypeSystem];
    self.frame = CGRectMake(0, 0, 100, 44);
    [self setTitle:@"Now\nPlaying" forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"ForwardChevron.png"] forState:UIControlStateNormal];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont systemFontOfSize:10.0f];
    self.titleLabel.textAlignment = NSTextAlignmentRight;
    CGFloat offset = 3.0f;
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -self.imageView.frame.size.width-offset, 0, self.imageView.frame.size.width+offset);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, self.titleLabel.frame.size.width+offset, 0, -self.titleLabel.frame.size.width-offset);
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    this allows us to copy the offset of the chevron to match the regular back button's offset.
    self.contentEdgeInsets = UIEdgeInsetsMake(0, 6, 0, -4.5f);
    [self updateConstraints];
}

@end
