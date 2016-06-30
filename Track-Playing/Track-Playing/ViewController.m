//
//  ViewController.m
//  Track-Playing
//
//  Created by coco船长 on 16/6/30.
//  Copyright © 2016年 nevermore. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

#pragma mark - 轨迹播放须知
/*
 *此项目，使用的是高德地图（百度地图可能有差异）。
 *功能：通过播放的形式，展示一段时间内的定位数据的变化。
 *播放进度条。显示的是轨迹开始的时间，结束时间，以及播放当前进度的时间。
 *在这里，使用的数据为，以前项目采集的部分数据（包括地理坐标及相关数据）。
 */

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"轨迹播放";
    
//    NSDate *date = [NSDate date];
//    NSTimeInterval time = [date timeIntervalSince1970];
    
    //配置用户mapKey
    [MAMapServices sharedServices].apiKey = @"fa3376d7235111ecc6388488c743d8b6";
    
    [self initViews];
    
    [self initDates];
    
}

#pragma mark - 子视图
- (void)initViews{

    //地图底图
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    _trackButton = [[UIButton alloc] initWithFrame:CGRectMake((KScreenWidth - 44.f) / 2, KScreenHeight - 50.f, 44.f, 44.f)];
    [_trackButton setBackgroundImage:[UIImage imageNamed:@"轨迹"]
                            forState:UIControlStateNormal];
    [self.view addSubview:_trackButton];
    
    [_trackButton addTarget:self
                     action:@selector(clickAction:)
           forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark - 设置数据
- (void)initDates{

//    _treatedArr = [NSMutableArray arrayWithArray:[CreateData createTestData]];
    

}

#pragma mark - ButtonAction
- (void)clickAction:(UIButton *)button{

    //播放轨迹的界面
    if (!_playView) {
        
        _playView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, 55.f)];
        _playView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_playView];
        //播放界面的控件
        _playButton = [[UIButton alloc] initWithFrame:CGRectMake(8.f, 12.f, 30.f, 30.f)];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"播放"]
                               forState:UIControlStateNormal];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"暂停"]
                               forState:UIControlStateSelected];
        [_playButton addTarget:self
                        action:@selector(playOrPalseAction:)
              forControlEvents:UIControlEventTouchUpInside];
        [_playView addSubview:_playButton];
        
        _nowTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_playButton.right, 17.f, 35.f, 20.f)];
        _nowTimeLabel.backgroundColor = [UIColor clearColor];
        _nowTimeLabel.textColor = [UIColor colorFromHexRGB:@"383838"];
        _nowTimeLabel.textAlignment = NSTextAlignmentCenter;
        _nowTimeLabel.text = @"00:00";
        _nowTimeLabel.font =[UIFont systemFontOfSize:12];
        [_playView addSubview:_nowTimeLabel];
        
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake (KScreenWidth - 43.f, 12.f, 30.f, 30.f)];
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"取消播放"]
                                 forState:UIControlStateNormal];
        [_cancelButton addTarget:self
                          action:@selector(cancelPlay:)
                forControlEvents:UIControlEventTouchUpInside];
        [_playView addSubview:_cancelButton];
        
        _endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_cancelButton.left - 40.f, 17.f, 40.f, 20.f)];
        _endTimeLabel.backgroundColor = [UIColor clearColor];
        _endTimeLabel.textColor = [UIColor colorFromHexRGB:@"383838"];
        _endTimeLabel.textAlignment = NSTextAlignmentCenter;
        _endTimeLabel.text = @"00:00";
        _endTimeLabel.font =[UIFont systemFontOfSize:12];
        [_playView addSubview:_endTimeLabel];
        
        _processSlider = [[UISlider alloc] initWithFrame:CGRectMake(_nowTimeLabel.right,17.f, KScreenWidth - 166.f, 20.f)];
        _processSlider.backgroundColor = [UIColor clearColor];
        [_processSlider addTarget:self
                           action:@selector(slideTouchAction:)
                 forControlEvents:UIControlEventTouchUpInside];
        [_processSlider addTarget:self
                           action:@selector(slideAction:)
                 forControlEvents:UIControlEventValueChanged];
        [_playView addSubview:_processSlider];
        
    }
    
    CGRect frame = _playView.frame;
    frame.origin.y = frame.origin.y - 55;
    CGRect buttonFrame = _trackButton.frame;
    buttonFrame.origin.y = frame.origin.y + 55;
    [UIView animateWithDuration:1
                     animations:^{
                         
                         _playView.frame = frame;
                         _trackButton.frame = buttonFrame;
                         
                     }];
    
    [self Orientation:[NSMutableArray arrayWithArray:[CreateData createTestData]]];

}

