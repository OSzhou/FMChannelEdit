//
//  UIView+FMBoom.m
//  07_ScrollHeaderAndContent
//
//  Created by Zhouheng on 2018/12/19.
//  Copyright © 2018年 Windy. All rights reserved.
//

/*
 代码来源
 作者：Devil雅馨
 链接：https://www.jianshu.com/p/1a969505f557
 */

#import "UIView+FMBoom.h"

const static NSInteger cellCount = 17;

static NSMutableArray<CALayer *> *booms;

@implementation UIView (FMBoom)

+ (void)load {
    booms = [NSMutableArray<CALayer *> array];
}
- (void)boom {
    [booms removeAllObjects];
    for(int i = 0 ; i < cellCount ; i++){
        for(int j = 0 ; j < cellCount ; j++){
            CGFloat pWidth = MIN(self.frame.size.width, self.frame.size.height)/cellCount;
            CALayer *boomCell = [CALayer layer];
            boomCell.backgroundColor = [self getPixelColorAtLocation:CGPointMake(i*2, j*2)].CGColor;
            boomCell.cornerRadius = pWidth/2;
            boomCell.frame = CGRectMake(i*pWidth, j*pWidth, pWidth, pWidth);
            [self.layer.superlayer addSublayer:boomCell];
            [booms addObject:boomCell];
        }
    }
    //粉碎动画
    [self cellAnimation];
    //缩放消失
    [self scaleOpacityAnimations];
}
- (void)cellAnimation {
    for(CALayer *cell in booms){
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        keyframeAnimation.path = [self makeRandomPath:cell].CGPath;
        keyframeAnimation.fillMode = kCAFillModeForwards;
        keyframeAnimation.timingFunction =  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
        keyframeAnimation.duration = (random()%10) * 0.05 + 0.3;
        CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scale.toValue = @([self makeScaleValue]);
        scale.duration = keyframeAnimation.duration;
        scale.removedOnCompletion = NO;
        scale.fillMode = kCAFillModeForwards;
        CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacity.fromValue = @1;
        opacity.toValue = @0;
        opacity.duration = keyframeAnimation.duration;
        opacity.removedOnCompletion = NO;
        opacity.fillMode = kCAFillModeForwards;
        opacity.timingFunction =  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
        animationGroup.duration = keyframeAnimation.duration;
        animationGroup.removedOnCompletion = NO;
        animationGroup.fillMode = kCAFillModeForwards;
        animationGroup.animations = @[keyframeAnimation,scale,opacity];
        animationGroup.delegate = self;
        [cell addAnimation:animationGroup forKey: @"moveAnimation"];
    }
}
/**
 *  绘制粉碎路径
 */
- (UIBezierPath *)makeRandomPath:(CALayer *)alayer {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:self.layer.position];
    CGFloat left = -self.layer.frame.size.width * 1.3;
    CGFloat maxOffset = 2 * fabs(left);
    CGFloat randomNumber = random()%101;
    CGFloat endPointX = self.layer.position.x + left + (randomNumber/100) * maxOffset;
    CGFloat controlPointOffSetX = self.layer.position.x + (endPointX-self.layer.position.x)/2;
    CGFloat controlPointOffSetY = self.layer.position.y - 0.2 * self.layer.frame.size.height - random()%(int)(1.2 * self.layer.frame.size.height);
    CGFloat endPointY = self.layer.position.y + self.layer.frame.size.height/2 +random()%(int)(self.layer.frame.size.height/2);
    [path addQuadCurveToPoint:CGPointMake(endPointX, endPointY) controlPoint:CGPointMake(controlPointOffSetX, controlPointOffSetY)];
    return path;
}

- (void)scaleOpacityAnimations {
    // 缩放
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath: @"transform.scale"];
    scaleAnimation.toValue = @0.01;
    scaleAnimation.duration = 0.15;
    scaleAnimation.fillMode = kCAFillModeForwards;
    // 透明度
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath: @"opacity"];
    opacityAnimation.fromValue = @1;
    opacityAnimation.toValue = @0;
    opacityAnimation.duration = 0.15;
    opacityAnimation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation: scaleAnimation forKey: @"lscale"];
    [self.layer addAnimation: opacityAnimation forKey: @"lopacity"];
    self.layer.opacity = 0;
}
- (CGFloat)makeScaleValue {
    return 1 - 0.7 * (random()%101 - 50)/50;
}
- (UIImage *)snapShot {
    //根据视图size开始图片上下文
    UIGraphicsBeginImageContext(self.frame.size);
    //提供视图当前图文
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    //获取视图当前图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图片上下文
    UIGraphicsEndImageContext();
    return image;
}

