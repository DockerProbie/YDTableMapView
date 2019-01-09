//
//  TableView.m
//  YDTableMapView
//
//  Created by Docker on 2019/1/8.
//  Copyright © 2019 Docker. All rights reserved.
//

#import "TableView.h"

@implementation TableView
/**
 偏移量小于零时不让tableView响应点击事件
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (point.y < 0) {
        return nil;
    } else {
        return [super hitTest:point withEvent:event];
    }
}

@end
