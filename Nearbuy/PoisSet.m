//
//  PoisSet.m
//  Nearbuy
//
//  Created by Javi Alzueta on 26/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import "PoisSet.h"
#import "Poi.h"
@import CoreLocation;
#import "MyLocation.h"

@interface PoisSet ()

@property(copy, nonatomic, readonly) NSMutableArray *arrayOfPois;
@property(copy, nonatomic) NSMutableArray *annotations;
@property(copy, nonatomic) NSMutableArray *regions;
@property(copy, nonatomic) NSMutableArray *overlays;

@end

@implementation PoisSet

+ (instancetype) poiSetWithTrickValues{
    return [[self alloc]initWithTrickValues];
}

+ (instancetype) poiSetWithArrayOfPois: (NSMutableArray *) arrayOfPois{
    return [[self alloc] initWithArrayOfPois:arrayOfPois];
}

- (instancetype) initWithArrayOfPois: (NSMutableArray *) arrayOfPois{
    if (self = [super init]) {
        _arrayOfPois = arrayOfPois;
        _annotations = [NSMutableArray new];
        _regions = [NSMutableArray new];
        _overlays = [NSMutableArray new];
    }
    return self;
}

- (instancetype) initWithTrickValues{
    Poi *poi1 = [Poi poiWithIdentifier:1
                                  name:@"Mercadona"
                              latitude:@(42.794589)
                             longitude:@(-1.613783)
                           minDistance:@50];
    
    Poi *poi2 = [Poi poiWithIdentifier:2
                                  name:@"Casa"
                              latitude:@(42.794820)
                             longitude:@(-1.616424)
                           minDistance:@100];
    
    Poi *poi3 = [Poi poiWithIdentifier:3
                                  name:@"La Hacienda"
                              latitude:@(42.796038)
                             longitude:@(-1.613448)
                           minDistance:@50];
    
    Poi *poi4 = [Poi poiWithIdentifier:4
                                  name:@"Navarra Padel"
                              latitude:@(42.795778)
                             longitude:@(-1.613732)
                           minDistance:@50];
    
    Poi *poi5 = [Poi poiWithIdentifier:5
                                  name:@"Conasa"
                              latitude:@(42.796912)
                             longitude:@(-1.613313)
                           minDistance:@50];
    
    Poi *poi6 = [Poi poiWithIdentifier:6
                                  name:@"Eroski"
                              latitude:@(42.798044)
                             longitude:@(-1.613447)
                           minDistance:@50];
    
    Poi *poi7 = [Poi poiWithIdentifier:7
                                  name:@"Irulegui"
                              latitude:@(42.792406)
                             longitude:@(-1.614967)
                           minDistance:@150];
    
    Poi *poi8 = [Poi poiWithIdentifier:8
                                  name:@"Farmacia Maria"
                              latitude:@(42.789182)
                             longitude:@(-1.616590)
                           minDistance:@50];
    
    Poi *poi9 = [Poi poiWithIdentifier:9
                                  name:@"Tienda Padel/Tenis"
                              latitude:@(42.788825)
                             longitude:@(-1.617003)
                           minDistance:@50];
    
    Poi *poi10 = [Poi poiWithIdentifier:10
                                   name:@"Ayuntamiento"
                               latitude:@(42.789294)
                              longitude:@(-1.617413)
                            minDistance:@50];
    
    return [self initWithArrayOfPois: [NSMutableArray arrayWithObjects:poi1,
                                       poi2,
                                       poi3,
                                       poi4,
                                       poi5,
                                       poi6,
                                       poi7,
                                       poi8,
                                       poi9,
                                       poi10,
                                       nil]];
}

- (NSUInteger)poisCount{
    return self.arrayOfPois.count;
}

- (NSMutableArray *)annotations{
    [_annotations removeAllObjects];
    for (Poi *poi in self.arrayOfPois) {
        MyLocation *annotation = [[MyLocation alloc]initWithPoi:poi];
        [_annotations addObject:annotation];
    }
    return _annotations;
}

- (NSMutableArray *)regions{
    [_regions removeAllObjects];
    for (Poi *poi in self.arrayOfPois) {
        CLRegion *region = [[CLCircularRegion alloc] initWithCenter:poi.center
                                                             radius:[poi.minDistance doubleValue]
                                                         identifier:poi.identifierString];
        region.notifyOnEntry = YES;
        region.notifyOnExit = YES;
        [_regions addObject:region];
    }
    return _regions;
}

- (NSMutableArray *)overlays{
    [_overlays removeAllObjects];
    for (Poi *poi in self.arrayOfPois) {
        MKCircle *circle = [MKCircle circleWithCenterCoordinate:poi.center
                                                         radius:[poi.minDistance doubleValue]];
        [_overlays addObject:circle];
    }
    return _overlays;
}


- (Poi *) poiAtIndex:(NSUInteger) index{
    if (index < self.arrayOfPois.count) {
        return [self.arrayOfPois objectAtIndex:index];
    }
    return nil;
}

- (Poi *) poiWithIdentifier:(NSUInteger) identifier{
    Poi *matchedPoi;
    for (Poi *poi in self.arrayOfPois) {
        if (identifier == poi.identifier) {
            matchedPoi = poi;
            break;
        }
    }
    return matchedPoi;
}

- (Poi *) poiInCurrentLocation: (CLLocation *) currentLocation{
    Poi *detectedPoi;
    CLLocationDirection minDistance = 1000;
    for (Poi *poi in self.arrayOfPois) {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[poi.latitude doubleValue]
                                                          longitude:[poi.longitude doubleValue]];
        CLLocationDirection distance = [currentLocation distanceFromLocation:location];
        if (distance <= [poi.minDistance doubleValue]) {
            if (distance < minDistance) {
                detectedPoi = poi;
            }
//            NSLog(@"Distance to %@: %f", poi.name, [currentLocation distanceFromLocation:location]);
        }
    }
    return detectedPoi;
}

- (void) addPoi: (Poi *) poi{
    Poi *newPoi = [Poi poiWithIdentifier:[self nextPoiIdentifier]
                                    name:poi.name
                                latitude:poi.latitude
                               longitude:poi.longitude
                             minDistance:poi.minDistance];
    [self.arrayOfPois addObject:newPoi];
}

- (void) updatePoi: (Poi *) poi{
    Poi *poiToUpdate = [self poiWithIdentifier:poi.identifier];
    poiToUpdate.name = poi.name;
    poiToUpdate.latitude = poi.latitude;
    poiToUpdate.longitude = poi.longitude;
    poiToUpdate.minDistance = poi.minDistance;
}

- (NSUInteger)nextPoiIdentifier{
    NSUInteger nextPoiIdentifier = 0;
    for (Poi *poi in self.arrayOfPois) {
        if (poi.identifier > nextPoiIdentifier) {
            nextPoiIdentifier = poi.identifier;
        }
    }
    return ++nextPoiIdentifier;
}

- (void) removePoiAtIndex: (NSUInteger) index{
    if (self.arrayOfPois.count > index) {
        [self.arrayOfPois removeObjectAtIndex:index];
    }
}

@end