#pragma mark - 先把整体路线勾画出来
- (void)Orientation:(NSMutableArray *)effentiveArr{

    [self clearMap];
    _treatedArr = [[NSMutableArray alloc] init];
    _treatedArr = [NSMutableArray arrayWithArray:effentiveArr];
    //转换地图坐标
    _searchList = [[NSMutableArray alloc] init];
    CLLocationCoordinate2D allpoint[effentiveArr.count];
    _processSlider.maximumValue = effentiveArr.count;
    _processSlider.minimumValue = 0;
    _currentProcess = 0;
    _processSlider.value = 0;
    for (int i = 0 ; i < effentiveArr.count ; i++) {
        
        NSDictionary *latestDic = effentiveArr[effentiveArr.count - i - 1];
        allpoint[i] = MACoordinateConvert(CLLocationCoordinate2DMake([[latestDic objectForKey:@"latitude"] floatValue], [[latestDic objectForKey:@"longitude"] floatValue]), MACoordinateTypeGPS);
        if (!_search) {
            _search = [[AMapSearchAPI alloc] init];
        }
        
        //根据经纬度获得详情，在delegate回调
        [AMapSearchServices sharedServices].apiKey = @"fa3376d7235111ecc6388488c743d8b6";
        _search.delegate = self;
        AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
        regeo.location = [AMapGeoPoint locationWithLatitude:allpoint[i].latitude
                                                  longitude:allpoint[i].longitude];
        regeo.requireExtension = YES;
        [_search AMapReGoecodeSearch:regeo];
        
        if (i == 0) {
            
            NSInteger timeInt = [[latestDic objectForKey:@"creatTime"] integerValue];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"hh:mm"];
            _nowTimeLabel.text = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInt / 1000]];
            
        }else if (i == effentiveArr.count - 1){
            
            NSInteger timeInt = [[latestDic objectForKey:@"creatTime"] integerValue];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"hh:mm"];
            _endTimeLabel.text = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInt / 1000]];
            
        }
        
    }
    
    //显示起始，结束位置
    NSDictionary *startDic = [effentiveArr lastObject];
    NSDictionary *latestDic = [effentiveArr firstObject];
    CLLocationCoordinate2D startLocation = MACoordinateConvert(CLLocationCoordinate2DMake([[startDic objectForKey:@"latitude"] floatValue],[[startDic objectForKey:@"longitude"] floatValue] ), MACoordinateTypeGPS);
    StartAnnotation *annotation1 = [[StartAnnotation alloc] init];
    NSInteger startTimeInt = [[startDic objectForKey:@"positionTime"] integerValue];
//    annotation1.title = [self getDateStringWithDate:[NSDate dateWithTimeIntervalSince1970:startTimeInt / 1000]];
    annotation1.subtitle = nil;
    annotation1.coordinate = startLocation;
    annotation1.image = [UIImage imageNamed:@"起始点"];
    [_mapView addAnnotation:annotation1];
    
    CLLocationCoordinate2D endLocation = MACoordinateConvert(CLLocationCoordinate2DMake([[latestDic objectForKey:@"latitude"] floatValue],[[latestDic objectForKey:@"longitude"] floatValue] ), MACoordinateTypeGPS);
    StartAnnotation *annotation2 = [[StartAnnotation alloc] init];
    NSInteger endTimeInt = [[latestDic objectForKey:@"positionTime"] integerValue];
//    annotation2.title = [self getDateStringWithDate:[NSDate dateWithTimeIntervalSince1970:endTimeInt / 1000]];
    
    annotation2.subtitle = nil;
    annotation2.coordinate = endLocation;
    annotation2.image = [UIImage imageNamed:@"终点"];
    [_mapView addAnnotation:annotation2];
    
    //先把总体路线画出来
    MAPolyline *allpointLine = [MAPolyline polylineWithCoordinates:allpoint count:effentiveArr.count];
    [_mapView addOverlay:allpointLine];
    
}

#pragma mark - 播放界面的点击事件
//播放或者暂停
- (void)playOrPalseAction:(UIButton *)button{
    
    if (button.selected) {
        
        button.selected = NO;
        [_timer invalidate];
        
    }else if(!button.selected){
        
        button.selected = YES;
        [_mapView setZoomLevel:15.f animated:YES];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(timeAction)
                                                userInfo:nil
                                                 repeats:YES];
    }
}

