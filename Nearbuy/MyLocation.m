//
//  MyLocation.m
//  Nearbuy
//
//  Created by Javi Alzueta on 26/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import "MyLocation.h"

@implementation MyLocation

- (instancetype) initWithTitle: (NSString *) title
                      subtitle: (NSString *)subtitle
                    coordinate: (CLLocationCoordinate2D) coordinate{
    if (self = [super init]) {
        _title = title;
        _subtitle = subtitle;
        _coordinate = coordinate;
    }
    return self;
}

#pragma mark - MKAnnotation
@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize coordinate = _coordinate;

@end
