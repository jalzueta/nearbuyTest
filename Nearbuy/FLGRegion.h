//
//  FLGRegion.h
//  Nearbuy
//
//  Created by Javi Alzueta on 29/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

@import CoreLocation;

@interface FLGRegion : NSObject<NSCoding>

@property (copy, nonatomic) NSNumber *identifier;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSNumber *latitude;
@property (copy, nonatomic) NSNumber *longitude;
@property (copy, nonatomic) NSNumber *radius;
@property (nonatomic) BOOL shouldLaunchNotification;

@property (copy, nonatomic, readonly) NSString *identifierString;
@property (copy, nonatomic, readonly) NSString *latitudeString;
@property (copy, nonatomic, readonly) NSString *longitudeString;
@property (copy, nonatomic, readonly) NSString *radiusString;
@property (nonatomic, readonly) CLLocationCoordinate2D center;
@property (copy, nonatomic, readonly) NSString *centerString;

+ (instancetype) regionWithIdentifier: (NSNumber *) identifier
                                 name: (NSString *) name
                             latitude: (NSNumber *) latitude
                            longitude: (NSNumber *) longitude
                               radius: (NSNumber *) radius;

@end
