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

@interface AccelerometerService (Testable)

- (void) updateInternal:(CMAcceleration) data;

@end


@interface AccelerometerServiceTests : XCTestCase
@end

@implementation AccelerometerServiceTests

- (void)testUpdateInternal {
 
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
    
}



@end
