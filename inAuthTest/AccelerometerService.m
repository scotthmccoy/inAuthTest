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
#import "CGPointAdditions.h"


//The Accelerometers return values in units of Gravities. Use this to convert to pixels.
const CGFloat pixelsPerGravity = 1000.0;

//Business requirements state that "The dot shouldn’t touch the bottom edge of the screen until the device it tilted within is 10% of vertical."
const double wallThreshold = 0.9;

//Tilt threshold for determining if the device is in portrait or not.
const double portraitThresholdX = 0.3;


@interface AccelerometerService()
@property (nonatomic, strong) CMMotionManager* motionManager;

//Redefine these as readwrite
@property (readwrite) CGPoint accelerationInPixelsPerSecond;
@property (readwrite) BOOL isLeftWallUp;
@property (readwrite) BOOL isRightWallUp;
@property (readwrite) BOOL isTopWallUp;
@property (readwrite) BOOL isBottomWallUp;
@property (readwrite) BOOL isPortrait;
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
    }
    
    return self;
}

//Get the most recent accelerometer data and update this service's properties.
- (void) update {

    //Accelerometer data is measured in G's
    CMAcceleration data;

    if (TARGET_IPHONE_SIMULATOR) {
        //For testing, simulate tilting the device hard to the right and slightly down
        //TODO: have touchesMoved change direction of gravity for in-simulator testing
        data.x = 1.0;
        data.y = -0.1;
        data.z = 0.0;
    } else {
        data = self.motionManager.accelerometerData.acceleration;
    }
    
//    DebugLog(@"data.x = [%f], data.y = [%f]", data.x, data.y);
    
    [self updateInternal:data];
}

//Private, unit-testable part of update method.
- (void) updateInternal:(CMAcceleration) data {
    
    //The origin is in the top left and grows in the positive y downward, so we flip the y-value
    self.accelerationInPixelsPerSecond = CGPointMult(CGPointMake(data.x, -data.y), pixelsPerGravity);
    
    //DebugLog(@"self.accelerationInPixelsPerSecond.x = [%f], self.accelerationInPixelsPerSecond.y = [%f]", self.accelerationInPixelsPerSecond.x, self.accelerationInPixelsPerSecond.y);
    
    //These determine whether the dot can touch the edge of the screen.
    self.isRightWallUp = data.x < wallThreshold;
    self.isLeftWallUp = data.x > -wallThreshold;
    self.isTopWallUp = data.y < wallThreshold;
    self.isBottomWallUp = data.y > -wallThreshold;
    
    if (data.x < -portraitThresholdX || data.x > portraitThresholdX) {
        self.isPortrait = NO;
    } else {
        self.isPortrait = YES;
    }
}


@end
