//
//  PoisSet.h
//  Nearbuy
//
//  Created by Javi Alzueta on 26/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Poi;
@class CLLocation;

@interface PoisSet : NSObject

@property (nonatomic, readonly) NSUInteger poisCount;
@property (copy, nonatomic, readonly) NSMutableArray *annotations;

+ (instancetype) poiSetWithArrayOfPois: (NSArray *) arrayOfPois;

- (Poi *) poiAtIndex:(NSUInteger) index;
- (Poi *) poiWithIdentifier:(NSUInteger) identifier;
- (Poi *) poiInCurrentLocation: (CLLocation *) currentLocation;

@end
