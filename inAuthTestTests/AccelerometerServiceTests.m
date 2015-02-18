//
//  inAuthTestTests.m
//  inAuthTestTests
//
//  Created by Scott McCoy on 2/17/15.
//  Copyright (c) 2015 ScottSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "AccelerometerService.h"
@import CoreMotion;

//Expose methods for testing
@interface AccelerometerService (Testable)
- (void) updateInternal:(CMAcceleration) data;
@end


@interface AccelerometerServiceTests : XCTestCase
@end

@implementation AccelerometerServiceTests

- (void)testUpdateInternal {
 
    //Don't use the singleton so that this instance is completely isolated.
    AccelerometerService* service = [[AccelerometerService alloc] init];
    CMAcceleration data;


    //Device lying on table
    data.x = 0.0;
    data.y = 0.0;
    data.z = 0.0;
    
    [service updateInternal:data];

    XCTAssert(service.accelerationInPixelsPerSecond.x == 0.0, "Acceleration not as expected");
    XCTAssert(service.accelerationInPixelsPerSecond.y == 0.0, "Acceleration not as expected");
    XCTAssert(service.isBottomWallUp, "Walls not as expected");
    XCTAssert(service.isRightWallUp, "Walls not as expected");
    XCTAssert(service.isLeftWallUp, "Walls not as expected");
    XCTAssert(service.isTopWallUp, "Walls not as expected");
    XCTAssert(service.isPortrait, "isPortrait not as expected");
    
    
    //Device on right edge
    data.x = 0.9;
    data.y = 0.0;
    data.z = 0.0;
    
    [service updateInternal:data];
    
    XCTAssert(service.accelerationInPixelsPerSecond.x == 900.0, "Acceleration not as expected");
    XCTAssert(service.accelerationInPixelsPerSecond.y == 0.0, "Acceleration not as expected");
    XCTAssert(service.isBottomWallUp, "Walls not as expected");
    XCTAssert(!service.isRightWallUp, "Walls not as expected");
    XCTAssert(service.isLeftWallUp, "Walls not as expected");
    XCTAssert(service.isTopWallUp, "Walls not as expected");
    XCTAssert(!service.isPortrait, "isPortrait not as expected");

    
    //Device on bottom edge
    data.x = 0.0;
    data.y = -0.9;
    data.z = 0.0;
    
    [service updateInternal:data];
    
    XCTAssert(service.accelerationInPixelsPerSecond.x == 0.0, "Acceleration not as expected");
    XCTAssert(service.accelerationInPixelsPerSecond.y == 900.0, "Acceleration not as expected");
    XCTAssert(!service.isBottomWallUp, "Walls not as expected");
    XCTAssert(service.isRightWallUp, "Walls not as expected");
    XCTAssert(service.isLeftWallUp, "Walls not as expected");
    XCTAssert(service.isTopWallUp, "Walls not as expected");
    XCTAssert(service.isPortrait, "isPortrait not as expected");

    //Device on Left edge
    data.x = -0.9;
    data.y = 0.0;
    data.z = 0.0;
    
    [service updateInternal:data];
    
    XCTAssert(service.accelerationInPixelsPerSecond.x == -900.0, "Acceleration not as expected");
    XCTAssert(service.accelerationInPixelsPerSecond.y == 0.0, "Acceleration not as expected");
    XCTAssert(service.isBottomWallUp, "Walls not as expected");
    XCTAssert(service.isRightWallUp, "Walls not as expected");
    XCTAssert(!service.isLeftWallUp, "Walls not as expected");
    XCTAssert(service.isTopWallUp, "Walls not as expected");
    XCTAssert(!service.isPortrait, "isPortrait not as expected");

    //Device on Top edge
    data.x = 0.0;
    data.y = 0.9;
    data.z = 0.0;
    
    [service updateInternal:data];
    
    XCTAssert(service.accelerationInPixelsPerSecond.x == 0.0, "Acceleration not as expected");
    XCTAssert(service.accelerationInPixelsPerSecond.y == -900.0, "Acceleration not as expected");
    XCTAssert(service.isBottomWallUp, "Walls not as expected");
    XCTAssert(service.isRightWallUp, "Walls not as expected");
    XCTAssert(service.isLeftWallUp, "Walls not as expected");
    XCTAssert(!service.isTopWallUp, "Walls not as expected");
    XCTAssert(service.isPortrait, "isPortrait not as expected");
    
    
    
    
    //Z-axis should not affect anything
    data.x = 0.0;
    data.y = 0.0;
    data.z = -9.0;
    
    [service updateInternal:data];
    
    XCTAssert(service.accelerationInPixelsPerSecond.x == 0.0, "Acceleration not as expected");
    XCTAssert(service.accelerationInPixelsPerSecond.y == 0.0, "Acceleration not as expected");
    XCTAssert(service.isBottomWallUp, "Walls not as expected");
    XCTAssert(service.isRightWallUp, "Walls not as expected");
    XCTAssert(service.isLeftWallUp, "Walls not as expected");
    XCTAssert(service.isTopWallUp, "Walls not as expected");
    XCTAssert(service.isPortrait, "isPortrait not as expected");
    
    
    //Z-axis should not affect anything
    data.x = 0.0;
    data.y = 0.0;
    data.z = 9.0;
    
    [service updateInternal:data];
    
    XCTAssert(service.accelerationInPixelsPerSecond.x == 0.0, "Acceleration not as expected");
    XCTAssert(service.accelerationInPixelsPerSecond.y == 0.0, "Acceleration not as expected");
    XCTAssert(service.isBottomWallUp, "Walls not as expected");
    XCTAssert(service.isRightWallUp, "Walls not as expected");
    XCTAssert(service.isLeftWallUp, "Walls not as expected");
    XCTAssert(service.isTopWallUp, "Walls not as expected");
    XCTAssert(service.isPortrait, "isPortrait not as expected");
    
    //Device tilted down slightly
    data.x = 0.0;
    data.y = 0.1;
    data.z = 0.0;
    
    [service updateInternal:data];
    
    XCTAssert(service.accelerationInPixelsPerSecond.x == 0.0, "Acceleration not as expected");
    XCTAssert(service.accelerationInPixelsPerSecond.y == -100.0, "Acceleration not as expected");
    XCTAssert(service.isBottomWallUp, "Walls not as expected");
    XCTAssert(service.isRightWallUp, "Walls not as expected");
    XCTAssert(service.isLeftWallUp, "Walls not as expected");
    XCTAssert(service.isTopWallUp, "Walls not as expected");
    XCTAssert(service.isPortrait, "isPortrait not as expected");

    
    
    //Device tilted up slightly
    data.x = 0.0;
    data.y = -0.1;
    data.z = 0.0;
    
    [service updateInternal:data];
    
    XCTAssert(service.accelerationInPixelsPerSecond.x == 0.0, "Acceleration not as expected");
    XCTAssert(service.accelerationInPixelsPerSecond.y == 100.0, "Acceleration not as expected");
    XCTAssert(service.isBottomWallUp, "Walls not as expected");
    XCTAssert(service.isRightWallUp, "Walls not as expected");
    XCTAssert(service.isLeftWallUp, "Walls not as expected");
    XCTAssert(service.isTopWallUp, "Walls not as expected");
    XCTAssert(service.isPortrait, "isPortrait not as expected");
    
    
    //Device tilted up a lot, but not on edge
    data.x = 0.0;
    data.y = -0.75;
    data.z = 0.0;
    
    [service updateInternal:data];
    
    XCTAssert(service.accelerationInPixelsPerSecond.x == 0.0, "Acceleration not as expected");
    XCTAssert(service.accelerationInPixelsPerSecond.y == 750.0, "Acceleration not as expected");
    XCTAssert(service.isBottomWallUp, "Walls not as expected");
    XCTAssert(service.isRightWallUp, "Walls not as expected");
    XCTAssert(service.isLeftWallUp, "Walls not as expected");
    XCTAssert(service.isTopWallUp, "Walls not as expected");
    XCTAssert(service.isPortrait, "isPortrait not as expected");
    

    //Device tilted right slightly
    data.x = 0.75;
    data.y = 0.0;
    data.z = 0.0;
    
    [service updateInternal:data];
    
    XCTAssert(service.accelerationInPixelsPerSecond.x == 750.0, "Acceleration not as expected");
    XCTAssert(service.accelerationInPixelsPerSecond.y == 0.0, "Acceleration not as expected");
    XCTAssert(service.isBottomWallUp, "Walls not as expected");
    XCTAssert(service.isRightWallUp, "Walls not as expected");
    XCTAssert(service.isLeftWallUp, "Walls not as expected");
    XCTAssert(service.isTopWallUp, "Walls not as expected");
    XCTAssert(!service.isPortrait, "isPortrait not as expected");
    
    //Device tilted left slightly
    data.x = -0.75;
    data.y = 0.0;
    data.z = 0.0;
    
    [service updateInternal:data];
    
    XCTAssert(service.accelerationInPixelsPerSecond.x == -750.0, "Acceleration not as expected");
    XCTAssert(service.accelerationInPixelsPerSecond.y == 0.0, "Acceleration not as expected");
    XCTAssert(service.isBottomWallUp, "Walls not as expected");
    XCTAssert(service.isRightWallUp, "Walls not as expected");
    XCTAssert(service.isLeftWallUp, "Walls not as expected");
    XCTAssert(service.isTopWallUp, "Walls not as expected");
    XCTAssert(!service.isPortrait, "isPortrait not as expected");
}



@end
