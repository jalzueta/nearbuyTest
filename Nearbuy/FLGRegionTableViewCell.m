//
//  FLGRegionTableViewCell.m
//  Nearbuy
//
//  Created by Javi Alzueta on 26/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import "FLGRegionTableViewCell.h"
#import "FLGRegion.h"

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
//    self.coordinateLabel.text = region.centerString;
}

- (void) prepareForReuse{
    [super prepareForReuse];
    self.nameLabel.text = nil;
    self.coordinateLabel.text = nil;
}

@end
