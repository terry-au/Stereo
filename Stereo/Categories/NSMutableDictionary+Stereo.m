//
//  NSMutableDictionary+Stereo.m
//  Stereo
//
//  Created by Terry Lewis on 19/10/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import "NSMutableDictionary+Stereo.h"

@implementation NSMutableDictionary (Stereo)

+ (NSMutableDictionary *)createDictionaryForSectionIndex:(NSArray *)array
{
    [[UILocalizedIndexedCollation currentCollation] sectionTitles];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (char firstChar = 'a'; firstChar <= 'z'; firstChar++)
    {
        //NSPredicates are fast
        NSString *firstCharacter = [NSString stringWithFormat:@"%c", firstChar];
        NSArray *content = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.title beginswith[cd] %@", firstCharacter]];
        NSMutableArray *mutableContent = [NSMutableArray arrayWithArray:content];
        
        if ([mutableContent count] > 0)
        {
            NSString *key = [firstCharacter uppercaseString];
            [dict setObject:mutableContent forKey:key];
            //            NSLog(@"%@: %u", key, [mutableContent count]);
        }
        
        
    }
    
    return dict;
}

@end
