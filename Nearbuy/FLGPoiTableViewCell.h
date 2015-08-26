//
//  FLGPoiTableViewCell.h
//  Nearbuy
//
//  Created by Javi Alzueta on 26/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Poi;

@interface FLGPoiTableViewCell : UITableViewCell

+ (NSString *)cellId;

- (void) configureWithPoi: (Poi *)poi;

@end
