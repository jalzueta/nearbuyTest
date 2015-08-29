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

#pragma mark - getters
- (NSString *)identifierString{
    return [NSString stringWithFormat:@"%@", self.identifier];
}

- (NSString *) latitudeString{
    return [self.latitude flg_stringWithNumberOfFractionDigits:6];
}

- (NSString *) longitudeString{
    return [self.longitude flg_stringWithNumberOfFractionDigits:6];
}

- (NSString *)radiusString{
    return [_radius flg_stringWithNumberOfFractionDigits:0];
}

- (NSString *)centerString{
    return [NSString stringWithFormat:@"(%@, %@)", self.latitudeString, self.longitudeString];
}

- (CLLocationCoordinate2D) center{
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
}

#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_identifier forKey:@"identifier"];
    [encoder encodeObject:_name forKey:@"name"];
    [encoder encodeObject:_latitude forKey:@"latitude"];
    [encoder encodeObject:_latitude forKey:@"longitude"];
    [encoder encodeObject:_radius forKey:@"radius"];
    [encoder encodeBool:_shouldLaunchNotification forKey:@"shouldLaunchNotification"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        _identifier = [decoder decodeObjectForKey:@"identifier"];
        _name = [decoder decodeObjectForKey:@"name"];
        _latitude = [decoder decodeObjectForKey:@"latitude"];
        _longitude = [decoder decodeObjectForKey:@"longitude"];
        _radius = [decoder decodeObjectForKey:@"radius"];
        _shouldLaunchNotification = [decoder decodeBoolForKey:@"shouldLaunchNotification"];
    }
    return self;
}

@end
