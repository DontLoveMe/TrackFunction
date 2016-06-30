//
//  TrackCalloutView.m
//  健康芯
//
//  Created by coco船长 on 16/2/19.
//  Copyright © 2016年 nevermore. All rights reserved.
//

#import "TrackCalloutView.h"

#define kArrorHeight 10

#define kPortraitMargin 5
#define kPortraitWidth  50
#define kPortraitHeight 50

#define kTitleWidth     100
#define kTitleHeight    20
#define kPowerWidth     30
#define kPowerHeight    12
#define kSubTitleWidth  140
#define kSubTitleHeight 40

@interface TrackCalloutView ()
@property (nonatomic, strong)UIImageView *portraitView;
@property (nonatomic, strong)UILabel *subtitleLabel;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIImageView *powerView;

@end

@implementation TrackCalloutView

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        [self initSubViews];
        
    }
    
    return self;

}

- (void)initSubViews{

    self.portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(kPortraitMargin, kPortraitMargin, kPortraitWidth, kPortraitHeight)];
    self.portraitView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.portraitView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPortraitMargin * 2 + kPortraitWidth, kPortraitMargin, kTitleWidth, kTitleHeight)];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.text = @"这里可以显示时间";
    [self addSubview:self.titleLabel];
    
    self.powerView = [[UIImageView alloc] initWithFrame:CGRectMake(kPortraitMargin * 2 + kPortraitWidth + kTitleWidth, kPortraitMargin + 2, kPowerWidth, kPowerHeight)];
    self.powerView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.powerView];
    
    self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPortraitMargin * 2 + kPortraitWidth, kPortraitMargin + kTitleHeight, kSubTitleWidth, kSubTitleHeight)];
    self.subtitleLabel.font = [UIFont systemFontOfSize:12];
    self.subtitleLabel.textColor = [UIColor lightGrayColor];
    self.subtitleLabel.numberOfLines = 2;
    self.subtitleLabel.text = @"这里可以显示具体位置";
    [self addSubview:self.subtitleLabel];

}


#pragma mark - drawRect方法，渲染的时候回优先调用此方法。
- (void)drawRect:(CGRect)rect {
    
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
}

- (void)drawInContext:(CGContextRef)context{

    CGContextSetLineWidth(context, 2.f);
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0.3 green:0.3 blue:0.4 alpha:0.8] CGColor]);
    [self getDrawPath:context];
    CGContextFillPath(context);

}

- (void)getDrawPath:(CGContextRef)context{

    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect);
    CGFloat midx = CGRectGetMidX(rrect);
    CGFloat maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect);
    CGFloat maxy = CGRectGetMaxY(rrect) - kArrorHeight;

    CGContextMoveToPoint(context, midx + kArrorHeight, maxy);
    CGContextAddLineToPoint(context, midx, maxy + kArrorHeight);
    CGContextAddLineToPoint(context, midx - kArrorHeight, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, minx, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
    
}

#pragma mark - get，set方法
- (void)setTitle:(NSString *)title{

    self.titleLabel.text = title;

}

- (void)setSubTitle:(NSString *)subTitle{

    self.subtitleLabel.text = subTitle;

}

- (void)setImage:(UIImage *)image{

    self.portraitView.image = image;
    
}

- (void)setPower:(NSString *)power{

    self.powerView.image = [UIImage imageNamed:power];
    
}

@end
