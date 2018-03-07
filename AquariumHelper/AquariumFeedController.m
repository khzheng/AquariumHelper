//
//  AquariumEntriesController.m
//  AquariumHelper
//
//  Created by Ken Zheng on 3/6/18.
//  Copyright © 2018 Ken Zheng. All rights reserved.
//

#import "AquariumFeedController.h"
#import "Aquarium+CoreDataClass.h"
#import "AquariumEntry+CoreDataClass.h"

@interface AquariumFeedController () < UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *aquariumEntries;

@end

@implementation AquariumFeedController

- (void)loadView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.view = self.tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@ (%.2f L)", self.aquarium.name, self.aquarium.sizeLiters];
    
    self.aquariumEntries = [self.aquarium.entries allObjects];
    
    self.tableView.dataSource = self;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = ((AquariumEntry *)self.aquariumEntries[indexPath.row]).name;

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.aquariumEntries count];
}

@end
