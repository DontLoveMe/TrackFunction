//
//  TrackAnnotation.h
//  健康芯
//
//  Created by coco船长 on 16/2/19.
//  Copyright © 2016年 nevermore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>

@interface TrackAnnotation : NSObject<MAAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *power;

@property (nonatomic, strong) NSMutableArray *animatedImages;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
