//
//  DataController.m
//  AquariumHelper
//
//  Created by Ken Zheng on 2/23/18.
//  Copyright © 2018 Ken Zheng. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "DataController.h"
#import "Aquarium+CoreDataClass.h"
#import "Activity+CoreDataClass.h"
#import "Event+CoreDataClass.h"

@interface DataController ()

@property (nonatomic, strong) NSPersistentContainer *persistentContainer;

@end

@implementation DataController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Model"];
        [self.persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *desc, NSError *error) {
            if (error != nil) {
                NSLog(@"Failed to load Core Data stack: %@", error);
                abort();
            } else {
                NSLog(@"Core Data loaded successfully.");
            }
            
//            Aquarium *aquarium = [[Aquarium alloc] initWithContext:self.persistentContainer.viewContext];
//            aquarium.name = @"Nemo";
////
//            AquariumEntry *entry = [[AquariumEntry alloc] initWithContext:self.persistentContainer.viewContext];
//            entry.name = @"Change water";
////
//            [aquarium addEntriesObject:entry];
//            [self save];
            
//            [self deleteAllAquariums];
            [self printAllAquariums];
        }];
    }
    
    return self;
}

- (void)save {
    NSError *anError = nil;
    if (![self.persistentContainer.viewContext save:&anError]) {
        NSLog(@"Error saving context: %@", anError);
    } else {
    }
}

- (NSArray *)aquariums {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Aquarium"];
    NSError *error = nil;
    NSArray *fetchResults = [self.persistentContainer.viewContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"fetch request failed: %@, Error: %@", fetchRequest, error);
        return nil;
    } else {
        return fetchResults;
    }
}

- (void)addAquarium:(NSString *)name sizeInLiters:(float)sizeInLiters {
    Aquarium *aquarium = [[Aquarium alloc] initWithContext:self.persistentContainer.viewContext];
    aquarium.name = name;
    aquarium.sizeLiters = sizeInLiters;
    
    Activity *activity = [[Activity alloc] initWithContext:self.persistentContainer.viewContext];
    activity.name = @"Water change";
    
    [aquarium addActivityObject:activity];
    [self save];
}

- (void)completedActivity:(Activity *)activity {
    Event *event = [[Event alloc] initWithContext:self.persistentContainer.viewContext];
    event.date = [NSDate date];
    
    [activity addEventsObject:event];
    
    [self save];
}

- (void)addActivity:(NSString *)name toAquarium:(Aquarium *)aquarium {
    Activity *newActivity = [[Activity alloc] initWithContext:self.persistentContainer.viewContext];
    newActivity.name = name;
    
    [aquarium addActivityObject:newActivity];
    
    [self save];
}

- (void)printAllAquariums {
    NSArray *aquariums = [self aquariums];
    NSLog(@"Aquariums:\n");
    for (Aquarium *aquarium in aquariums) {
        NSLog(@"\t%@\n", aquarium.name);
        NSArray *activities = [aquarium.activity allObjects];
        for (Activity *activity in activities) {
            NSLog(@"\t\t%@", activity.name);
            NSArray *events = [activity.events allObjects];
            for (Event *event in events) {
                NSLog(@"\t\t\t%@", event.date);
            }
        }
    }
}

- (void)deleteAllAquariums {
    NSArray *aquariums = [self aquariums];
    for (Aquarium *aquarium in aquariums)
        [self.persistentContainer.viewContext deleteObject:aquarium];
    
    [self save];
    NSLog(@"Deleted all aquariums");
}

@end
