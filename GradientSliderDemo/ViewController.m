//
//  ViewController.m
//  GradientSliderDemo
//
//  Created by ChengQian on 2017/3/1.
//  Copyright © 2017年 chengqian. All rights reserved.
//

#import "ViewController.h"
#import "GradientSlider.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    GradientSlider *gradientSlider = [[GradientSlider alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) - 80, CGRectGetWidth(self.view.bounds) - 80)];
    gradientSlider.center = CGPointMake(CGRectGetMaxX(self.view.bounds) / 2, CGRectGetMaxY(self.view.bounds) / 2);
    [gradientSlider setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:gradientSlider];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
