//
//  ViewController.m
//  AquariumHelper
//
//  Created by Ken Zheng on 1/11/18.
//  Copyright © 2018 Ken Zheng. All rights reserved.
//

#import "ViewController.h"
#import "DataController.h"
#import "Aquarium+CoreDataClass.h"
#import "AquariumEntry+CoreDataClass.h"

@interface ViewController () <UITableViewDataSource>

@property (nonatomic, strong) Aquarium *aquarium;
@property (nonatomic, strong) NSArray *entries;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DataController *dataController = [[DataController alloc] init];
    NSArray *aquariums = dataController.aquariums;
    self.aquarium = aquariums[0];
    self.entries = [self.aquarium.entries allObjects];
    
    self.tableView.dataSource = self;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = ((AquariumEntry *)self.entries[indexPath.row]).name;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.entries count];;
}

@end
