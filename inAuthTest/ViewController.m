//
//  ViewController.m
//  inAuthTest
//
//  Created by Scott McCoy on 2/17/15.
//  Copyright (c) 2015 ScottSoft. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong) UIView* dot;

@end



@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dot = [[UIView alloc] initWithFrame:CGRectMake(0,0,50,50)];
    self.dot.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.dot];
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}


@end
