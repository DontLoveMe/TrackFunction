//
//  ViewController.h
//  Track-Playing
//
//  Created by coco船长 on 16/6/30.
//  Copyright © 2016年 nevermore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<MAMapViewDelegate,AMapSearchDelegate>{

    //背景地图视图
    MAMapView               *_mapView;
    
    //轨迹按钮
    UIButton                *_trackButton;
    //播放轨迹视图
    UIView                  *_playView;
    UIButton                *_playButton;
    UILabel                 *_nowTimeLabel;
    UISlider                *_processSlider;
    UILabel                 *_endTimeLabel;
    UIButton                *_cancelButton;
    
    //轨迹相关的数组
    //请求下来的所有点数组
    NSMutableArray          *_dataArr;
    //轨迹时间数组
    NSMutableArray          *_timeArr;
    //处理后的数组
    NSMutableArray          *_treatedArr;
    
    //轨迹点对象
    TrackAnnotation         *_TrackPoint;
    TrackAnnotationView     *_annotationView;
    //逆地理编码服务
    AMapSearchAPI           *_search;
    //逆地理编码返回数组
    NSMutableArray          *_searchList;
    
    //定时器
    NSTimer                 *_timer;
    NSInteger               _currentProcess;
    
}


@end

