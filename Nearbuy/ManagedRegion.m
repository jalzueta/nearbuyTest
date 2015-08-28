//
//  ManagedRegion.m
//  Nearbuy
//
//  Created by Javi Alzueta on 28/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import "ManagedRegion.h"

@implementation ManagedRegion

@dynamic identifier;
@dynamic name;
@dynamic insertionDate;
@dynamic shouldLaunchNotification;
@dynamic radius;

- (void)awakeFromInsert{
    [super awakeFromInsert];
    self.insertionDate = [NSDate date];
}

+ (NSFetchRequest *)fetchRequestForAllPois{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Region"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"insertionDate"
                                                                     ascending:YES];
    
    fetchRequest.sortDescriptors = @[sortDescriptor];
    fetchRequest.fetchBatchSize = 20;
    
    return fetchRequest;
}

+ (NSFetchRequest *)fetchRequestForPoiWithIdentifier: (NSUInteger) identifier{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Region"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"identifier = %lu", identifier];
    return fetchRequest;
}

+ (void) deletePoiWithIdentifier: (NSUInteger) identifier
           inManageObjectContext: (NSManagedObjectContext *) managedObjectContext{
    NSFetchRequest *fecthRequest = [self fetchRequestForPoiWithIdentifier:identifier];
    fecthRequest.includesPropertyValues = NO;
    
    NSArray *pois = [managedObjectContext executeFetchRequest:fecthRequest
                                                           error:NULL];
    
    for (NSManagedObject *p in pois) {
        [managedObjectContext deleteObject:p];
    }
}

@end
