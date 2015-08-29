//
//  FLGMapRegions.h
//  Nearbuy
//
//  Created by Javi Alzueta on 29/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FLGRegion;

@interface FLGMapRegions : NSObject

//@property(copy, nonatomic, readonly) NSMutableArray *regions;
@property (nonatomic, readonly) NSUInteger numberOfRegions;
@property (copy, nonatomic, readonly) NSMutableArray *annotations;
@property (copy, nonatomic, readonly) NSMutableArray *clRegions;
@property (copy, nonatomic, readonly) NSMutableArray *overlays;

+ (instancetype) mapRegionsWithRegions: (NSMutableArray *)regions;

- (FLGRegion *) regionAtIndex:(NSUInteger) index;
- (FLGRegion *) regionWithIdentifier:(NSNumber *) identifier;
- (void) addRegion: (FLGRegion *) region;
- (void) updateRegion: (FLGRegion *) region;
- (NSNumber *) nextRegionIdentifier;
- (void) removeRegionAtIndex: (NSUInteger) index;

@end
