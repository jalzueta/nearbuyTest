//
//  FLGPoiTableViewCell.m
//  Nearbuy
//
//  Created by Javi Alzueta on 26/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import "FLGPoiTableViewCell.h"
#import "Poi.h"

@interface FLGPoiTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *identifierLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *coordinateLabel;

@end

@implementation FLGPoiTableViewCell

+ (NSString *)cellId{
    return NSStringFromClass(self);
}

- (void) configureWithPoi: (Poi *)poi{
    self.identifierLabel.text = poi.identifierString;
    self.nameLabel.text = poi.name;
    self.coordinateLabel.text = poi.coordinateString;
}

- (void) prepareForReuse{
    [super prepareForReuse];
    self.nameLabel.text = nil;
    self.coordinateLabel.text = nil;
}

@end
