//
//  GradientSlider.m
//  GradientSliderDemo
//
//  Created by ChengQian on 2017/3/1.
//  Copyright © 2017年 chengqian. All rights reserved.
//

#import "GradientSlider.h"

// 角度转弧度
static inline double DegreesToRadians(double angle) { return M_PI * angle / 180.0; }
// 弧度转角度
static inline double RadiansToDegrees(double angle) { return angle * 180.0 / M_PI; }

static inline CGPoint CGPointCenterRadiusAngle(CGPoint c, double r, double a) {
    return CGPointMake(c.x + r * cos(a), c.y + r * sin(a));
}

static inline CGFloat AngleBetweenPoints(CGPoint a, CGPoint b, CGPoint c) {
    return atan2(a.y - c.y, a.x - c.x) - atan2(b.y - c.y, b.x - c.x);
}

@interface GradientSlider()

@property (assign, nonatomic) CGPoint handcenterPoint;

@property (nonatomic, assign) CGFloat handleOutSideRadius;

@property (nonatomic, assign) CGFloat handleInSideRadius;

@end

@implementation GradientSlider

- (instancetype)init
{
    return [self initWithFrame:CGRectZero] ;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self viewInitialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self viewInitialize];
    }
    return self;
}

- (void)viewInitialize
{
    _startAngle = -90.f;
    _cutoutAngle = 90.f;
    _lineWidth = CGRectGetWidth(self.frame) / 22;
    _progress = .0f;
    _handleOutSideRadius = _lineWidth - 2;
    _handleInSideRadius = _handleOutSideRadius / 2;
    
}

#pragma mark - Draw Method
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super continueTrackingWithTouch:touch withEvent:event];
    
    CGPoint location = [touch locationInView:self];
    if([self pointInsideHandle:location]){
        [self drawWithLocation:location];
    }

    return YES;
}

/**
 * 检测触摸点是否在滑动块中
 * @param point 触摸点坐标
 */
- (BOOL)pointInsideHandle:(CGPoint)point{
    CGPoint handleCenter = CGPointMake(_handcenterPoint.x, self.bounds.size.width- _handcenterPoint.y) ;
    CGFloat handleRadius = _handleOutSideRadius + 30;
    
    CGRect handleRect = CGRectMake(handleCenter.x - handleRadius, handleCenter.y - handleRadius, handleRadius * 2, handleRadius * 2);
    return CGRectContainsPoint(handleRect, point);
}

/**
 * 绘制移动坐标后的内容
 * @param location 触摸点坐标
 */
- (void)drawWithLocation:(CGPoint)location {
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat radius = CGRectGetMidX(self.bounds) - self.lineWidth / 2;
    CGFloat startAngle = _startAngle;
    if (startAngle < 0)
        startAngle = fabs(startAngle);
    else
        startAngle = 360.f - startAngle;
    CGPoint startPoint = CGPointCenterRadiusAngle(center, radius, DegreesToRadians(startAngle));
    CGFloat angle = RadiansToDegrees(AngleBetweenPoints(location, startPoint, center));
    if (angle < 0) angle += 360.f;
    angle = angle - _cutoutAngle / 2.f;
    
    self.progress = angle / (360.f - _cutoutAngle);
}

- (void)drawRect:(CGRect)rect {
    // 绘制代码
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height); //改变画布位置（0，0位置移动到此处）
    CGContextScaleCTM(context, 1.0, -1.0);
    
    //滑动条中心位置
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    //滑动条半径
    CGFloat radius = CGRectGetMidX(self.bounds) - self.lineWidth / 2 - self.handleOutSideRadius ;
    CGFloat changeAngle = self.cutoutAngle / 2.0;
    //滑动条起始角度
    CGFloat arcStartAngle = DegreesToRadians(self.startAngle + 360.0 - changeAngle);
    //滑动条结束角度
    CGFloat arcEndAngle = DegreesToRadians(self.startAngle + changeAngle);
    //滑块角度
    CGFloat progressAngle = DegreesToRadians(360.f - self.cutoutAngle) * self.progress;

    // 把当前上下文状态保存在栈中，防止以下操作影响圆形按钮的绘制
    CGContextSaveGState(context);
    
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextAddArc(context, center.x, center.y, radius, arcStartAngle, arcEndAngle, 1);
    CGContextSetLineCap(context, kCGLineCapRound);
    // "反选路径"
    // CGContextReplacePathWithStrokedPath
    // 将context中的路径替换成路径的描边版本，使用参数context去计算路径（即创建新的路径是原来路径的描边）。用恰当的颜色填充得到的路径将产生类似绘制原来路径的效果。你可以像使用一般的路径一样使用它。例如，你可以通过调用CGContextClip去剪裁这个路径的描边
    CGContextReplacePathWithStrokedPath(context);
    // 剪裁路径
    CGContextClip(context);
    
    // 绘制角度渐变
    UIImage *gradientImg = [UIImage imageNamed:@"gradient"];
    CGContextDrawImage(context, self.bounds, gradientImg.CGImage);
    
    /* 以下为创建一个渐变色滑动条
    // 创建一个渐变色
    // 创建RGB色彩空间，创建这个以后，context里面用的颜色都是用RGB表示
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    NSMutableArray *gradientObjColors = [NSMutableArray array];
    
    [@[[UIColor redColor], [UIColor yellowColor]] enumerateObjectsUsingBlock:^(id obj,NSUInteger idx, BOOL *stop) {
        
        if ([obj isKindOfClass:[UIColor class]]) {
            [gradientObjColors addObject:(__bridge id)[obj CGColor]];
        }
        else if (CFGetTypeID((__bridge void *)obj) == CGColorGetTypeID()) {
            [gradientObjColors addObject:obj];
        }
        else {
            @throw [NSException exceptionWithName:@"CRGradientLabelError"
                    
                                           reason:@"Object in gradientColors array is not a UIColor or CGColorRef"
                    
                                         userInfo:NULL];
        }
        
    }];
    CGGradientRef gradient =CGGradientCreateWithColors(NULL, (__bridge CFArrayRef)gradientObjColors, NULL);
    
    // 释放色彩空间
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    
    // 渐变色绘制方向
    CGPoint startPoint = CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMaxY(self.bounds));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds));
    
    // 用渐变色填充
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    // 释放渐变色
    CGGradientRelease(gradient), gradient = NULL;
     */
    
    // 把保存在栈中的上下文状态取出来，恢复。上面那段代码设置的样式不会影响其他
    CGContextRestoreGState(context);

    //绘制圆形可拖动按钮
    [[UIColor whiteColor] set];
    CGContextSetShadow(context, CGSizeMake(0.0, 0.0), 1.0);
    CGContextSetLineWidth(context, self.handleOutSideRadius);
    CGPoint handle = CGPointCenterRadiusAngle(center, radius, arcStartAngle - progressAngle);
    _handcenterPoint = handle;
    CGContextAddArc(context, handle.x, handle.y, self.handleOutSideRadius + 1, 0, DegreesToRadians(360), 1);
    CGContextStrokePath(context);
    
}

#pragma mark - Set Method
- (void)setProgress:(CGFloat)progress {
    if (progress > 0.99)
        _progress = 0.99;
    else if (progress < 0)
        _progress = 0;
    else
        _progress = progress;
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self setNeedsDisplay];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
