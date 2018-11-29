//
//  NIFMediaCollator.m
//  Stereo
//
//  Created by Terry Lewis on 19/10/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import "NIFMediaCollator.h"

@implementation NIFMediaCollator

/**
 *  Returns a singleton of NIFMediaCollator
 *
 *  @return NIFMediaCollator shared instance
 */
+ (instancetype)sharedCollator{
    static NIFMediaCollator *sharedCollator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCollator = [[NIFMediaCollator alloc] init];
    });
    return sharedCollator;
}

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
- (NSArray *)configureSectionsForArray:(NSArray *)array fieldName:(SEL)fieldName{
    
    // Get the current collation and keep a reference to it.
    self.collation = [UILocalizedIndexedCollation currentCollation];
    
    NSInteger index, sectionTitlesCount = [[self.collation sectionTitles] count];
    
    NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    
    // Set up the sections array: elements are mutable arrays that will contain the media items for that section.
    for (index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [newSectionsArray addObject:array];
    }
    
    // Segregate the time zones into the appropriate arrays.
    for (MPMediaItem *mediaItem in array) {
        
        // Ask the collation which section number the time zone belongs in, based on its locale name.
        NSInteger sectionNumber = [self.collation sectionForObject:mediaItem collationStringSelector:fieldName];
        
        // Get the array for the section.
        NSMutableArray *sectionsArray = newSectionsArray[sectionNumber];
        
        //  Add the time zone to the section.
        [sectionsArray addObject:mediaItem];
    }
    
    // Now that all the data's in place, each section array needs to be sorted.
    for (index = 0; index < sectionTitlesCount; index++) {
        
        NSMutableArray *titlesArrayForSection = newSectionsArray[index];
        
        // If the table view or its contents were editable, you would make a mutable copy here.
        NSArray *sortedItemArrayForSection = [self.collation sortedArrayFromArray:titlesArrayForSection collationStringSelector:fieldName];
        
        // Replace the existing array with the sorted array.
        newSectionsArray[index] = sortedItemArrayForSection;
    }
    
    NSArray *sectionedArray = newSectionsArray;
    return sectionedArray;
}

/**
 *  Retrieves the representative items from a query, grouping the items with the provided grouping parameter.
 *
 *  @param aQuery   the query where the items will be obtained from.
 *  @param grouping the grouping in which to place items into.
 *
 *  @return an array of items, derived from the provided query and grouped using the provided group
 */
- (NSArray *)deriveRepresentativeItemsFromQuery:(MPMediaQuery *)aQuery withGrouping:(MPMediaGrouping)grouping{
    [aQuery setGroupingType:MPMediaGroupingAlbumArtist];
    NSArray *collections = [aQuery collections];
    NSMutableArray *outputs = [NSMutableArray array];
    for (MPMediaItemCollection *artist in collections) {
        //Grab the individual MPMediaItem representing the collection
        MPMediaItem *representativeItem = [artist representativeItem];
        //Store it in the "artists" array
        [outputs addObject:representativeItem];
    }
    return outputs;
}

@end
