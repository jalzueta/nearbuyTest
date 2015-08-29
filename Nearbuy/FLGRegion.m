//
//  FLGRegion.m
//  Nearbuy
//
//  Created by Javi Alzueta on 29/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import "FLGRegion.h"
#import "NSNumber+FLGNumberUtils.h"

@interface FLGRegion ()

@property (nonatomic) CLLocationCoordinate2D center;

@end

@implementation FLGRegion

+ (instancetype) regionWithIdentifier: (NSNumber *) identifier
                                 name: (NSString *) name
                             latitude: (NSNumber *) latitude
                            longitude: (NSNumber *) longitude
                               radius: (NSNumber *) radius{
    return [[self alloc] initWithIdentifier:identifier
                                       name:name
                                   latitude:latitude
                                  longitude:longitude
                                     radius:radius];
}

- (instancetype) initWithIdentifier: (NSNumber *) identifier
                               name: (NSString *) name
                           latitude: (NSNumber *) latitude
                          longitude: (NSNumber *) longitude
                             radius: (NSNumber *) radius{
    if (self = [super init]) {
        _identifier = identifier;
        _name = name;
        _latitude = latitude;
        _longitude = longitude;
        _radius = radius;
        _shouldLaunchNotification = YES;
        _center = CLLocationCoordinate2DMake([_latitude doubleValue], [_longitude doubleValue]);
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    if (self = [super initWithDictionary:dictionaryValue error:error]){
        _shouldLaunchNotification = YES;
    }
    return self;
}

#pragma mark - MTLJSONSerializing
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"identifier" : @"identifier",
             @"name" : @"name",
             @"latitude" : @"latitude",
             @"longitude" : @"longitude",
             @"radius" : @"radius"
             };
}

#pragma mark - getters
- (NSString *)identifierString{
    return [NSString stringWithFormat:@"%@", self.identifier];
}

- (NSString *) latitudeString{
    if (self.latitude) {
        return [self.latitude flg_stringWithNumberOfFractionDigits:6];
    }
    return @"";
}

- (NSString *) longitudeString{
    return [self.longitude flg_stringWithNumberOfFractionDigits:6];
}

- (NSString *)radiusString{
    return [self.radius flg_stringWithNumberOfFractionDigits:0];
}

- (NSString *)coordinateString{
    return [NSString stringWithFormat:@"(%@, %@)", self.latitudeString, self.longitudeString];
}

- (CLLocationCoordinate2D) center{
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
}

@end
