//
//  UIColor+UIColor_HexValues.m
//  inAuthTest
//
//  Created by Scott McCoy on 2/18/15.
//  Copyright (c) 2015 ScottSoft. All rights reserved.
//

@import UIKit;

@interface UIColor (HexValues)
+ (UIColor*) colorWithHexValue:(int)hex;
+ (UIColor*) colorWithHexValue:(int)hex alpha:(CGFloat)alpha;
@end


@implementation UIColor (HexValues)

+ (UIColor*) colorWithHexValue:(int)hex
{
    return [self colorWithHexValue:hex alpha:1.0f];
}

+ (UIColor*) colorWithHexValue:(int)hex alpha:(CGFloat)alpha
{
    //http://stackoverflow.com/questions/1560081/how-can-i-create-a-uicolor-from-a-hex-string
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0f
                           green:((float)((hex & 0x00FF00) >> 8))/255.0f
                            blue:((float)((hex & 0x0000FF)))/255.0f
                           alpha:alpha];
}

@end
