//
//  FLGPoisTableViewController.m
//  Nearbuy
//
//  Created by Javi Alzueta on 26/8/15.
//  Copyright (c) 2015 JavierAlzueta. All rights reserved.
//

#import "FLGPoisTableViewController.h"
#import "PoisSet.h"
#import "FLGPoiTableViewCell.h"

static NSString *const reuseIdentifier = @"cell";

@interface FLGPoisTableViewController ()

@property(weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FLGPoisTableViewController

#pragma mark - Actions

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title = @"Nearbuy Technical Test";
    [self registerNib];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (IBAction)sendLocationCoincidenceDidPress:(id)sender{
    [self sendLocationCoincidence];
//    self.lastDetectedPoi = nil;
}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.poisSet.poisCount;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FLGPoiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FLGPoiTableViewCell cellId]];
    
    [cell configureWithPoi: [self.poisSet poiAtIndex:indexPath.row]];
    
    return cell;
}

-(void) registerNib{
    
    UINib *nib = [UINib nibWithNibName:@"FLGPoiTableViewCell"
                         bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib
         forCellReuseIdentifier:[FLGPoiTableViewCell cellId]];
}

@end
