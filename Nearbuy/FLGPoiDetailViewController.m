//
//  FLGPoiDetailViewController.m
//  Nearbuy
//
//  Created by Javi Alzueta on 27/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import "FLGPoiDetailViewController.h"
#import "Poi.h"

@interface FLGPoiDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *poiNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *poiLatitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *poiLongitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *poiMinDistanceTextField;

@property(strong, nonatomic, readonly) Poi *poi;
@property(nonatomic, readonly) BOOL isNewPoi;

@end

@implementation FLGPoiDetailViewController

#pragma mark - Init
- (id)initWithPoi: (Poi *) poi
         isNewPoi: (BOOL) isNewPoi{
    if (self = [super initWithNibName:nil
                               bundle:nil]) {
        _poi = poi;
        _isNewPoi = isNewPoi;
    }
    return self;
}

- (id)initWithPoi: (Poi *) poi{
    return [self initWithPoi:poi
                    isNewPoi:NO];
}

- (id)initForNewPoi{
    return [self initWithPoi:[[Poi alloc] init]
                    isNewPoi:YES];
}

#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isNewPoi) {
        self.title = @"New Poi";
    }else{
        self.title = @"Poi edition";
        [self populateScreen];
    }
}

#pragma mark - Actions
- (IBAction)getMyLocationDidPressed:(id)sender {
    if (self.currentLocation) {
        self.poi.latitude = @(self.currentLocation.coordinate.latitude);
        self.poi.longitude = @(self.currentLocation.coordinate.longitude);
        [self populateScreen];
    }
}
- (IBAction)savePoiDidPressed:(id)sender {
    [self loadPoiWithScreenValues];
    [self.delegate poiDetailViewController:self
                         didPressedSavePoi:self.poi];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Utils
- (void) populateScreen{
    self.poiNameTextField.text = self.poi.name;
    self.poiLatitudeTextField.text = self.poi.latitudeString;
    self.poiLongitudeTextField.text = self.poi.longitudeString;
    self.poiMinDistanceTextField.text = [NSString stringWithFormat:@"%@", self.poi.minDistance];
}

- (void) loadPoiWithScreenValues{
    self.poi.name = self.poiNameTextField.text;
    self.poi.latitude = [self numberFormattedFromString:self.poiLatitudeTextField.text];
    self.poi.longitude = [self numberFormattedFromString:self.poiLongitudeTextField.text];
    self.poi.minDistance = [self numberFormattedFromString:self.poiMinDistanceTextField.text];
}

- (NSNumber *) numberFormattedFromString: (NSString *) numericString{
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    return [f numberFromString:numericString];
}

@end
