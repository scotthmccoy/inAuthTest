//
//  CGPointAdditions.h
//  inAuthTest
//
//  Created by Scott McCoy on 2/17/15.
//  Copyright (c) 2015 ScottSoft. All rights reserved.
//

#define CLAMP(V, L, H)    MAX( L, MIN(H, V) )

//TODO: Consider moving these to another class, or a pch file
static inline CGPoint CGPointAdd(CGPoint lValue, CGPoint rValue)
{
    CGPoint ret;
    ret.x = lValue.x + rValue.x;
    ret.y = lValue.y + rValue.y;
    return ret;
}

static inline CGPoint CGPointMult(CGPoint point, CGFloat mult) {
    CGPoint ret;
    ret.x = point.x * mult;
    ret.y = point.y * mult;
    return ret;
}

static inline CGPoint CGPointClampToRect(CGPoint point, CGRect rect)
{
    CGPoint ret;
    
    ret.x = CLAMP(point.x, rect.origin.x, rect.origin.x + rect.size.width);
    ret.y = CLAMP(point.y, rect.origin.y, rect.origin.y + rect.size.height);
    
    return ret;
}