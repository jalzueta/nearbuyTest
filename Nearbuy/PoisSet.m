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

@end

@implementation PoisSet

+ (instancetype) poiSetWithArrayOfPois: (NSMutableArray *) arrayOfPois{
    return [[self alloc] initWithArrayOfPois:arrayOfPois];
}

- (instancetype) initWithArrayOfPois: (NSMutableArray *) arrayOfPois{
    if (self = [super init]) {
        _arrayOfPois = arrayOfPois;
        _annotations = [NSMutableArray new];
    }
    return self;
}

- (NSUInteger)poisCount{
    return self.arrayOfPois.count;
}

- (NSMutableArray *)annotations{
    [_annotations removeAllObjects];
    for (Poi *poi in self.arrayOfPois) {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([poi.latitude doubleValue], [poi.longitude doubleValue]);
        MyLocation *annotation = [[MyLocation alloc]initWithTitle:poi.name
                                                         subtitle:poi.coordinateString
                                                       coordinate:coordinate];
        [_annotations addObject:annotation];
    }
    return _annotations;
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
    return nextPoiIdentifier;
}

@end
