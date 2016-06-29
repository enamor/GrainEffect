//
//  UIButton+Bubbling.m
//  GrainEffect
//
//  Created by zhouen on 16/6/22.
//  Copyright © 2016年 zhouen. All rights reserved.
//

#import "UIButton+Bubbling.h"


#define LAYER_ANIMATION_LAYER_NAME @"layerName"


// 十六进制颜色值 使用：HEX_COLOR(0xf8f8f8)
#define HEX_COLOR_ALPHA(_HEX_,a) [UIColor colorWithRed:((float)((_HEX_ & 0xFF0000) >> 16))/255.0 green:((float)((_HEX_ & 0xFF00) >> 8))/255.0 blue:((float)(_HEX_ & 0xFF))/255.0 alpha:a]


#define HEX_COLOR(_HEX_) HEX_COLOR_ALPHA(_HEX_, 1.0)


@implementation UIButton (Bubbling)

- (void)startAnimationHeartLayer:(CALayer *)heartLayer
{
    CGFloat duration = 2.0f + arc4random_uniform(10) * 0.1;
    
    //位置动画
    CABasicAnimation *posAnimation =
    [CABasicAnimation animationWithKeyPath:@"position"];
    // -30 30
    CGFloat destination_x = heartLayer.position.x + arc4random_uniform(60) - 30 ;
    
    CGFloat destinaion_y =
    heartLayer.position.y / 2;
    CGPoint destination = CGPointMake(destination_x, destinaion_y);
    [posAnimation setToValue:[NSValue valueWithCGPoint:destination]];
    //    [posAnimation setTimingFunction:
    //     [CAMediaTimingFunction functionWithControlPoints:0.6f :0.7f :0.6 :0.7]];
    
    //透明度动画
    CAKeyframeAnimation *alphaAnimation =
    [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.values = @[@1.0,@1.0,@0.0];
    alphaAnimation.keyTimes = @[@0.0,@0.90,@1.0];
    
    
    //旋转动画
    CABasicAnimation *angleAnimation =
    [CABasicAnimation animationWithKeyPath:@"transform"];
    [angleAnimation setFromValue:
     [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)]];
    CATransform3D destTrans =
    CATransform3DMakeRotation(M_PI/4, 0, 0, (arc4random() % 2000) /1000.0f -1);
    destTrans = CATransform3DScale(destTrans, 1.5f, 1.5f, 1.5f);
    [angleAnimation setToValue:[NSValue valueWithCATransform3D:destTrans]];
    angleAnimation.beginTime = 0.2;
    
    //缩放
    CABasicAnimation *scaleAnimation =
    [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [scaleAnimation setFromValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1f, 0.1f, 1.0f)]];
    CATransform3D scaleTrans = CATransform3DMakeScale(1.0f, 1.0f, 1.0f);
    [scaleAnimation setToValue:[NSValue valueWithCATransform3D:scaleTrans]];
    scaleAnimation.duration = 0.2;
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    [groupAnimation setAnimations:@[posAnimation,alphaAnimation,angleAnimation]];
    [groupAnimation setDuration:duration];
    [groupAnimation setRemovedOnCompletion:YES];
    
    groupAnimation.delegate = self;
    [groupAnimation setValue:heartLayer
                      forKey:LAYER_ANIMATION_LAYER_NAME];
    
    [heartLayer addAnimation:groupAnimation forKey:nil];
}


- (void)bubbingImage:(UIImage *)image
{
    UIColor *color = [self getRandomColor];
    [self exportImage:image withColor:color];
}
- (void)bubbingImages:(NSArray *)images
{
    if (!images)return;
    int index = rand() % images.count;
    UIImage *image = [UIImage imageNamed:images[index]];
    [self exportImage:image withColor:nil];
}



-(void)exportImage:(UIImage *)image withColor:(UIColor *)color{
    if (!image)return;
    CGFloat width = 28.0f;
    CGFloat height = width * image.size.height / image.size.width;
    CGRect frame =
    CGRectMake(self.center.x - width/2 - 15,
               self.center.y-height/2 - 38,
               width,
               height);
    
    CALayer *heartLayer = [CALayer layer];
    heartLayer.opacity = 0.0f;
    heartLayer.frame = frame;
    
    if (color)
    {
        CALayer *maskLayer = [CALayer layer];
        maskLayer.frame = CGRectMake(0, 0, width, height);
        maskLayer.contents = (__bridge id)image.CGImage;
        maskLayer.contentsGravity = kCAGravityResizeAspect;
        heartLayer.opacity = 0.0f;
        heartLayer.mask = maskLayer;
        heartLayer.backgroundColor = color.CGColor;
    }
    else
    {
        heartLayer.contents = (__bridge id)image.CGImage;
    }
    
    [self.superview.layer insertSublayer:heartLayer
                                   above:self.layer];
    
    //动画
    [self startAnimationHeartLayer:heartLayer];
}

- (UIColor *)getRandomColor {
    
    NSArray *colors =
    @[ HEX_COLOR(0xFC6782), HEX_COLOR(0xFFEE58), HEX_COLOR(0x94EFDF),
       HEX_COLOR(0x50E3C2), HEX_COLOR(0xB2D7FF), HEX_COLOR(0xFDDA02),
       HEX_COLOR(0xBAD311), HEX_COLOR(0x58E7F9), HEX_COLOR(0xFF5252),
       HEX_COLOR(0xAE91FC), HEX_COLOR(0xBCF87F), HEX_COLOR(0x29B6F6),
       HEX_COLOR(0xF5A623), HEX_COLOR(0xFB3CB2), HEX_COLOR(0xFFA68A)];
    
    int index = rand() % colors.count;
    UIColor *color = colors[index];
    
    return color;
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim {
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    CALayer *animationLayer = [anim valueForKey:LAYER_ANIMATION_LAYER_NAME];
    
    if (animationLayer) {
        
        [animationLayer removeFromSuperlayer];
        
    }
}

@end
