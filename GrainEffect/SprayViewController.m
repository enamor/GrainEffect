//
//  SprayViewController.m
//  GrainEffect
//
//  Created by zhouen on 16/6/22.
//  Copyright © 2016年 zhouen. All rights reserved.
//

#import "SprayViewController.h"
@interface SprayViewController ()
@property (assign,nonatomic) BOOL               isCleared;
@property (strong,nonatomic) NSMutableArray     *cacheEmitterLayers;
@end
@implementation SprayViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    self.cacheEmitterLayers = [NSMutableArray array];
    
    
    UIButton *buton = [[UIButton alloc] initWithFrame:CGRectMake(200, 80, 50, 30)];
    buton.backgroundColor = [UIColor grayColor];
    [buton setTitle:@"清除" forState:UIControlStateNormal];
    [self.view addSubview:buton];
    [buton addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *start = [[UIButton alloc] initWithFrame:CGRectMake(100, 80, 50, 30)];
    start.backgroundColor = [UIColor grayColor];
    [start setTitle:@"开始" forState:UIControlStateNormal];
    [self.view addSubview:start];
    [start addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self clear];
}
-(void)start{
    _isCleared = NO;
    UIImage *image = [UIImage imageNamed:@"star"];
    [self shootFrom:self.view.center Level:400 Cells:@[image]];
}

- (void)shootFrom:(CGPoint)position Level:(int)level Cells:(NSArray <UIImage *>*)images; {
    if (_isCleared) return;
    CGPoint emiterPosition = position;
    // 配置发射器
    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
    emitterLayer.emitterPosition = emiterPosition;
    //发射源的尺寸大小
    emitterLayer.emitterSize     = CGSizeMake(10, 10);
    //发射模式
    emitterLayer.emitterMode     = kCAEmitterLayerOutline;
    //发射源的形状
    emitterLayer.emitterShape    = kCAEmitterLayerLine;
    emitterLayer.renderMode      = kCAEmitterLayerOldestLast;
    
    [self.view.layer addSublayer:emitterLayer];
    
    int index = rand()%[images count];
    CAEmitterCell *snowflake          = [CAEmitterCell emitterCell];
    //粒子的名字
    snowflake.name                    = @"sprite";
    //粒子参数的速度乘数因子
    snowflake.birthRate               = level;
    snowflake.lifetime                = 10;
    //粒子速度
    snowflake.velocity                = 400;
    //粒子的速度范围
    snowflake.velocityRange           = 100;
    //粒子y方向的加速度分量
    snowflake.yAcceleration           = 300;
    //snowflake.xAcceleration = 200;
    //周围发射角度
    snowflake.emissionRange           = 0.25*M_PI;
    //    snowflake.emissionLatitude = 200;
    snowflake.emissionLongitude       = 2*M_PI;//
    //子旋转角度范围
    snowflake.spinRange               = 2*M_PI;
    
    snowflake.contents                = (id)[[images objectAtIndex:index] CGImage];
    snowflake.contentsScale = 0.9;
    snowflake.scale                   = 0.1;
    snowflake.scaleSpeed              = 0.1;
    
    
    emitterLayer.emitterCells  = [NSArray arrayWithObject:snowflake];
    [self.cacheEmitterLayers addObject:emitterLayer];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_isCleared)return ;
        emitterLayer.birthRate = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (_isCleared)return ;
            [emitterLayer removeFromSuperlayer];
            [self.cacheEmitterLayers removeObject:emitterLayer];
        });
    });
    
}

-(void)clear{
    self.isCleared = YES;
    for (CAEmitterLayer *emitterLayer in self.cacheEmitterLayers)
    {
        [emitterLayer removeFromSuperlayer];
        emitterLayer.emitterCells = nil;
    }
    [self.cacheEmitterLayers removeAllObjects];
}
@end
