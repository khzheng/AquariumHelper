//
//  DataController.h
//  AquariumHelper
//
//  Created by Ken Zheng on 2/23/18.
//  Copyright © 2018 Ken Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Aquarium;
@class Activity;

@interface DataController : NSObject

@property (nonatomic, readonly) NSArray *aquariums;

- (void)addAquarium:(NSString *)name sizeInLiters:(float)sizeInLiters;
- (void)completedActivity:(Activity *)activity;
- (void)addActivity:(NSString *)name toAquarium:(Aquarium *)aquarium;

@end