//播放，开始轨迹回放
- (void)timeAction{
    
    //条件停止定时器
    if (_currentProcess >= _treatedArr.count) {
        
        _processSlider.value = 0;
        _currentProcess = 0;
        _playButton.selected = NO;
        [_timer invalidate];
        
    }
    
    //取出当前位置的经纬度
    NSDictionary *currentDic = [_treatedArr objectAtIndex:_treatedArr.count - _currentProcess - 1];
    CLLocationCoordinate2D currentLocation = MACoordinateConvert(CLLocationCoordinate2DMake([[currentDic objectForKey:@"latitude"] floatValue],[[currentDic objectForKey:@"longitude"] floatValue] ), MACoordinateTypeGPS);
    
    //当前显示数据的点
    if (_TrackPoint == nil) {
        
        _TrackPoint = [[TrackAnnotation alloc] init];
        
    }
    
    //当前annotation的基本属性
    NSMutableArray *trainImages = [[NSMutableArray alloc] init];
    [trainImages addObject:[UIImage imageNamed:@"左.png"]];
    [trainImages addObject:[UIImage imageNamed:@"右.png"]];
    _TrackPoint.animatedImages = trainImages;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         _TrackPoint.coordinate = currentLocation;
                         
                     }];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [_mapView setCenterCoordinate:currentLocation];
        
    }];
    
    //当前annotation的可变属性
    NSInteger nowTime = [[currentDic objectForKey:@"creatTime"] integerValue];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"hh:mm"];
    _TrackPoint.title = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:nowTime / 1000]];
    if (_searchList.count - 1 > _currentProcess) {
        
        _TrackPoint.subtitle = _searchList[_currentProcess];
        
    }else{
        
        _TrackPoint.subtitle = @"正在获取位置信息";
        
    }
    
    NSInteger nowPower = [[currentDic objectForKey:@"electricity"] integerValue];
    _TrackPoint.power = [self powerForInt:nowPower];
    
    if (_annotationView != nil) {
        
        [_annotationView setAnnotation:_TrackPoint];
        
    }
    [_mapView addAnnotation:_TrackPoint];
    [_mapView selectAnnotation:_TrackPoint animated:YES];
    
    //定时器当前进度+1
    _currentProcess = _currentProcess + 1;
    _processSlider.value = _currentProcess;
    _nowTimeLabel.text = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:nowTime / 1000]];
    
}

//取消播放
- (void)cancelPlay:(UIButton *)button{
    
    //还原控件
    if ([_timer isValid]) {
        
        [_timer invalidate];
        _playButton.selected = NO;
        
    }
    CGRect frame = _playView.frame;
    frame.origin.y = frame.origin.y + 55.f;
    CGRect buttonFrame = _trackButton.frame;
    buttonFrame.origin.y = frame.origin.y - 55.f;
    [UIView animateWithDuration:1
                     animations:^{
                         
                         _playView.frame = frame;
                         _trackButton.frame = buttonFrame;
                         
                     }];
    
}

//slider事件监听
- (void)slideTouchAction:(UISlider *)slider{
    
    [_timer invalidate];
    _playButton.selected = NO;
    
}

- (void)slideAction:(UISlider *)slider{
    
    NSInteger currentValue = (NSInteger)slider.value;
    //定时器当前进度+1
    _currentProcess = currentValue;
    //条件停止定时器
    if (_currentProcess >= _treatedArr.count) {
        
        _processSlider.value = _processSlider.maximumValue;
        _currentProcess = _processSlider.maximumValue;
        _playButton.selected = NO;
        [_timer invalidate];
        
    }else{
        
        //取出当前位置的经纬度
        NSDictionary *currentDic = [_treatedArr objectAtIndex:_treatedArr.count - currentValue - 1];
        CLLocationCoordinate2D currentLocation = MACoordinateConvert(CLLocationCoordinate2DMake([[currentDic objectForKey:@"latitude"] floatValue],[[currentDic objectForKey:@"longitude"] floatValue] ), MACoordinateTypeGPS);
        
        //当前显示数据的点
        if (_TrackPoint == nil) {
            
            _TrackPoint = [[TrackAnnotation alloc] init];
            
        }
        
        //当前annotation的基本属性
        NSMutableArray *trainImages = [[NSMutableArray alloc] init];
        [trainImages addObject:[UIImage imageNamed:@"左.png"]];
        [trainImages addObject:[UIImage imageNamed:@"右.png"]];
        _TrackPoint.animatedImages = trainImages;
        
        [UIView animateWithDuration:0.5
                         animations:^{
                             
                             _TrackPoint.coordinate = currentLocation;
                             
                         }];
        
        [UIView animateWithDuration:0.5 animations:^{
            
            [_mapView setCenterCoordinate:currentLocation];
            
        }];
        
        //当前annotation的可变属性
        NSInteger nowTime = [[currentDic objectForKey:@"creatTime"] integerValue];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"hh:mm"];
        _TrackPoint.title = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:nowTime / 1000]];
        if (_searchList.count - 1 > _currentProcess) {
            
            _TrackPoint.subtitle = _searchList[_currentProcess];
            
        }else{
            
            _TrackPoint.subtitle = @"正在获取位置信息";
            
        }
        NSInteger nowPower = [[currentDic objectForKey:@"electricity"] integerValue];
        _TrackPoint.power = [self powerForInt:nowPower];
        
        if (_annotationView != nil) {
            
            [_annotationView setAnnotation:_TrackPoint];
            
        }
        [_mapView addAnnotation:_TrackPoint];
        [_mapView selectAnnotation:_TrackPoint animated:YES];
        _nowTimeLabel.text = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:nowTime / 1000]];
        
    }
    
}

