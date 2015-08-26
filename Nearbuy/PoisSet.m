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

@interface PoisSet ()

@property(copy, nonatomic, readonly) NSArray *arrayOfPois;

@end

@implementation PoisSet

+ (instancetype) poiSetWithArrayOfPois: (NSArray *) arrayOfPois{
    return [[self alloc] initWithArrayOfPois:arrayOfPois];
}

- (instancetype) initWithArrayOfPois: (NSArray *) arrayOfPois{
    if (self = [super init]) {
        _arrayOfPois = arrayOfPois;
    }
    return self;
}

- (NSUInteger)poisCount{
    return self.arrayOfPois.count;
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
    for (Poi *poi in self.arrayOfPois) {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[poi.latitude doubleValue]
                                                          longitude:[poi.longitude doubleValue]];
        if ([currentLocation distanceFromLocation:location] <= [poi.minDistance doubleValue]) {
            NSLog(@"Distance to %@: %f", poi.name, [currentLocation distanceFromLocation:location]);
            detectedPoi = poi;
            break;
        }
    }
    return detectedPoi;
}

@end
