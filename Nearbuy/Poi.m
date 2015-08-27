//
//  Poi.m
//  Nearbuy
//
//  Created by Javi Alzueta on 26/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import "Poi.h"

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

- (NSString *)coordinateString{
    return [NSString stringWithFormat:@"(%@, %@)", self.latitudeString, self.longitudeString];
}

- (NSString *) latitudeString{
    return [self stringWithSixDecimalsFormattedNumber:self.latitude];
}

- (NSString *) longitudeString{
    return [self stringWithSixDecimalsFormattedNumber:self.longitude];
}

- (NSString *) stringWithSixDecimalsFormattedNumber: (NSNumber *)number{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = 6;
    return [formatter stringFromNumber:number];
}

- (BOOL) isEqualToPoi: (Poi *) poi{
    if (poi) {
        return ((self.name = poi.name) && ([self.latitude isEqualToNumber:poi.latitude]) && ([self.longitude isEqualToNumber:poi.longitude]));
    }
    return NO;
}
@end
