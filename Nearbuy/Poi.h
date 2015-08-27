//
//  Poi.h
//  Nearbuy
//
//  Created by Javi Alzueta on 26/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Poi : NSObject

@property (nonatomic, readonly) NSUInteger identifier;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSNumber *latitude;
@property (copy, nonatomic) NSNumber *longitude;
@property (copy, nonatomic) NSNumber *minDistance;
@property (copy, nonatomic, readonly) NSString *latitudeString;
@property (copy, nonatomic, readonly) NSString *longitudeString;
@property (copy, nonatomic, readonly) NSString *coordinateString;

+ (instancetype) poiWithIdentifier: (NSUInteger) identifier
                             name: (NSString *) name
                         latitude: (NSNumber *) latitude
                        longitude: (NSNumber *) longitude
                      minDistance: (NSNumber *) minDistance;

- (BOOL) isEqualToPoi: (Poi *) poi;

@end
