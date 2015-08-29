//
//  MyLocation.h
//  Nearbuy
//
//  Created by Javi Alzueta on 26/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@class FLGRegion;

@interface MyLocation : NSObject<MKAnnotation>

@property (strong, nonatomic, readonly) UILabel *identifierLabel;

@property (strong, nonatomic, readonly) FLGRegion *region;

- (instancetype) initWithTitle: (NSString *) title
                      subtitle: (NSString *)subtitle
                    coordinate: (CLLocationCoordinate2D) coordinate;

- (instancetype) initWithRegion: (FLGRegion *) region;

- (MKAnnotationView *)annotationView;

@end
