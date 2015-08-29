//
//  FLGRegionTableViewCell.m
//  Nearbuy
//
//  Created by Javi Alzueta on 26/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import "FLGRegionTableViewCell.h"
#import "FLGRegion.h"
#import "Constants.h"

@interface FLGRegionTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *identifierLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *coordinateLabel;

@end

@implementation FLGRegionTableViewCell

+ (NSString *)cellId{
    return NSStringFromClass(self);
}

- (void) configureWithRegion: (FLGRegion *)region{
    self.identifierLabel.text = region.identifierString;
    self.nameLabel.text = region.name;
    self.coordinateLabel.text = region.centerString;
    
    [self setAppearanceForRegion:region];
}

- (void) setAppearanceForRegion: (FLGRegion *) region{
    UIColor *backgroundColor;
    if (region.shouldLaunchNotification) {
        backgroundColor = CELL_COLOR_OFF;
    }else{
        backgroundColor = CELL_COLOR_ON;
    }
    self.contentView.backgroundColor = backgroundColor;
}

- (void) prepareForReuse{
    [super prepareForReuse];
    self.nameLabel.text = nil;
    self.coordinateLabel.text = nil;
}

@end
