//
//  Poi.m
//  Nearbuy
//
//  Created by Javi Alzueta on 26/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import "Poi.h"
#import "NSNumber+FLGNumberUtils.h"

@implementation Poi

+ (instancetype) poiWithIdentifier: (NSUInteger) identifier
                             name: (NSString *) name
                         latitude: (NSNumber *) latitude
                        longitude: (NSNumber *) longitude
                      minDistance: (NSNumber *) minDistance{
    return [[self alloc] initWithIdentifier:identifier
                                       name:name
                                   latitude:latitude
                                  longitude:longitude
                                minDistance:minDistance];
}

- (instancetype) initWithIdentifier: (NSUInteger) identifier
                              name: (NSString *) name
                          latitude: (NSNumber *) latitude
                         longitude: (NSNumber *) longitude
                       minDistance: (NSNumber *) minDistance{
    if (self = [super init]) {
        _identifier = identifier;
        _name = name;
        _latitude = latitude;
        _longitude = longitude;
        _minDistance = minDistance;
    }
    return self;
}

- (NSString *)identifierString{
    return [NSString stringWithFormat:@"%lu", self.identifier];
}

- (NSString *) latitudeString{
    return [self.latitude flg_stringWithNumberOfFractionDigits:6];
}

- (NSString *) longitudeString{
    return [self.longitude flg_stringWithNumberOfFractionDigits:6];
}

- (NSString *)minDistanceString{
    return [self.minDistance flg_stringWithNumberOfFractionDigits:0];
}

- (NSString *)coordinateString{
    return [NSString stringWithFormat:@"(%@, %@)", self.latitudeString, self.longitudeString];
}

- (BOOL) isEqualToPoi: (Poi *) poi{
    if (poi) {
        return ((self.identifier == poi.identifier) && (self.name == poi.name) && ([self.latitude isEqualToNumber:poi.latitude]) && ([self.longitude isEqualToNumber:poi.longitude]));
    }
    return NO;
}
@end