#pragma mark - 电量判断
- (NSString *)powerForInt:(NSInteger)power{
    
    if (power >= 0 && power < 20) {
        
        return @"空";
        
    }else if (power >= 20 && power <50){
        
        return @"较空";
        
    }else if (power >= 50 && power < 80){
        
        return @"较满";
        
    }else{
        
        return @"满";
        
    }
    
}

#pragma mark - 移除地图上的覆盖层和标注
- (void)clearMap{
    
    for (MAAnnotationView *annotationView in _mapView.annotations) {
        
        [_mapView removeAnnotation:(id <MAAnnotation>)annotationView];
        
    }
    
    for (MACircleView *circleView in _mapView.overlays) {
        
        [_mapView removeOverlay:(id <MAOverlay>)circleView];
        
    }
    
    for (MAPolylineView *lineView in _mapView.overlays) {
        
        [_mapView removeOverlay:(id <MAOverlay>)lineView];
        
    }
    
}

#pragma mark - MAMapDelegeta
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[StartAnnotation class]]) {
        
        static NSString *startIdentify = @"start_annotation";
        MAAnnotationView *annotationView = [_mapView dequeueReusableAnnotationViewWithIdentifier:startIdentify];
        if (!annotationView) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:startIdentify];
            annotationView.canShowCallout = false;
            annotationView.calloutOffset = CGPointMake(0, 1);
            annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"左边"]];
            annotationView.rightCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"右边"]];
        }
        
        annotationView.annotation = annotation;
        annotationView.image = ((StartAnnotation *)annotation).image;
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
        
    }else if ([annotation isKindOfClass:[EndAnnotation class]]){
        
        static NSString *startIdentify = @"end_annotation";
        MAAnnotationView *annotationView = [_mapView dequeueReusableAnnotationViewWithIdentifier:startIdentify];
        if (!annotationView) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:startIdentify];
            annotationView.canShowCallout = false;
            annotationView.calloutOffset = CGPointMake(0, 1);
            annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"左边"]];
            annotationView.rightCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"右边"]];
        }
        
        annotationView.annotation = annotation;
        annotationView.image = ((StartAnnotation *)annotation).image;
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
        
    }else if ([annotation isKindOfClass:[TrackAnnotation class]]){
        
        static NSString *startIdentify = @"track_annotation";
        _annotationView = (TrackAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:startIdentify];
        
        if (_annotationView == nil){
            _annotationView = [[TrackAnnotationView alloc] initWithAnnotation:annotation
                                                              reuseIdentifier:startIdentify];
        }
        _annotationView.canShowCallout   = NO;
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        _annotationView.centerOffset = CGPointMake(0, -18);
        return _annotationView;
        
    }else{
        
        return nil;
        
        
    }
    
}

//已经添加注释视图
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    
    MAAnnotationView *view = views[0];
    
    if ([view.annotation isKindOfClass:[MAUserLocation class]]) {
        
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        [_mapView updateUserLocationRepresentation:pre];
        view.calloutOffset = CGPointMake(0, 0);
        view.canShowCallout = NO;
//        _userLocationAnnotationView = view;
        
        
    }
    
}

//描点选中事件
- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view{
    
    
    
}

//连线
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay{
    
    if ([overlay isKindOfClass:[MAPolyline class]]) {
        
        MAPolylineView *polyLine = [[MAPolylineView alloc] initWithPolyline:overlay];
        polyLine.lineWidth = 5.f;
        polyLine.strokeColor = [UIColor colorFromHexRGB:ThemeColor];
        [mapView setVisibleMapRect:overlay.boundingMapRect edgePadding:UIEdgeInsetsMake(30, 30, 30, 30) animated:YES];
        return polyLine;
    }
    
    return nil;
}

#pragma mark - AMapSearchDelegate(逆地理编码，获取经纬度对应的地址)
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    
    if (response.regeocode != nil){

        [_searchList addObject:response.regeocode.formattedAddress];
 
    }else{
        
        [_searchList addObject:@"暂无地理数据"];

    }
    
}

@end
