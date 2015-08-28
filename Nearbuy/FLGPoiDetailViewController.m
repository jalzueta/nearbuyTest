//
//  FLGPoiDetailViewController.m
//  Nearbuy
//
//  Created by Javi Alzueta on 27/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import "FLGPoiDetailViewController.h"
#import "Poi.h"
#import "Constants.h"
#import "NSString+FLGStringUtils.h"

@interface FLGPoiDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *poiNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *poiLatitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *poiLongitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *poiMinDistanceTextField;

@property (strong, nonatomic) UITextField *currentTextField;
@property (strong, nonatomic) UIToolbar *firstItemAccesoryKBView;
@property (strong, nonatomic) UIToolbar *middleItemAccesoryKBView;
@property (strong, nonatomic) UIToolbar *lastItemAccesoryKBView;

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
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createItemAccesoryKBViews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isNewPoi) {
        self.title = @"New Poi";
    }else{
        self.title = @"Poi edition";
        [self populateScreen];
    }
    [self configTextFields];
}

#pragma mark - Actions
- (IBAction)backgroundViewDidPressed:(id)sender {
    [self hideKeyboard];
}

- (IBAction)getMyLocationDidPressed:(id)sender {
    if (self.currentLocation) {
        [self loadPoiWithScreenValues];
        self.poi.latitude = @(self.currentLocation.coordinate.latitude);
        self.poi.longitude = @(self.currentLocation.coordinate.longitude);
        [self populateScreen];
    }
}
- (IBAction)savePoiDidPressed:(id)sender {
    [self savePoiAndReturn];
}

#pragma mark - Utils
- (void) configTextFields{
    self.poiNameTextField.delegate = self;
    self.poiLatitudeTextField.delegate = self;
    self.poiLongitudeTextField.delegate = self;
    self.poiMinDistanceTextField.delegate = self;

    self.poiNameTextField.inputAccessoryView = self.firstItemAccesoryKBView;
    self.poiLatitudeTextField.inputAccessoryView = self.middleItemAccesoryKBView;
    self.poiLongitudeTextField.inputAccessoryView = self.middleItemAccesoryKBView;
    self.poiMinDistanceTextField.inputAccessoryView = self.lastItemAccesoryKBView;
}

- (void) populateScreen{
    self.poiNameTextField.text = self.poi.name;
    self.poiLatitudeTextField.text = self.poi.latitudeString;
    self.poiLongitudeTextField.text = self.poi.longitudeString;
    self.poiMinDistanceTextField.text = self.poi.minDistanceString;
}

- (void) loadPoiWithScreenValues{
    self.poi.name = self.poiNameTextField.text;
    self.poi.latitude = [self.poiLatitudeTextField.text flg_numberWithString];
    self.poi.longitude = [self.poiLongitudeTextField.text flg_numberWithString];
    self.poi.minDistance = [self.poiMinDistanceTextField.text flg_numberWithString];
}

- (void) hideKeyboard{
    [self.currentTextField resignFirstResponder];
}

- (void) savePoiAndReturn{
    [self loadPoiWithScreenValues];
    if ([self allDataAssigned]) {
        [self.delegate poiDetailViewController:self
                             didPressedSavePoi:self.poi];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIAlertController *missingPoiDataAlertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"MissingPoiDataTitle", nil)
                                                                                              message:NSLocalizedString(@"MissingPoiDataMessage", nil)
                                                                                       preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Ok", nil)
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action) {}];
        
        [missingPoiDataAlertController addAction: okAction];
        
        [self presentViewController:missingPoiDataAlertController
                           animated:YES
                         completion:nil];
    }
}

- (BOOL) allDataAssigned{
    return (![self.poi.name isEqual:nil] && ![self.poi.name isEqual:@""] && ![self.poi.latitude isEqual:nil] && ![self.poi.longitude isEqual:nil] && ![self.poi.minDistance isEqual:nil]);
}

#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.currentTextField = textField;
    return YES;
}


#pragma mark - TextFields accesory view
- (void) createItemAccesoryKBViews{
    self.firstItemAccesoryKBView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    self.firstItemAccesoryKBView.items = [NSArray arrayWithObjects:[self nextBtn], [self flexBtn], [self doneBtn], nil];
    [self configInputAccesoryView:self.firstItemAccesoryKBView];
    
    self.middleItemAccesoryKBView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    self.middleItemAccesoryKBView.items = [NSArray arrayWithObjects:[self prevBtn], [self nextBtn], [self flexBtn], [self doneBtn], nil];
    [self configInputAccesoryView:self.middleItemAccesoryKBView];
    
    self.lastItemAccesoryKBView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    self.lastItemAccesoryKBView.items = [NSArray arrayWithObjects:[self prevBtn], [self flexBtn], [self doneBtn], [self sendBtn], nil];
    
    [self configInputAccesoryView:self.lastItemAccesoryKBView];
}

- (void) configInputAccesoryView: (UIToolbar *) inputAccesoryView{
    for (UIBarButtonItem *buttonItem in inputAccesoryView.items) {
        buttonItem.tintColor = KB_ACCESORY_VIEW_BUTTONS_TINT_COLOR;
    }
    inputAccesoryView.barStyle = UIBarStyleBlackOpaque;
    [inputAccesoryView sizeToFit];
}

- (UIBarButtonItem *) prevBtn{
    return [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Previous", nil)
                                            style:UIBarButtonItemStylePlain
                                           target:self
                                           action:@selector(goToPreviousItem)];
}

- (UIBarButtonItem *) nextBtn{
    return [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Next", nil)
                                            style:UIBarButtonItemStylePlain
                                           target:self
                                           action:@selector(goToNextItem)];
}

- (UIBarButtonItem *) doneBtn{
    return [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil)
                                            style:UIBarButtonItemStylePlain
                                           target:self
                                           action:@selector(endForm)];
}

- (UIBarButtonItem *) sendBtn{
    return [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil)
                                            style:UIBarButtonItemStylePlain
                                           target:self
                                           action:@selector(sendForm)];
}

- (UIBarButtonItem *) flexBtn{
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                         target:nil
                                                         action:nil];;
}

- (void) goToPreviousItem{
    UITextField *previousTextField;
    if (self.currentTextField == self.poiLatitudeTextField) {
        previousTextField = self.poiNameTextField;
    }else if (self.currentTextField == self.poiLongitudeTextField) {
        previousTextField = self.poiLatitudeTextField;
    }else{
        previousTextField = self.poiLongitudeTextField;
    }
    [previousTextField becomeFirstResponder];
}

- (void) goToNextItem{
    UITextField *nextTextField;
    if (self.currentTextField == self.poiNameTextField) {
        nextTextField = self.poiLatitudeTextField;
    }else if (self.currentTextField == self.poiLatitudeTextField) {
        nextTextField = self.poiLongitudeTextField;
    }else{
        nextTextField = self.poiMinDistanceTextField;
    }
    [nextTextField becomeFirstResponder];
}

- (void) endForm{
    [self hideKeyboard];
}

- (void) sendForm{
    [self hideKeyboard];
    [self savePoiAndReturn];
}

@end
