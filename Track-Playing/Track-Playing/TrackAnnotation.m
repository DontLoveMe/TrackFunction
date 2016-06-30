//
//  TrackAnnotation.m
//  健康芯
//
//  Created by coco船长 on 16/2/19.
//  Copyright © 2016年 nevermore. All rights reserved.
//

#import "TrackAnnotation.h"

@implementation TrackAnnotation

@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize power = _power;
@synthesize coordinate = _coordinate;

@synthesize animatedImages = _animatedImages;

#pragma mark - life cycle

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (self = [super init])
    {
        self.coordinate = coordinate;
    }
    return self;
}


@end
