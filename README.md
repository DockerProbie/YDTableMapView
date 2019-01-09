# YDTableMapView
仿高德地图搜索界面地图列表展示效果

***

运行前，请进行一次 **pod install**
i
OS仿高德地图搜索界面地图列表展示效果
最近发现淘宝物流有个地图界面，物流路线的展示跟高德地图的搜索界面类型，列表的拉动悬停，地图标注、线路展示跟着列表悬停的位置改变，于是自己研究了下，做了一个类似效果的 Demo

运行效果
由于不会上传视频，只能上传一张图片讲就下

效果图如下：



实现原理
核心主要是手势点击响应方法
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event { 

}
首先自定义一个tableView,我这里是创建了一个叫TableVile 的类，啥也不用做，只需要在 TableView.m 重写上面的方法：

/**
偏移量小于零时不让tableView响应点击事件
*/
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
 if (point.y<0) {
 return nil;
 } else {
 return [super hitTest:point withEvent:event];
 }
}
ViewController.m文件下，@interface 声明代码 我这里是加了一组标注，后面有其他需求的也可自己修改
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
初始化设置代码在viewDidLoad里面加入下面初始化代码

首先，进入界面设置contentInset保证在列表滚动到底部时还会保存固定大小的尺寸，防止拉到底部之后拉不回来了
然后是偏移量，进入界面之后的地图默认展示大小，我这里默认是300，后面根据需求自己修改
地图是放在tableView下面的，要显示出来，需要把tableView的背景颜色设置透明，
是调整标注位置，使其始终显示在地图可见区域的中心
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
地图标注的动态修改方法

/**
 使地图的标注点始终显示在地图可见区域的中心
 */
- (void)showAnnotations:(UIScrollView *)scrollView
{
    CGFloat bottomInset = self.view.frame.size.height + scrollView.contentOffset.y;

    [self.mapView showAnnotations:self.mapView.annotations edgePadding:(UIEdgeInsetsMake(50, 50, bottomInset, 50)) animated:YES];


}
最后一个，列表滚动的处理，滚动完，或者，手拉动列离开屏幕时都需要重新设置下地图标注显示位置

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
最后说明
不是很擅长写东西，写得比较粗糙，具体的可以参考 demo
