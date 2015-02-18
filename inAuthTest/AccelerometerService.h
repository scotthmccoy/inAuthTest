//
//  AccelerometerService.h
//  inAuthTest
//
//  Created by Scott McCoy on 2/17/15.
//  Copyright (c) 2015 ScottSoft. All rights reserved.
//

//This class handles and abstracts all accelerometer-related functionality.

#import <UIKit/UIKit.h>

@interface AccelerometerService : NSObject

+ (AccelerometerService*) singleton;
- (void) update;

@property (readonly) CGPoint accelerationInPixelsPerSecond;

@property (readonly) BOOL isLeftWallUp;
@property (readonly) BOOL isRightWallUp;
@property (readonly) BOOL isTopWallUp;
@property (readonly) BOOL isBottomWallUp;

@end
