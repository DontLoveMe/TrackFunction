//
//  TrackAnnotationView.h
//  健康芯
//
//  Created by coco船长 on 16/2/19.
//  Copyright © 2016年 nevermore. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

#import "TrackCalloutView.h"

@interface TrackAnnotationView : MAAnnotationView

@property (nonatomic, readonly)TrackCalloutView *calloutView;

@property (nonatomic, strong) UIImageView *imageView;

@end
