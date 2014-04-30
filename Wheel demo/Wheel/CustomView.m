//
//  CustomView.m
//  RotaryWheelProject
//
//  Created by TeeHom on 13-12-23.
//
//

#import "CustomView.h"
#define PI 3.14159265358979323846

#define   DEGREES_TO_RADIANS(degrees)  ((PI * degrees)/ 180)
@implementation CustomView

- (id)initWithFrame:(CGRect)frame   withImgeString:(NSString *)imgStr
{
    _imageStr = [imgStr copy];
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


// 覆盖drawRect方法，你可以在此自定义绘画和动画
- (void)drawRect:(CGRect)rect
{
    /*
    UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(109, 40.5) radius:108 startAngle:DEGREES_TO_RADIANS(135) endAngle:DEGREES_TO_RADIANS(225) clockwise:NO];
    
    CALayer* contentLayer = [CALayer layer];
    [contentLayer setFrame:self.bounds];
    CAShapeLayer* mask = [CAShapeLayer layer];
    mask.path = path1.CGPath;
    [contentLayer setContents:(id)[[UIImage imageNamed:@"restau.png"] CGImage]];
    [contentLayer setMask:mask];
    [[self layer]addSublayer:contentLayer];
    */
    
    /*
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(109, 40.5) radius:108 startAngle:DEGREES_TO_RADIANS(135) endAngle:DEGREES_TO_RADIANS(225) clockwise:YES];
    
    [path moveToPoint:CGPointMake(9, 81)];
    [path addLineToPoint:CGPointMake(109, 40.5)];
    [path addLineToPoint:CGPointMake(8, 0)];

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddPath(ctx, path.CGPath);

    CGContextClip(ctx);
    CGContextDrawImage(ctx, self.bounds, [UIImage imageNamed:@"restau.png"].CGImage);
    */
    
//    CGMutablePathRef pathRef = CGPathCreateMutable();
//    CGPathMoveToPoint(pathRef, NULL, 0, 0);
//    CGPathAddLineToPoint(pathRef, NULL, 108, 45);
//    CGPathAddLineToPoint(pathRef, NULL,0, 90);
//    
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextAddPath(ctx, pathRef);
//    CGContextClip(ctx);
//    
//    CGContextDrawImage(ctx, self.bounds, [UIImage imageNamed:_imageStr].CGImage);
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    CGPathMoveToPoint(pathRef, NULL, 0, 0);
    CGPathAddLineToPoint(pathRef, NULL, 108, 45);
    CGPathAddLineToPoint(pathRef, NULL,0, 90);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddPath(ctx, pathRef);
    CGContextClip(ctx);
    
    CGContextDrawImage(ctx, self.bounds, flip([UIImage imageNamed:_imageStr].CGImage));


}

CGImageRef flip (CGImageRef im) {
    
    CGSize sz = CGSizeMake(CGImageGetWidth(im), CGImageGetHeight(im));
    
    UIGraphicsBeginImageContextWithOptions(sz, NO, 0);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, sz.width, sz.height), im);
    
    CGImageRef result = [UIGraphicsGetImageFromCurrentImageContext() CGImage];
    
    UIGraphicsEndImageContext();
    
    return result;
    
}


- (UIBezierPath*)createArcPath
{
    UIBezierPath* aPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(150, 150)
                           
                                                         radius:75
                           
                                                     startAngle:0
                           
                                                       endAngle:DEGREES_TO_RADIANS(135)
                           
                                                      clockwise:YES];
    
    return aPath;
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
