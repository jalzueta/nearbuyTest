//
//  MyLocation.h
//  Nearbuy
//
//  Created by Javi Alzueta on 26/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@class Poi;

@interface MyLocation : NSObject<MKAnnotation>

- (instancetype) initWithTitle: (NSString *) title
                      subtitle: (NSString *)subtitle
                    coordinate: (CLLocationCoordinate2D) coordinate
                           poi: (Poi *) poi;

- (MKAnnotationView *)annotationView;

@end
