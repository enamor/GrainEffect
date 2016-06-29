//
//  DazViewController.m
//  FFEmitterDemo
//
//  Created by iObitLXF on 1/22/13.
//  Copyright (c) 2013 iObitLXF. All rights reserved.
//

#import "DazViewController.h"

@interface DazViewController ()

@end

@implementation DazViewController
@synthesize dazLayer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
	// Do any additional setup after loading the view.
    
    CGRect viewBounds = self.view.layer.bounds;
    // Create the emitter layer
	self.dazLayer = [CAEmitterLayer layer];
	
	// Cells spawn in a 50pt circle around the position
	self.dazLayer.emitterPosition = CGPointMake(viewBounds.size.width/2.0, 0);//发射源位置
	self.dazLayer.emitterSize	= CGSizeMake(50, 0);//发射源尺寸大小
	self.dazLayer.emitterMode	= kCAEmitterLayerOutline;//发射源模式
	self.dazLayer.emitterShape	= kCAEmitterLayerLine;//发射源的形状
	self.dazLayer.renderMode    = kCAEmitterLayerAdditive;//渲染模式
    self.dazLayer.velocity      = -1;//发射方向
    self.dazLayer.seed = (arc4random()%100)+1;//用于初始化随机数产生的种子
    
    // Create the rocket
	CAEmitterCell* rocket = [CAEmitterCell emitterCell];
	
	rocket.birthRate		= 1.0;//粒子产生系数，默认1.0
	rocket.emissionRange	= 0.25 * M_PI;  // some variation in angle//周围发射角度
	rocket.velocity			= 380;//速度
	rocket.velocityRange	= 100;//速度范围
	rocket.yAcceleration	= 75;//粒子y方向的加速度分量
	rocket.lifetime			= 1.02;	// we cannot set the birthrate < 1.0 for the burst//生命周期
	
	rocket.contents			= (id) [[UIImage imageNamed:@"FFRing"] CGImage];//是个CGImageRef的对象,既粒子要展现的图片
	rocket.scale			= 0.2;//缩放比例
	rocket.color			= [[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0] CGColor];//[[UIColor redColor] CGColor];//粒子的颜色
	rocket.greenRange		= 1.0;		// different colors//一个粒子的颜色green 能改变的范围
	rocket.redRange			= 1.0;//一个粒子的颜色red 能改变的范围
	rocket.blueRange		= 1.0;//一个粒子的颜色blue 能改变的范围
	rocket.spinRange		= M_PI;		// slow spin//子旋转角度范围
    
	
    
	// 爆炸 the burst object cannot be seen, but will spawn the sparks
	// we change the color here, since the sparks inherit its value
	CAEmitterCell* burst = [CAEmitterCell emitterCell];
	
	burst.birthRate			= 1.0;		// at the end of travel//粒子产生系数，默认为1.0
	burst.velocity			= 0;    //速度
	burst.scale				= 2.5;  //缩放比例
	burst.redSpeed			=-1.5;		// shifting粒子red在生命周期内的改变速度
	burst.blueSpeed			=+1.5;		// shifting粒子blue在生命周期内的改变速度
	burst.greenSpeed		=+1.0;		// shifting粒子green在生命周期内的改变速度
	burst.lifetime			= 0.35; //生命周期
    
    // 火花 and finally, the sparks
	CAEmitterCell* spark = [CAEmitterCell emitterCell];
	
	spark.birthRate			= 400;//粒子产生系数，默认为1.0
	spark.velocity			= 125;//速度
	spark.emissionRange		= 2* M_PI;	// 360 deg//周围发射角度
	spark.yAcceleration		= 75;		// gravity//y方向上的加速度分量
	spark.lifetime			= 3;    //粒子生命周期
    
	spark.contents			= (id) [[UIImage imageNamed:@"FFTspark"] CGImage];//是个CGImageRef的对象,既粒子要展现的图片
	spark.scaleSpeed		=-0.2;  //缩放比例速度
	spark.greenSpeed		=-0.1;  //粒子green在生命周期内的改变速度
	spark.redSpeed			= 0.4;  //粒子red在生命周期内的改变速度
	spark.blueSpeed			=-0.1;  //粒子blue在生命周期内的改变速度
	spark.alphaSpeed		=-0.25; //粒子透明度在生命周期内的改变速度
	spark.spin				= 2* M_PI;  //子旋转角度
	spark.spinRange			= 2* M_PI;  //子旋转角度范围
	
	// First traigles are emitted, which then spawn circles and star along their path
	self.dazLayer.emitterCells = [NSArray arrayWithObject:rocket];
	rocket.emitterCells = [NSArray arrayWithObjects:burst, nil];
    burst.emitterCells = [NSArray arrayWithObject:spark];
	//	circle.emitterCells = [NSArray arrayWithObject:star];	// this is SLOW!
	[self.view.layer addSublayer:self.dazLayer];
    
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if (self.isCleared) return;
//        if (emitterLayer) emitterLayer.birthRate = 0;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            if (self.isCleared) return;
//            if (emitterLayer)
//            {
//                [emitterLayer removeFromSuperlayer];
//                [self.cacheEmitterLayers removeObject:emitterLayer];
//            }
//            
//        });
//    });


    
       
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
