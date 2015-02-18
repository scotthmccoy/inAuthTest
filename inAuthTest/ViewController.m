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
//Note: I was tempted to put these hex values into a plist, but with a count of only 4, it seemed like overkill
const int hexColorForDot = 0x3882a6;
const int hexColorForViewBackground = 0x113c48;
const int hexColorForAddressText = 0xf8f989;
const int hexColorForAddressBackground = 0x000000;

@interface ViewController ()

@property (strong) UIView* dot;
@property CGPoint dotVelocity;

@property BOOL gameInProgress;
@property NSTimeInterval lastTick;

@property CLLocationManager* locationManager;
@property CLGeocoder* geocoder;

@end



@implementation ViewController


- (void)viewDidLoad {

    [super viewDidLoad];
    
    //Setup styling
    self.view.backgroundColor = [UIColor colorWithHexValue:hexColorForViewBackground];
    self.addressLabel.textColor = [UIColor colorWithHexValue:hexColorForAddressText];
    self.addressLabel.backgroundColor = [UIColor colorWithHexValue:hexColorForAddressBackground alpha:0.25];
    
    //Create the Dot and make it circular
    self.dot = [[UIView alloc] initWithFrame:CGRectMake(0,0,dotWidth,dotHeight)];
    self.dot.layer.cornerRadius = self.dot.bounds.size.width/2;
    self.dot.layer.masksToBounds = YES;
    self.dot.backgroundColor = [UIColor colorWithHexValue:hexColorForDot];
    self.dot.hidden = YES;
    [self.view addSubview:self.dot];
    
    //Start up Core Location
    self.geocoder = [[CLGeocoder alloc] init];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [self.locationManager requestWhenInUseAuthorization];
    
    //Start the game loop
    self.gameInProgress = YES;
    self.lastTick = [NSDate timeIntervalSinceReferenceDate];
    [self gameLoop];
    
    //Required for shake events
    [self becomeFirstResponder];
}


#pragma mark - Game Loop Ticks

//Encapsulates the dt calculation and threading so that it doesn't clutter up gameLoopTick.
- (void) gameLoop {
    
    if (self.gameInProgress) {
        
        //Queue updates to the game on the main thread as often as possible.

        //Note: I prefer this method because game loop updates are queued as fast as they
        //can be completed. I could have gone with an NSTimer here but they fire on a
        //specified interval which works fine when you have more than enough processing
        //power to run them, but when you don't, your updates can pile up. Basically, it
        //works the worst when you need it the most. Another option would have been to
        //piggyback on accelerometer updates, which is definitely more "simple" in that it's
        //fewer lines of code, but then accelerometer-secific stuff is all mixed in with game
        //loop stuff, and it's harder to test.
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
//while keeping calculations fluid.
- (void) gameLoopTick: (NSTimeInterval) dt {
    
    //DebugLog(@"Tick: %f", dt);
    if (self.dot.hidden) {
        self.addressLabel.hidden = YES;
        self.dotVelocity = CGPointZero;
        return;
    }
    
    
    //Get fresh values from accelerometer
    AccelerometerService* service = [AccelerometerService singleton];
    [service update];
    
    //Update the velocity
    CGPoint dtAcceleration = CGPointMult(service.accelerationInPixelsPerSecond, dt);
    self.dotVelocity = CGPointAdd(self.dotVelocity, dtAcceleration);
    
    //Update Position
    CGPoint dtVelocity = CGPointMult(self.dotVelocity, dt);
    CGPoint dotCenter = CGPointAdd(dtVelocity, self.dot.center);
    
    //Note: I decided to go with very simple collision handling that sets the dot's velocity to 0,0
    //when it collides with the edge of the screen. In gameplay, the walls feel cushioned and/or sticky.
    //It would be fairly easy to determine the angle of incidence and reflection during a collision and
    //set the velocity such that the dot bounces off of the walls. But, maybe the customer doesn't want that!
    //Agile teaches us not to interpret the requirements-as-written too broadly, deliver frequently, and
    //get plenty of feedback from the customer. In this way, your time spent programming is (as often
    //as possible) spent adding business value.
    
    //Clamp
    CGRect dotBounds = [self getDotBounds:service];
    CGPoint clampedDotCenter = CGPointClampToRect(dotCenter, dotBounds);
    
    //Check for collisions
    if (!CGPointEqualToPoint(dotCenter, clampedDotCenter))
    {
        self.dotVelocity = CGPointZero;
    }
    
    self.dot.center = clampedDotCenter;
    
    
    
    //If the dot is in the upper 20% of the screen, show the address label
    CGFloat threshold = [UIScreen mainScreen].bounds.size.height * .2;
    if (service.isPortrait && self.dot.center.y <= threshold) {
        self.addressLabel.hidden = NO;
    } else {
        self.addressLabel.hidden = YES;
    }
    
}

//Determines the hit box for screen edge collisions, based on the dot's size and the AccelerometerService's
//knowledge of how vertical the device is.
//Note: this takes the service as an argument to make unit testing easier. It's an example of Dependency Injection,
//which is a fancy way of saying "pass methods the stuff they need to work so that testing is easier"
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

#pragma mark - CLLocationManagerDelegate methods
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {

    //DebugLogWhereAmI();
    
    [self.geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            DebugLog(@"error = [%@]", error);
        } else if ([placemarks count] > 0) {
            CLPlacemark* placemark = [placemarks lastObject];
            self.addressLabel.text = [NSString stringWithFormat:@"%@ %@\n%@ %@, %@\n%@",
                                 placemark.subThoroughfare,     //Street
                                 placemark.thoroughfare,        //Street
                                 placemark.locality,            //City
                                 placemark.administrativeArea,  //State
                                 placemark.postalCode,          //Zip
                                 placemark.country];            //Country
        }
    }];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    DebugLog(@"error = [%@]", error);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {

    DebugLogWhereAmI();
    
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self.locationManager startUpdatingLocation];
            break;
            
        default:
            [self.locationManager stopUpdatingLocation];
    }
}


#pragma mark - Other

//Hide the status bar
- (BOOL)prefersStatusBarHidden {
    return YES;
}

//Shake event handler
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {

    if (motion == UIEventSubtypeMotionShake)
    {
        self.dot.hidden = YES;
    }
}

//Touch event handler
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.dot.hidden) {
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint touchLocation = [touch locationInView:self.view];
        
        self.dot.center = touchLocation;
        self.dot.hidden = NO;
    }
}

@end
