//
//  FLGRegionDetailViewController.h
//  Nearbuy
//
//  Created by Javi Alzueta on 27/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import "FLGRegionGeofencingViewController.h"
@class FLGRegion;

@protocol RegionDetailViewControllerDelegate;

@interface FLGRegionDetailViewController : FLGRegionGeofencingViewController<UITextFieldDelegate>

@property(strong, nonatomic, readonly) FLGRegion *region;
@property (weak, nonatomic) id<RegionDetailViewControllerDelegate> delegate;

- (id)initWithRegion: (FLGRegion *) region;
- (id)initForNewRegion;

@end

@protocol RegionDetailViewControllerDelegate <NSObject>

- (void) regionDetailViewController: (FLGRegionDetailViewController *)regionDetailViewController didPressedSaveRegion: (FLGRegion *) region;

@end