//
//  TrackAnnotationView.m
//  健康芯
//
//  Created by coco船长 on 16/2/19.
//  Copyright © 2016年 nevermore. All rights reserved.
//

#import "TrackAnnotationView.h"
#import "TrackAnnotation.h"

#define kWidth          30.f
#define kHeight         35.f
#define kTimeInterval   0.15f
#define kCalloutWidth       200.0
#define kCalloutHeight      70.0

@interface TrackAnnotationView ()

@property (nonatomic, strong, readwrite) TrackCalloutView *calloutView;

@end

@implementation TrackAnnotationView

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self setBounds:CGRectMake(0.f, 0.f, kWidth, kHeight)];
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.imageView];
    }
    
    return self;
}

#pragma mark - Utility

- (void)updateImageView
{
    TrackAnnotation *animatedAnnotation = (TrackAnnotation *)self.annotation;
    
    if ([self.imageView isAnimating])
    {
        [self.imageView stopAnimating];
    }
    self.imageView.contentMode          = UIViewContentModeScaleAspectFit;
    self.imageView.animationImages      = animatedAnnotation.animatedImages;
    self.imageView.animationDuration    = kTimeInterval * [animatedAnnotation.animatedImages count];
    self.imageView.animationRepeatCount = 0;
    [self.imageView startAnimating];
    
    self.calloutView.title = animatedAnnotation.title;
    self.calloutView.subTitle = animatedAnnotation.subtitle;
    self.calloutView.power = animatedAnnotation.power;
    
}

#pragma mark - Override
- (void)setAnnotation:(id<MAAnnotation>)annotation
{
    [super setAnnotation:annotation];
    
    [self updateImageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{

    if (self.selected == selected) {
        return;
    }
    
    if (selected) {
        
        if (self.calloutView == nil) {
            
            self.calloutView = [[TrackCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f  + self.calloutOffset.x, -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
            
        }
        
        self.calloutView.image = [UIImage imageNamed:@"定位图标"];
        self.calloutView.title = self.annotation.title;
        self.calloutView.subTitle = self.annotation.subtitle;
        [self addSubview:self.calloutView];
        
    }else{
    
        [self.calloutView removeFromSuperview];
    
    }
    
    [super setSelected:selected
              animated:animated];

}



@end
