//
//  EventsController.h
//  AquariumHelper
//
//  Created by Ken Zheng on 3/7/18.
//  Copyright © 2018 Ken Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EventsControllerDelegate;
@class DataController;
@class Activity;

@interface EventsController : UIViewController

@property (nonatomic, weak) id<EventsControllerDelegate> delegate;
@property (nonatomic, strong) DataController *dataController;
@property (nonatomic, strong) Activity *activity;

@end

@protocol EventsControllerDelegate <NSObject>

- (void)eventsUpdated;

@end
