//
//  ViewController.m
//  AquariumHelper
//
//  Created by Ken Zheng on 1/11/18.
//  Copyright © 2018 Ken Zheng. All rights reserved.
//

#import "AquariumsController.h"
#import "DataController.h"
#import "Aquarium+CoreDataClass.h"
#import "AquariumFeedController.h"

@interface AquariumsController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DataController *dataController;
@property (nonatomic, strong) NSArray *aquariums;

@end

@implementation AquariumsController

- (void)loadView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.view = self.tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Aquariums";
    
    UIBarButtonItem *addAquariumButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAquariumAction:)];
    self.navigationItem.rightBarButtonItem = addAquariumButton;
    
    self.dataController = [[DataController alloc] init];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self reloadAquariums];
}

- (void)reloadAquariums {
    self.aquariums = self.dataController.aquariums;
    [self.tableView reloadData];
}

#pragma mark - Actions

- (IBAction)addAquariumAction:(id)sender {
    [self.dataController addAquarium:@"Freshwater" sizeInLiters:37.85];
    [self reloadAquariums];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    Aquarium *aquarium = self.aquariums[indexPath.row];
    
    cell.textLabel.text = aquarium.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f L", aquarium.sizeLiters];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.aquariums count];;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Aquarium *aquarium = self.aquariums[indexPath.row];
    AquariumFeedController *vc = [[AquariumFeedController alloc] init];
    vc.aquarium = aquarium;
    vc.dataController = self.dataController;
    [self.navigationController pushViewController:vc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
