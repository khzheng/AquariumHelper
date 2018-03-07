//
//  AquariumEntriesController.m
//  AquariumHelper
//
//  Created by Ken Zheng on 3/6/18.
//  Copyright © 2018 Ken Zheng. All rights reserved.
//

#import "AquariumFeedController.h"
#import "Aquarium+CoreDataClass.h"
#import "Activity+CoreDataClass.h"
#import "DataController.h"

@interface AquariumFeedController () < UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *activity;

@end

@implementation AquariumFeedController

- (void)loadView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.view = self.tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@ (%.2f L)", self.aquarium.name, self.aquarium.sizeLiters];
    
    self.activity = [self.aquarium.activity allObjects];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = ((Activity *)self.activity[indexPath.row]).name;

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.activity count];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Activity *activity = self.activity[indexPath.row];
    [self.dataController completedActivity:activity];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
