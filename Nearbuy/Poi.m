//
//  Poi.m
//  Nearbuy
//
//  Created by Javi Alzueta on 26/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import "Poi.h"

@implementation Poi

+ (instancetype)poiWithName: (NSString *) name
                   latitude: (NSNumber *) latitude
                  longitude: (NSNumber *) longitude
                minDistance: (NSNumber *) minDistance{
    return [[self alloc] initWithName:name
                             latitude:latitude
                            longitude:longitude
                          minDistance:minDistance];
}

- (instancetype)initWithName: (NSString *) name
                    latitude: (NSNumber *) latitude
                   longitude: (NSNumber *) longitude
                 minDistance: (NSNumber *) minDistance{
    if (self = [super init]) {
        _name = name;
        _latitude = latitude;
        _longitude = longitude;
        _minDistance = minDistance;
    }
    return self;
}

@end
