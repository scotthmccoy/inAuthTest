//
//  ViewController.m
//  inAuthTest
//
//  Created by Scott McCoy on 2/17/15.
//  Copyright (c) 2015 ScottSoft. All rights reserved.
//

//Header
#import "ViewController.h"

//Other
#import "AccelerometerService.h"
#import "CGPointAdditions.h"
#import "UIColor+HexValues.m"

//Constants
const int dotWidth = 50;
const int dotHeight = 50;
const NSTimeInterval minimumTickLength = 0.01;
const CGFloat wallThickness = 1.0;


@interface ViewController ()

@property (strong) UIView* dot;
@property CGPoint dotVelocity;

@property BOOL gameInProgress;
@property NSTimeInterval lastTick;


@end



@implementation ViewController


- (void)viewDidLoad {

    [super viewDidLoad];
    
    //Add the dot to the view
    self.dot = [[UIView alloc] initWithFrame:CGRectMake(0,0,dotWidth,dotHeight)];
    self.dot.backgroundColor = [UIColor colorWithHexValue:0x000000];
    [self.view addSubview:self.dot];
    
    

    
    //Start the game loop
    self.gameInProgress = YES;
    self.lastTick = [NSDate timeIntervalSinceReferenceDate];
    [self gameLoop];
}


#pragma mark - Game Loop Ticks

//Encapsulates the dt calculation and threading so that it doesn't clutter up gameLoopTick.
- (void) gameLoop {
    
    if (self.gameInProgress) {
        
        //Have the main thread update the game as often as possible.
        //Note: I could have gone with an NSTimer here or piggybacked on the accelerometer updates and used
        //that as my main loop, but this seemed a nice compromise between elegenace, robustness and stability.
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            //Get the delta-time, or dt.
            NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
            NSTimeInterval dt = now - self.lastTick;
            
            //Move the game forward one "tick"
            if (dt > minimumTickLength) {
                [self gameLoopTick:dt];
                self.lastTick = now;
            }
            
            //Complete the loop by calling gameLoop.
            [self gameLoop];
        });
    }
}

//Note: performing loop updates using the delta-time since the last update gives us frames updating as fast as possible
//while keeping the calculations to make them happen fluid.
- (void) gameLoopTick: (NSTimeInterval) dt {
    
    DebugLog(@"Tick: %f", dt);
    
    //Get fresh values from accelerometer
    AccelerometerService* service = [AccelerometerService singleton];
    [service update];
    
    //Update the velocity
    CGPoint dtAcceleration = CGPointMult(service.accelerationInPixelsPerSecond, dt);
    self.dotVelocity = CGPointAdd(self.dotVelocity, dtAcceleration);
    
    //Update Position
    CGPoint dtVelocity = CGPointMult(self.dotVelocity, dt);
    CGPoint dotCenter = CGPointAdd(dtVelocity, self.dot.center);
    
    //Clamp
    CGRect dotBounds = [self getDotBounds:service];
    CGPoint clampedDotCenter = CGPointClampToRect(dotCenter, dotBounds);
    
    //Check for collisions
    if (!CGPointEqualToPoint(dotCenter, clampedDotCenter))
    {
        DebugLog(@"Collision Detected");
        self.dotVelocity = CGPointZero;
    }
    
    self.dot.center = clampedDotCenter;
    
    
    
    //If the dot is in the upper 20% of the screen
    CGFloat threshold = [UIScreen mainScreen].bounds.size.height * .2;
    if (service.isPortrait && self.dot.center.y <= threshold) {
        self.addressLabel.hidden = NO;
    } else {
        self.addressLabel.hidden = YES;
    }
    
}

//Note: this takes the service as an argument to make unit testing easier. It's an example of Dependency Injection,
//which is a fancy way of saying "pass things the stuff they need to work"
- (CGRect) getDotBounds:(AccelerometerService*) service {

    CGFloat x = dotWidth / 2;
    CGFloat y = dotHeight / 2;
    CGFloat width = [[UIScreen mainScreen] bounds].size.width - dotWidth;
    CGFloat height = [[UIScreen mainScreen] bounds].size.height - dotHeight;
    
    if (service.isLeftWallUp)
    {
        x += wallThickness;
        width -= wallThickness;
    }

    if (service.isTopWallUp)
    {
        y += wallThickness;
        height -= wallThickness;
    }
    
    if (service.isRightWallUp)
    {
        width -= wallThickness;
    }

    if (service.isBottomWallUp)
    {
        height -= wallThickness;
    }
    
    CGRect ret = CGRectMake(x, y, width, height);
    return ret;
}



#pragma mark - Other
- (BOOL)prefersStatusBarHidden {
    return YES;
}


@end
