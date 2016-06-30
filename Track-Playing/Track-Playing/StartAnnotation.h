//
//  StartAnnotation.h
//  健康芯
//
//  Created by coco船长 on 16/2/18.
//  Copyright © 2016年 nevermore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>

@interface StartAnnotation : NSObject<MAAnnotation>

@property (nonatomic)CLLocationCoordinate2D coordinate;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *subtitle;

@property (nonatomic, strong)UIImage *image;

@end
