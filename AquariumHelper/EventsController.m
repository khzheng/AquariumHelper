//
//  EventsController.m
//  AquariumHelper
//
//  Created by Ken Zheng on 3/7/18.
//  Copyright © 2018 Ken Zheng. All rights reserved.
//

#import "EventsController.h"
#import "Activity+CoreDataClass.h"
#import "Event+CoreDataClass.h"

@interface EventsController () <UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *events;

@end

@implementation EventsController

- (void)loadView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.view = self.tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.activity.name;
    self.tableView.dataSource = self;
    
    [self reloadEvents];
    [self.tableView reloadData];
}

- (void)reloadEvents {
    NSArray *events = [self.activity.events allObjects];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    self.events = [events sortedArrayUsingDescriptors:@[sort]];
}

- (NSString *)stringForDate:(NSDate *)date {
    static NSDateFormatter *_dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        _dateFormatter.timeStyle = NSDateFormatterMediumStyle;
        _dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
    });
    
    return [_dateFormatter stringFromDate:date];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    Event *event = self.events[indexPath.row];
    cell.textLabel.text = [self stringForDate:event.date];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.events count];
}

@end