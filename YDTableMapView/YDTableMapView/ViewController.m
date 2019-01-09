//
//  ViewController.m
//  YDTableMapView
//
//  Created by Docker on 2019/1/8.
//  Copyright © 2019 Docker. All rights reserved.
//

#import "ViewController.h"

#import "TableView.h"

#import <MAMapKit/MAMapKit.h>

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, MAMapViewDelegate>
/** 地图 */
@property (nonatomic, strong) MAMapView *mapView;
/** tableView */
@property (nonatomic, strong) UITableView *tableView;
/** annotations */
@property (nonatomic, strong) NSArray <MAPointAnnotation *> *annotations;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.mapView addAnnotations:self.annotations];
    [self tableView];
    
    self.tableView.showsVerticalScrollIndicator = NO;

    //设置滚动到底部固定tableView显示大小为100
    self.tableView.contentInset = UIEdgeInsetsMake((self.view.frame.size.height - 100), 0, 0, 0);
    
    //设置进入界面的地图显示大小
    self.tableView.contentOffset = CGPointMake(0, -300);
    
    //设置透明色，保证在偏移量下面能看见mapView
    self.tableView.backgroundColor = [UIColor clearColor];
    
    //保证地图图标始终在可见区域的中心
    [self showAnnotations:self.tableView];
}


/**
 使地图的标注点始终显示在地图可见区域的中心
 */
- (void)showAnnotations:(UIScrollView *)scrollView
{
    CGFloat bottomInset = self.view.frame.size.height + scrollView.contentOffset.y;
    
    [self.mapView showAnnotations:self.mapView.annotations edgePadding:(UIEdgeInsetsMake(50, 50, bottomInset, 50)) animated:YES];

    
}


#pragma mark - MAMapViewDelegate
/**
 * @brief 根据anntation生成对应的View。
 * @param mapView 地图View
 * @param annotation 指定的标注
 * @return 生成的标注View
 */
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIndetifier = @"YD";
        
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
            
            annotationView.pinColor = MAPinAnnotationColorRed;
        }
        
        return annotationView;
    }
    
    return nil;
}


#pragma mark - UItableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YD"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YD"];
    }
    
    cell.textLabel.text = @(indexPath.row).stringValue;
    
    return cell;
}

#pragma mark - UIScrollViewDelegate
/**
 手指滑动的时候调用
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 计算偏移量，当前点 - 初始默认点
    CGFloat offset = scrollView.contentOffset.y - -300;
    // 计算alpha
    CGFloat alpha = offset / 300;
    
    if (alpha >= 1.0)
    {
        alpha = 0.99;
    }
    
    scrollView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:alpha];
}

/**
 手指离开滑动停止的时候调用
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {// 无加速度
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

/**
 减速完成后调用
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >= 0) return;
    
    [self showAnnotations:scrollView];
}


#pragma mark - lazy
- (MAMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
        _mapView.backgroundColor = [UIColor redColor];
        _mapView.rotateEnabled = NO;
        _mapView.rotateCameraEnabled= NO;
        _mapView.showsCompass = NO;
        _mapView.showsScale = NO;
        _mapView.showsUserLocation = NO;
        _mapView.delegate = self;
        [self.view addSubview:_mapView];
    }
    return _mapView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[TableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 44;
        [self.view addSubview:_tableView];
    }
    return _tableView;

}

- (NSArray<MAPointAnnotation *> *)annotations {
    
    if (!_annotations) {
        NSMutableArray *arrayM = [NSMutableArray array];
        CLLocationCoordinate2D coordinates[3] = {{31.114870876736099, 121.366055501302}, {31.122568359374998, 121.363997124566}, {31.114871000000001, 121.376056}};
        
        for (int i = 0; i < 3; i++) {
            MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
            annotation.coordinate = coordinates[i];
            [arrayM addObject:annotation];
        }
        _annotations = [arrayM copy];
    }
    return _annotations;
}

@end
