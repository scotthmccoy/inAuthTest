//
//  AccelerometerService.m
//  inAuthTest
//
//  Created by Scott McCoy on 2/17/15.
//  Copyright (c) 2015 ScottSoft. All rights reserved.
//


//Header
#import "AccelerometerService.h"

//AppDelegate
#import "AppDelegate.h"

//Other
@import CoreMotion;

@interface AccelerometerService()
@property (nonatomic, strong) CMMotionManager* motionManager;




@end


@implementation AccelerometerService

static AccelerometerService* singletonObject;

+ (AccelerometerService*) singleton {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singletonObject = [[AccelerometerService alloc] init];
    });
    
    return singletonObject;
}



- (id) init {
    
    self = [super init];
    if (!self)
        return nil;
    
    //Set up motionManager
    self.motionManager = [[CMMotionManager alloc] init];

    if (self.motionManager.isAccelerometerAvailable) {
        [self.motionManager startAccelerometerUpdates];
    } else {
        NSLog(@"Accelerometer not available!");
        self.accelerationInPixelsPerSecond = CGPointMake(1, 1);
    }
    
    
    return self;
}

//Get the most recent accelerometer data and update this service's properties.
- (void) update {
    
    if (!self.motionManager.isAccelerometerAvailable) {
        return;
    }
    
    //Accelerometer data is measured in G's
    CMAcceleration data = self.motionManager.accelerometerData.acceleration;
    self.accelerationInPixelsPerSecond = CGPointMake(data.x, data.y);
}


@end
