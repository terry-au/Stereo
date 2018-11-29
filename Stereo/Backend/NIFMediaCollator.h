//
//  NIFMediaCollator.h
//  Stereo
//
//  Created by Terry Lewis on 19/10/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIFMediaCollator : NSObject

/**
 *  Returns a singleton of NIFMediaCollator
 *
 *  @return NIFMediaCollator shared instance
 */
+ (instancetype)sharedCollator;

/**
 *  The collation pertaining to the current locale.
 */
@property (nonatomic, strong) UILocalizedIndexedCollation *collation;

/**
 *  Generates an array in sections using the selector provided which returns a non-null string on each item in the array.
 *
 *  @param array     the array of items
 *  @param fieldName the selector to return a string for each item
 *
 *  @return an array of arrays, one array for each letter in the current locale's alphabetised collation index.
 *
 *  Credit: https://developer.apple.com/library/ios/samplecode/TableViewSuite/Listings/3_SimpleIndexedTableView_SimpleIndexedTableView_APLViewController_m.html
 */
- (NSArray *)configureSectionsForArray:(NSArray *)array fieldName:(SEL)fieldName;
/**
 *  Retrieves the representative items from a query, grouping the items with the provided grouping parameter.
 *
 *  @param aQuery   the query where the items will be obtained from.
 *  @param grouping the grouping in which to place items into.
 *
 *  @return an array of items, derived from the provided query and grouped using the provided group
 */
- (NSArray *)deriveRepresentativeItemsFromQuery:(MPMediaQuery *)aQuery withGrouping:(MPMediaGrouping)grouping;

@end
