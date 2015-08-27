//
//  MyLocation.m
//  Nearbuy
//
//  Created by Javi Alzueta on 26/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import "MyLocation.h"
#import "Constants.h"
#import "Poi.h"

@interface MyLocation ()

@property (strong, nonatomic, readonly) Poi *poi;

@end

@implementation MyLocation

- (instancetype) initWithTitle: (NSString *) title
                      subtitle: (NSString *)subtitle
                    coordinate: (CLLocationCoordinate2D) coordinate
                           poi: (Poi *) poi{
    if (self = [super init]) {
        _title = title;
        _subtitle = subtitle;
        _coordinate = coordinate;
        _poi = poi;
    }
    return self;
}

#pragma mark - MKAnnotation
@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize coordinate = _coordinate;

- (MKAnnotationView *)annotationView{
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self
                                                                    reuseIdentifier:@"MyCustomAnnotation"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@"gps_map_icon"];
    UILabel *identifierLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 1, 30, 30)];
    identifierLabel.text = self.poi.identifierString;
    identifierLabel.textAlignment = NSTextAlignmentCenter;
    identifierLabel.font = MAP_ANNOTATIONS_IDENTIFIER_FONT;
    identifierLabel.textColor = DARK_ORANGE_COLOR;
    [annotationView addSubview:identifierLabel];
    
    return annotationView;
}

@end
