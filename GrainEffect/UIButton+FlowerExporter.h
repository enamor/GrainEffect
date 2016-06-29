//
//  UIButton+FlowerExporter.h
//  PorklingTV
//
//  Created by xujin on 2/26/16.
//  Copyright © 2016 xujin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (FlowerExporter)

- (void)exportWithHeartFileName:(NSString *)name;
- (void)exportWithImage:(UIImage *)image maskColor:(UIColor *)color;
+ (NSString *)randomHeartFileName;

/**
 *@key:@"filename" key:@"color"
 */
+ (NSDictionary *)randomHeartFile;
@end