/*
 * data 指被渲染的内存区域 ，这个内存区域大小应该为(bytesPerRow * height)个字节，如果对绘制操作被渲染的内存区域并无特别的要求，那么刻意传NULL
 * width 指被渲染内存区域的宽度
 * height 指被渲染内存区域的高度
 * bitsPerComponent 指被渲染内存区域中组件在屏幕每个像素点上需要使用的bits位，举例来说，如果使用32-bit像素和RGB格式，那么RGBA颜色格式中每个组件在屏幕每一个像素点需要使用的bits位就是为 32/4 = 8
 * bytesPerRow 指被渲染区域中每行所使用的bytes位数
 * space 指被渲染内存区域的“位图上下文”
 * bitmapInfo 指被渲染内存区域的“视图”是否包含一个alpha（透视）通道以及每一个像素点对应的位置，除此之外还可以指定组件是浮点值还是整数值
 
 CGBitmapContextCreate(void * __nullable data,
 size_t width,
 size_t height,
 size_t bitsPerComponent,
 size_t bytesPerRow,
 CGColorSpaceRef __nullable space,
 uint32_t bitmapInfo)
 */

- (CGContextRef)createARGBBitmapContextFromImage:(CGImageRef)inImage {
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    //内存空间的指针，该内存空间的大小等于图像使用RGB通道所占用的字节数
    void *bitmapData;
    unsigned long bitmapByteCount;
    unsigned long bitmapBytePerRow;
    size_t pixelsWide = CGImageGetWidth(inImage);//获取横向的像素点的个数
    size_t pixelsHeight = CGImageGetHeight(inImage);
    //每一行的像素点占用的字节数，每个像素点的ARGB四个通道各占8个bit(0-255)的空间
    bitmapBytePerRow = pixelsWide * 4;
    //计算整张图占用的字节数
    bitmapByteCount = bitmapBytePerRow * pixelsHeight;
    //创建依赖于设备的RGB通道
    colorSpace = CGColorSpaceCreateDeviceRGB();
    //分配足够容纳图片字节数的内存空间
    bitmapData = malloc(bitmapByteCount);
    //创建CoreGraphic的图形上下文，该上下文描述了bitmaData指向的内存空间需要绘制的图像的一些绘制参数
    context = CGBitmapContextCreate(bitmapData, pixelsWide, pixelsHeight, 8, bitmapBytePerRow, colorSpace, kCGImageAlphaPremultipliedFirst);
    //Core Foundation中通过含有Create、Alloc的方法名字创建的指针，需要使用CFRelease()函数释放
    CGColorSpaceRelease(colorSpace);
    return context;
}
/**
 *  根据点，取得对应颜色
 *  point 坐标点
 *  @return 颜色
 */
- (UIColor *)getPixelColorAtLocation:(CGPoint)point {
    //拿到放大后的图片
    CGImageRef inImage = [self scaleImageToSize:CGSizeMake(cellCount*2, cellCount*2)].CGImage;
    //使用上面的方法(createARGBBitmapContextFromImage:)创建上下文
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
    //图片的宽高
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    //rect
    CGRect rect = CGRectMake(0, 0, w, h);
    //将目标图像绘制到指定的上下文，实际为上下文内的bitmapData。
    CGContextDrawImage(cgctx, rect, inImage);
    //取色
    unsigned char *bitmapData = CGBitmapContextGetData(cgctx);
    int pixelInfo = 4*((w*round(point.y))+round(point.x));
    CGFloat a = bitmapData[pixelInfo]/255.0;
    CGFloat r = bitmapData[pixelInfo+1]/255.0;
    CGFloat g = bitmapData[pixelInfo+2]/255.0;
    CGFloat b = bitmapData[pixelInfo+3]/255.0;
    //释放上面的函数创建的上下文
    CGContextRelease(cgctx);
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}
/**
 *  缩放图片
 *
 *  @param size 缩放大小
 *
 *  @return 图片
 */
- (UIImage *)scaleImageToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [[self snapShot] drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *res = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return res;
}

@end
