//
//  NIFSearchResultsTableViewController.h
//  Stereo
//
//  Created by Terry Lewis on 20/10/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NIFSearchResultsTableViewController : UITableViewController

+ (instancetype)sharedController;

- (void)performSearchQueryWithText:(NSString *)searchQuery;
@property (nonatomic, strong) UIViewController *parentToSearchViewController;

@end
