//
//  ViewController.m
//  inAuthTest
//
//  Created by Scott McCoy on 2/17/15.
//  Copyright (c) 2015 ScottSoft. All rights reserved.
//

#import "ViewController.h"


const int dotWidth = 50;
const int dotHeight = 50;
const NSTimeInterval minimumTickLength = 0.01;


@interface ViewController ()

@property (strong) UIView* dot;
@property BOOL gameInProgress;
@property NSTimeInterval lastTick;


@end



@implementation ViewController


- (void)viewDidLoad {

    [super viewDidLoad];
    
    //Add the dot to the view
    self.dot = [[UIView alloc] initWithFrame:CGRectMake(0,0,dotWidth,dotHeight)];
    self.dot.backgroundColor = [UIColor redColor];
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
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            //Get the delta-time, or dt.
            NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
            NSTimeInterval dt = now - self.lastTick;
            
            //Move the game forward one tick
            if (dt > minimumTickLength) {
                [self gameLoopTick:dt];
                self.lastTick = now;
            }
            
            //Complete the loop by calling gameLoop.
            [self gameLoop];
        });
    }
}

- (void) gameLoopTick: (NSTimeInterval) dt {

    self.dot.center = CGPointMake(self.dot.center.x + 1, self.dot.center.y);
}


#pragma mark - Other

- (BOOL)prefersStatusBarHidden {
    return YES;
}


@end
