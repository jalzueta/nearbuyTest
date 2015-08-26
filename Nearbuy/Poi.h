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
@property (copy, nonatomic, readonly) NSString *name;
@property (copy, nonatomic, readonly) NSNumber *latitude;
@property (copy, nonatomic, readonly) NSNumber *longitude;
@property (copy, nonatomic, readonly) NSString *coordinateString;
@property (copy, nonatomic, readonly) NSNumber *minDistance;

+ (instancetype) poiWithIdentifier: (NSUInteger) identifier
                             name: (NSString *) name
                         latitude: (NSNumber *) latitude
                        longitude: (NSNumber *) longitude
                      minDistance: (NSNumber *) minDistance;

@end
