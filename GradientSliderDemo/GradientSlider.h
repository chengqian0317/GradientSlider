//
//  GradientSlider.h
//  GradientSliderDemo
//
//  Created by ChengQian on 2017/3/1.
//  Copyright © 2017年 chengqian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradientSlider : UIControl

@property (nonatomic, assign) CGFloat startAngle; // 开始角度
@property (nonatomic, assign) CGFloat cutoutAngle; // 终止角度
@property (nonatomic, assign) CGFloat lineWidth; // 绘制线宽度
@property (nonatomic, assign) CGFloat progress; // 进度

@end
