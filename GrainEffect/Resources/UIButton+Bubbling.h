//
//  UIButton+Bubbling.h
//  GrainEffect
//
//  Created by zhouen on 16/6/22.
//  Copyright © 2016年 zhouen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Bubbling)

/**
 *  根据图片随机分配颜色
 *
 *  @param image baseImage
 */
- (void)bubbingImage:(UIImage *)image;

/**
 *  多张图片中随机出现
 *
 *  @param images 图片数据
 */
- (void)bubbingImages:(NSArray *)images;
@end
