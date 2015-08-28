//
//  ManagedRegion.h
//  Nearbuy
//
//  Created by Javi Alzueta on 28/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ManagedRegion : NSManagedObject

@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * insertionDate;
@property (nonatomic, retain) NSNumber * shouldLaunchNotification;
@property (nonatomic, retain) NSNumber * radius;

+ (NSFetchRequest *)fetchRequestForAllPois;

@end
