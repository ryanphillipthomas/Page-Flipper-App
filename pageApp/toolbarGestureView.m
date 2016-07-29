//
//  toolbarGestureView.m
//  pageApp
//
//  Created by Ryan Thomas on 5/8/16.
//  Copyright © 2016 Ryan Thomas. All rights reserved.
//

#import "toolbarGestureView.h"

@implementation toolbarGestureView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return NO;
}


- (BOOL)pointInsideScrubber:(CGPoint)point
{
    return CGRectContainsPoint(self.scrubberBounds, point);
}

@end
