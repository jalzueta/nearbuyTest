//
//  FLGRegionTableViewCell.h
//  Nearbuy
//
//  Created by Javi Alzueta on 26/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FLGRegion;

@interface FLGRegionTableViewCell : UITableViewCell

+ (NSString *)cellId;

- (void) configureWithRegion: (FLGRegion *)region;

@end
