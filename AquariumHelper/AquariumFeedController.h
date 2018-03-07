//
//  AquariumEntriesController.h
//  AquariumHelper
//
//  Created by Ken Zheng on 3/6/18.
//  Copyright © 2018 Ken Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataController;
@class Aquarium;

@interface AquariumFeedController : UIViewController

@property (nonatomic, strong) Aquarium *aquarium;
@property (nonatomic, strong) DataController *dataController;

@end
