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
#import "Event+CoreDataClass.h"
#import "DataController.h"
#import "EventsController.h"

@interface AquariumFeedController () < UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *activity;
@property (nonatomic, strong) NSArray *latestEvents;

@end

@implementation AquariumFeedController

- (void)loadView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.view = self.tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = [NSString stringWithFormat:@"%@ (%.2f L)", self.aquarium.name, self.aquarium.sizeLiters];
    self.title = self.aquarium.name;
    
    UIBarButtonItem *addActivityButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addActivity:)];
    self.navigationItem.rightBarButtonItem = addActivityButton;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self reloadFeed];
    [self.tableView reloadData];
}

- (void)reloadFeed {
    self.activity = [self.aquarium.activity allObjects];
    
    // find the latest event in each activity
    NSMutableArray *latestEvents = [NSMutableArray arrayWithCapacity:[self.activity count]];
    for (Activity *activity in self.activity) {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
        NSArray *sortDescriptors = @[sort];
        NSArray *sortedEvents = [activity.events sortedArrayUsingDescriptors:sortDescriptors];
        if ([sortedEvents firstObject])
            [latestEvents addObject:[sortedEvents firstObject]];
        else    // activity has no events
            [latestEvents addObject:[NSNull null]];
    }
    self.latestEvents = [NSArray arrayWithArray:latestEvents];
}

- (NSString *)stringForDate:(NSDate *)date {
    static NSDateFormatter *_dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateStyle = NSDateFormatterShortStyle;
        _dateFormatter.timeStyle = NSDateFormatterShortStyle;
        _dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
    });
    
    return [_dateFormatter stringFromDate:date];
}

#pragma mark - Actions

- (IBAction)addActivity:(id)sender {
    const NSInteger activityNameTag = 23;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"New Activity" message:@"Name your activity" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textfield) {
        textfield.tag = activityNameTag;
        textfield.placeholder = @"Feed fish";
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray *textfields = alertController.textFields;
        for (UITextField *textfield in textfields) {
            if (textfield.tag == activityNameTag) {
                NSString *activityName = textfield.text;
                if ([activityName length] > 0) {
                    [self.dataController addActivity:activityName toAquarium:self.aquarium];
                    [self reloadFeed];
                    [self.tableView reloadData];
                } else {
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                
                break;
            }
        }
    }];
    [alertController addAction:okAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    
    Activity *activity = self.activity[indexPath.row];
    Event *latestEvent = self.latestEvents[indexPath.row];
    
    cell.textLabel.text = activity.name;
    cell.detailTextLabel.text = [latestEvent isEqual:[NSNull null]] ? @"" : [self stringForDate:latestEvent.date];

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
    
    [self reloadFeed];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    EventsController *vc = [[EventsController alloc] init];
    vc.activity = self.activity[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
