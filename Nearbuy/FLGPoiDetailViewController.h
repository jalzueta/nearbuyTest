//
//  FLGPoiDetailViewController.h
//  Nearbuy
//
//  Created by Javi Alzueta on 27/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import "FLGLocationCoincidenceCheckerViewController.h"
@class Poi;

@protocol PoiDetailViewControllerDelegate;

@interface FLGPoiDetailViewController : FLGLocationCoincidenceCheckerViewController

@property (weak, nonatomic) id<PoiDetailViewControllerDelegate> delegate;

- (id)initWithPoi: (Poi *) poi;
- (id)initForNewPoi;

@end

@protocol PoiDetailViewControllerDelegate <NSObject>

- (void) poiDetailViewController: (FLGPoiDetailViewController *)poiDetailViewController didPressedSavePoi: (Poi *) poi;

@end