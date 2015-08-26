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

@property(copy, nonatomic, readonly) NSArray *arrayOfPois;
@property(copy, nonatomic) NSMutableArray *annotations;

@end

@implementation PoisSet

+ (instancetype) poiSetWithArrayOfPois: (NSArray *) arrayOfPois{
    return [[self alloc] initWithArrayOfPois:arrayOfPois];
}

- (instancetype) initWithArrayOfPois: (NSArray *) arrayOfPois{
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
