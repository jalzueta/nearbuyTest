//
//  FLGMapRegions.m
//  Nearbuy
//
//  Created by Javi Alzueta on 29/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import "FLGMapRegions.h"
#import "MyLocation.h"
#import "FLGRegion.h"
#import "NSNumber+FLGNumberUtils.h"

@import CoreLocation;

@interface FLGMapRegions ()

@property(copy, nonatomic, readonly) NSMutableArray *regions;
@property(copy, nonatomic) NSMutableArray *annotations;
@property(copy, nonatomic) NSMutableArray *clRegions;
@property(copy, nonatomic) NSMutableArray *overlays;

@end

@implementation FLGMapRegions

+ (instancetype) mapRegionsWithRegions: (NSMutableArray *)regions{
    return [[self alloc]initWithRegions:regions];
}

- (instancetype)initWithRegions: (NSMutableArray *)regions{
    if (self = [super init]) {
        _regions = regions;
    }
    return self;
}

- (NSUInteger)numberOfRegions{
    return self.regions.count;
}

- (NSMutableArray *)annotations{
    [_annotations removeAllObjects];
    for (FLGRegion *region in self.regions) {
        MyLocation *annotation = [[MyLocation alloc]initWithRegion:region];
        [_annotations addObject:annotation];
    }
    return _annotations;
}

- (NSMutableArray *)clRegions{
    [_clRegions removeAllObjects];
    for (FLGRegion *region in self.regions) {
        CLRegion *clRegion = [[CLCircularRegion alloc] initWithCenter:region.center
                                                               radius:[region.radius doubleValue]
                                                           identifier:region.identifierString];
        clRegion.notifyOnEntry = YES;
        clRegion.notifyOnExit = YES;
        [_clRegions addObject:clRegion];
    }
    return _clRegions;
}

- (NSMutableArray *)overlays{
    [_overlays removeAllObjects];
    for (FLGRegion *region in self.regions) {
        MKCircle *circle = [MKCircle circleWithCenterCoordinate:region.center
                                                         radius:[region.radius doubleValue]];
        [_overlays addObject:circle];
    }
    return _overlays;
}

- (FLGRegion *) regionAtIndex:(NSUInteger) index{
    if (index < self.regions.count) {
        return [self.regions objectAtIndex:index];
    }
    return nil;
}

- (FLGRegion *) regionWithIdentifier:(NSNumber *) identifier{
    FLGRegion *regionToReturn;
    for (FLGRegion *region in self.regions) {
        if ([region.identifier isEqualToNumber:identifier]) {
            regionToReturn = region;
            break;
        }
    }
    return regionToReturn;
}

- (void) addRegion: (FLGRegion *) region{
    FLGRegion *newRegion = [FLGRegion regionWithIdentifier:[self nextRegionIdentifier]
                                                      name:region.name
                                                  latitude:region.latitude
                                                 longitude:region.longitude
                                                    radius:region.radius];
    [self.regions addObject:newRegion];
}

- (void) updateRegion: (FLGRegion *) region{
    FLGRegion *regionToUpdate = [self regionWithIdentifier:region.identifier];
    regionToUpdate.name = region.name;
    regionToUpdate.latitude = region.latitude;
    regionToUpdate.longitude = region.longitude;
    regionToUpdate.radius = region.radius;
}

- (NSNumber *) nextRegionIdentifier{
    NSNumber *nextRegionIdentifier = 0;
    for (FLGRegion *region in self.regions) {
        if (region.identifier > nextRegionIdentifier) {
            nextRegionIdentifier = region.identifier;
        }
    }
    return [nextRegionIdentifier flg_numberAddingConstantValue:1];
}

- (void) removeRegionAtIndex: (NSUInteger) index{
    if (self.regions.count > index) {
        [self.regions removeObjectAtIndex:index];
    }
}

@end
