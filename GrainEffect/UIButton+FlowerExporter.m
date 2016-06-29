//
//  UIButton+FlowerExporter.m
//  PorklingTV
//
//  Created by xujin on 2/26/16.
//  Copyright © 2016 xujin. All rights reserved.
//

#import "UIButton+FlowerExporter.h"

#define LAYER_ANIMATION_LAYER_NAME @"layerName"


// 十六进制颜色值 使用：HEX_COLOR(0xf8f8f8)
#define HEX_COLOR_ALPHA(_HEX_,a) [UIColor colorWithRed:((float)((_HEX_ & 0xFF0000) >> 16))/255.0 green:((float)((_HEX_ & 0xFF00) >> 8))/255.0 blue:((float)(_HEX_ & 0xFF))/255.0 alpha:a]


#define HEX_COLOR(_HEX_) HEX_COLOR_ALPHA(_HEX_, 1.0)


@implementation UIButton (FlowerExporter)

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

- (void)exportWithHeartFileName:(NSString *)name
{
    if ([name isEqualToString:@"ic_menu_red"]) {
//        [self exportWithImage:[UIImage imageNamed:name]
//                    maskColor:[UIColor redColor]];
        [self exportWithImage:[UIImage imageNamed:name]
                    maskColor:[UIButton getARandomColor]];
    }
    else
    {
        [self exportWithImage:[UIImage imageNamed:name]
                    maskColor:nil];
    }
}

- (void)exportWithImage:(UIImage *)image maskColor:(UIColor *)color
{
    
    if (!image)
    {
        return;
    }
    
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

+ (UIColor *)getARandomColor {
    
    NSArray *ary =
    @[ HEX_COLOR(0xFC6782), HEX_COLOR(0xFFEE58), HEX_COLOR(0x94EFDF),
       HEX_COLOR(0x50E3C2), HEX_COLOR(0xB2D7FF), HEX_COLOR(0xFDDA02),
       HEX_COLOR(0xBAD311), HEX_COLOR(0x58E7F9), HEX_COLOR(0xFF5252),
       HEX_COLOR(0xAE91FC), HEX_COLOR(0xBCF87F), HEX_COLOR(0x29B6F6),
       HEX_COLOR(0xF5A623), HEX_COLOR(0xFB3CB2), HEX_COLOR(0xFFA68A)];
    
    int index = rand() % ary.count;
    
    UIColor *color = ary[index];
    
    return color;
}

+ (NSString *)randomHeartFileName
{
    int index = rand() % 25;
    if (index < 15) {
        return @"ic_menu_red";
    }
    NSArray *fileNames = @[@"ic_menu_bluepig",
                           @"ic_menu_bluepig2",
                           @"ic_menu_greenpig",
                           @"ic_menu_greenpig2",
                           @"ic_menu_pinkpig",
                           @"ic_menu_pinkpig2",
                           @"ic_menu_purplepig",
                           @"ic_menu_purplepig2",
                           @"ic_menu_yellowpig",
                           @"ic_menu_yellowpig2"];
    index = rand() % fileNames.count;
    return fileNames[index];
}

/**
 *@key:@"filename" key:@"color"
 */
+ (NSDictionary *)randomHeartFile
{
    return @{@"filename":@"ic_menu_red",@"color":[UIButton getARandomColor]};
    
    NSString *name = [UIButton randomHeartFileName];
    if ([name isEqualToString:@"ic_menu_red"]) {
        return @{@"filename":@"ic_menu_red",@"color":[UIButton getARandomColor]};
    }
    return @{@"filename":name};
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
