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
    return [NSString stringWithFormat:@"%@", _identifier];
}

- (NSString *) latitudeString{
    if (self.latitude) {
        return [_latitude flg_stringWithNumberOfFractionDigits:6];
    }
    return @"";
}

- (NSString *) longitudeString{
    return [_longitude flg_stringWithNumberOfFractionDigits:6];
}

- (NSString *)radiusString{
    return [_radius flg_stringWithNumberOfFractionDigits:0];
}

- (NSString *)centerString{
    return [NSString stringWithFormat:@"(%@, %@)", self.latitudeString, self.longitudeString];
}

- (CLLocationCoordinate2D) center{
    return CLLocationCoordinate2DMake([_latitude doubleValue], [_longitude doubleValue]);
}

@end
