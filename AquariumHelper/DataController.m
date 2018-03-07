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
#import "AquariumEntry+CoreDataClass.h"

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
            
            Aquarium *aquarium = [[Aquarium alloc] initWithContext:self.persistentContainer.viewContext];
            aquarium.name = @"Nemo";
//
            AquariumEntry *entry = [[AquariumEntry alloc] initWithContext:self.persistentContainer.viewContext];
            entry.name = @"Change water";
//
            [aquarium addEntriesObject:entry];
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

- (void)printAllAquariums {
    NSArray *aquariums = [self aquariums];
    NSLog(@"Aquariums:\n");
    for (Aquarium *aquarium in aquariums) {
        NSLog(@"%@\n", aquarium.name);
        NSArray *entries = [aquarium.entries allObjects];
        for (AquariumEntry *entry in entries) {
            NSLog(@"%@", entry.name);
        }
    }
}

- (void)deleteAllAquariums {
    NSArray *aquariums = [self aquariums];
    for (Aquarium *aquarium in aquariums) {
        [self.persistentContainer.viewContext deleteObject:aquarium];
    }
    
    [self save];
    NSLog(@"Deleted all aquariums");
}

@end
