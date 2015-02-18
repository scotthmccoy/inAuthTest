//
//  ViewControllerTests.m
//  inAuthTest
//
//  Created by Scott McCoy on 2/17/15.
//  Copyright (c) 2015 ScottSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "ViewController.h"
#import "AccelerometerService.h"

//Expose some methods for testing
@interface ViewController (Testable)
- (CGRect) getDotBounds:(AccelerometerService*) service;
@end

@interface AccelerometerService ()
@property (readwrite) BOOL isLeftWallUp;
@property (readwrite) BOOL isRightWallUp;
@property (readwrite) BOOL isTopWallUp;
@property (readwrite) BOOL isBottomWallUp;
@end



@interface ViewControllerTests : XCTestCase

@end

@implementation ViewControllerTests


- (void)testGetDotBounds {

    //This assumes wallThickness of 1.0 and a dotWidth/DotHeight of 25.
    
    ViewController* vc = [[ViewController alloc] init];
    AccelerometerService* service = [[AccelerometerService alloc] init];
    CGRect expectedBounds;
    CGRect actualBounds;

    
    //Basic test
    service.isLeftWallUp = YES;
    service.isRightWallUp = YES;
    service.isTopWallUp = YES;
    service.isBottomWallUp = YES;
    
    actualBounds = [vc getDotBounds:service];
    expectedBounds = CGRectMake(26,26,[[UIScreen mainScreen] bounds].size.width - 52, [[UIScreen mainScreen] bounds].size.height - 52);
    
    XCTAssert(CGRectEqualToRect(expectedBounds, actualBounds), "Bounds not as expected");
    

    
    //Left Wall
    service.isLeftWallUp = NO;
    service.isRightWallUp = YES;
    service.isTopWallUp = YES;
    service.isBottomWallUp = YES;
    
    actualBounds = [vc getDotBounds:service];
    expectedBounds = CGRectMake(25,26,[[UIScreen mainScreen] bounds].size.width - 51, [[UIScreen mainScreen] bounds].size.height - 52);
    
    XCTAssert(CGRectEqualToRect(expectedBounds, actualBounds), "Bounds not as expected");
    

    
    //Right Wall
    service.isLeftWallUp = YES;
    service.isRightWallUp = NO;
    service.isTopWallUp = YES;
    service.isBottomWallUp = YES;
    
    actualBounds = [vc getDotBounds:service];
    expectedBounds = CGRectMake(26,26,[[UIScreen mainScreen] bounds].size.width - 51, [[UIScreen mainScreen] bounds].size.height - 52);
    
    XCTAssert(CGRectEqualToRect(expectedBounds, actualBounds), "Bounds not as expected");
    
    
    //Top Wall
    service.isLeftWallUp = YES;
    service.isRightWallUp = YES;
    service.isTopWallUp = NO;
    service.isBottomWallUp = YES;
    
    actualBounds = [vc getDotBounds:service];
    expectedBounds = CGRectMake(26,25,[[UIScreen mainScreen] bounds].size.width - 52, [[UIScreen mainScreen] bounds].size.height - 51);
    
    XCTAssert(CGRectEqualToRect(expectedBounds, actualBounds), "Bounds not as expected");
    
    
    //Bottom Wall
    service.isLeftWallUp = YES;
    service.isRightWallUp = YES;
    service.isTopWallUp = YES;
    service.isBottomWallUp = NO;
    
    actualBounds = [vc getDotBounds:service];
    expectedBounds = CGRectMake(26,26,[[UIScreen mainScreen] bounds].size.width - 52, [[UIScreen mainScreen] bounds].size.height - 51);
    
    XCTAssert(CGRectEqualToRect(expectedBounds, actualBounds), "Bounds not as expected");
}



@end
