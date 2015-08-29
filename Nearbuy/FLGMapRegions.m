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

//@property(copy, nonatomic, readonly) NSMutableArray *regions;
@property(copy, nonatomic) NSMutableArray *annotations;
@property(copy, nonatomic) NSMutableArray *clRegions;
@property(copy, nonatomic) NSMutableArray *overlays;

@end

@implementation FLGMapRegions

+ (instancetype) mapRegionsWithTrickValues{
    return [[self alloc]initWithTrickValues];
}

+ (instancetype) mapRegionsWithRegions: (NSMutableArray *)regions{
    return [[self alloc]initWithRegions:regions];
}

- (instancetype)initWithRegions: (NSMutableArray *)regions{
    if (self = [super init]) {
        _regions = regions;
        _annotations = [NSMutableArray new];
        _clRegions = [NSMutableArray new];
        _overlays = [NSMutableArray new];
    }
    return self;
}

- (instancetype) initWithTrickValues{
    FLGRegion *region1 = [FLGRegion regionWithIdentifier:@1
                                                    name:@"Mercadona"
                                                latitude:@(42.794589)
                                               longitude:@(-1.613783)
                                                  radius:@50];
    
    FLGRegion *region2 = [FLGRegion regionWithIdentifier:@2
                                                    name:@"Casa"
                                                latitude:@(42.794820)
                                               longitude:@(-1.616424)
                                                  radius:@100];
    
    FLGRegion *region3 = [FLGRegion regionWithIdentifier:@3
                                                    name:@"La Hacienda"
                                                latitude:@(42.796038)
                                               longitude:@(-1.613448)
                                                  radius:@50];
    
    FLGRegion *region4 = [FLGRegion regionWithIdentifier:@4
                                                    name:@"Navarra Padel"
                                                latitude:@(42.795778)
                                               longitude:@(-1.613732)
                                                  radius:@50];
    
    FLGRegion *region5 = [FLGRegion regionWithIdentifier:@5
                                                    name:@"Conasa"
                                                latitude:@(42.796912)
                                               longitude:@(-1.613313)
                                                  radius:@50];
    
    FLGRegion *region6 = [FLGRegion regionWithIdentifier:@6
                                                    name:@"Eroski"
                                                latitude:@(42.798044)
                                               longitude:@(-1.613447)
                                                  radius:@50];
    
    FLGRegion *region7 = [FLGRegion regionWithIdentifier:@7
                                                    name:@"Irulegui"
                                                latitude:@(42.792406)
                                               longitude:@(-1.614967)
                                                  radius:@150];
    
    FLGRegion *region8 = [FLGRegion regionWithIdentifier:@8
                                                    name:@"Farmacia Maria"
                                                latitude:@(42.789182)
                                               longitude:@(-1.616590)
                                                  radius:@50];
    
    FLGRegion *region9 = [FLGRegion regionWithIdentifier:@9
                                                    name:@"Tienda Padel/Tenis"
                                                latitude:@(42.788825)
                                               longitude:@(-1.617003)
                                                  radius:@50];
    
    FLGRegion *region10 = [FLGRegion regionWithIdentifier:@10
                                                     name:@"Ayuntamiento"
                                                 latitude:@(42.789294)
                                                longitude:@(-1.617413)
                                                   radius:@50];
    
    return [self initWithRegions: [NSMutableArray arrayWithObjects:region1,
                                   region2,
                                   region3,
                                   region4,
                                   region5,
                                   region6,
                                   region7,
                                   region8,
                                   region9,
                                   region10,
                                   nil]];
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
