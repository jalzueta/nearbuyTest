//
//  MyLocation.m
//  Nearbuy
//
//  Created by Javi Alzueta on 26/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import "MyLocation.h"
#import "Constants.h"
#import "FLGRegion.h"

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

- (instancetype) initWithRegion: (FLGRegion *) region{
    if (self = [super init]) {
        _title = region.name;
        _subtitle = region.coordinateString;
        _coordinate = CLLocationCoordinate2DMake([region.latitude doubleValue], [region.longitude doubleValue]);
        _region = region;
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
    identifierLabel.text = self.region.identifierString;
    identifierLabel.textAlignment = NSTextAlignmentCenter;
    identifierLabel.font = MAP_ANNOTATIONS_IDENTIFIER_FONT;
    identifierLabel.textColor = DARK_ORANGE_COLOR;
    [annotationView addSubview:identifierLabel];
    
    return annotationView;
}

@end
