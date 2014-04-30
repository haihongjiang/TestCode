/*
 Copyright (C) <2012> <Wojciech Czelalski/CzekalskiDev>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
#define K_EPSINON        (1e-127)
#define IS_ZERO_FLOAT(X) (X < K_EPSINON && X > -K_EPSINON)

#define K_FRICTION              2.0f   // 摩擦系数
#define K_MAX_SPEED             300.0f//12.0f
#define K_POINTER_ANGLE         (M_PI / 2)

//****************************


#define degreesToRadians(x) (M_PI * (x) / 180.0)
#define kRotationDegrees 90
#import "CDCircle.h"
#import <QuartzCore/QuartzCore.h>
#import "CDCircleGestureRecognizer.h"
#import "CDCircleThumb.h"
#import "CDCircleOverlayView.h"
#import "CoreTextArcView.h"
#include <math.h>
#import "CustomView.h"
#import "CustomViewLabel.h"

@interface CDCircle()
{
    float               mAbsoluteTheta;
    float               mRelativeTheta;
    float               mDragSpeed;
    NSDate             *mDragBeforeDate;
    float               mDragBeforeTheta;
    NSTimer            *mDecelerateTimer;
}
- (void)timerStop;
- (void)decelerate;
//@property (strong,nonatomic)  CDCircle *pieChart;
@property (nonatomic,assign) float decelerateRate;//减速参数,
@property (nonatomic, strong) CDCircleThumb *currentThumb;
@property (nonatomic,strong) UIButton *centerView;
@property (nonatomic,strong) NSArray *sectionStrArr;//转轮文字
@property (nonatomic,strong) NSArray *sectionImgArr;//转轮图片
@property (nonatomic,assign) CGRect temFram;
@end


@implementation CDCircle
@synthesize circle, recognizer, path, numberOfSegments, separatorStyle, overlayView, separatorColor, ringWidth, circleColor, thumbs, overlay;
@synthesize delegate;
@synthesize inertiaeffect;
//Need to add property "NSInteger numberOfThumbs" and add this property to initializer definition, and property "CGFloat ringWidth equal to circle radius - path radius. 

//Circle radius is equal to rect / 2 , path radius is equal to rect1/2.
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(id) initWithFrame:(CGRect)frame numberOfSegments: (NSInteger) nSegments ringWidth: (CGFloat) width SectionImageArr:(NSArray *)imgArr andSectionStrArr:(NSArray *)strArr
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.temFram = frame;
        self.inertiaeffect = YES;
        self.sectionImgArr = imgArr;
        self.sectionStrArr = strArr;
        self.opaque = NO;
        self.numberOfSegments = nSegments;
        self.separatorStyle = CDCircleThumbsSeparatorBasic;
        self.ringWidth = width;
        self.circleColor = [UIColor clearColor];//中心圆与扇形分隔线颜色
        
        
        CGRect rect1 = CGRectMake(0, 0, CGRectGetHeight(frame) - (2*ringWidth), CGRectGetWidth(frame) - (2*ringWidth));
        self.thumbs = [NSMutableArray array];
        
        for (int i = 0; i < self.numberOfSegments; i++)
        {
            CDCircleThumb * thumb = [[CDCircleThumb alloc] initWithShortCircleRadius:rect1.size.height/2
                                                                          longRadius:frame.size.height/2
                                                                    numberOfSegments:self.numberOfSegments];
            
            thumb.sectionLabel.text = [NSString stringWithFormat:@"%d",i];
            [self.thumbs addObject:thumb];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(goOrStopRotated:)
                                                     name:@"GoOrStop" object:nil];
        mRelativeTheta = 0.0;
        _decelerateRate = 0;
    }
    return self;
}

#pragma mark -Rotated

#pragma mark -响应开始/停止按钮点击事件
- (void)goOrStopRotated:(NSNotification *)notification
{
    BOOL isGo = [notification.object boolValue];
    //[_currentThumb.iconView setIsSelected:NO];
    
    if (isGo)
    {
        mAbsoluteTheta = 0;
        _decelerateRate = 0;
        if ([mDecelerateTimer isValid])
        {
            [mDecelerateTimer invalidate];
            mDecelerateTimer = nil;
        }
        mDragSpeed = 0;
        mDragBeforeDate  = [[NSDate date] copy];//??是否内存泄露,待定
        mDragBeforeTheta = 0.0f;
        mDragSpeed = K_MAX_SPEED;
        mDecelerateTimer = [NSTimer timerWithTimeInterval:0.01
                                                   target:self
                                                 selector:@selector(decelerate)
                                                 userInfo:nil
                                                  repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:mDecelerateTimer forMode:NSDefaultRunLoopMode];
        
    }
    else//点击了停止按钮
    {
        _decelerateRate = (K_FRICTION / 2);
        
    }
}



#pragma mark handle rotation angle
- (float)thetaForX:(float)x andY:(float)y {
    if (IS_ZERO_FLOAT(y)) {
        if (x < 0) {
            return M_PI;
        } else {
            return 0;
        }
    }
    
    float theta = atan(y / x);
    if (x < 0 && y > 0) {
        theta = M_PI + theta;
    } else if (x < 0 && y < 0) {
        theta = M_PI + theta;
    } else if (x > 0 && y < 0) {
        theta = 2 * M_PI + theta;
    }
    return theta;
}

/* 计算将当前以相对角度为单位的触摸点旋转到绝对角度为newTheta的位置所需要旋转到的角度(*_*!真尼玛拗口) */
- (float)rotationThetaForNewTheta:(float)newTheta {
    float rotationTheta;
    if (mRelativeTheta > (3 * M_PI / 2) && (newTheta < M_PI / 2))
    {
        rotationTheta = newTheta + (2 * M_PI - mRelativeTheta);
    }
    else
    {
        rotationTheta = newTheta - mRelativeTheta;
    }
    return rotationTheta;
}

- (float)thetaForTouch:(UITouch *)touch onView:view {
    CGPoint location = [touch locationInView:view];
    float xOffset    = self.bounds.size.width / 2;
    float yOffset    = self.bounds.size.height / 2;
    float centeredX  = location.x - xOffset;
    float centeredY  = location.y - yOffset;
    return [self thetaForX:centeredX andY:centeredY];
}

#pragma mark -
#pragma mark Private & handle rotation
- (void)timerStop {
    [mDecelerateTimer invalidate];
    mDecelerateTimer = nil;
    mDragSpeed = 0;

    for (CDCircleThumb *thumb in self.thumbs)
    {
        CGPoint point = [thumb convertPoint:thumb.centerPoint toView:nil];
        CDCircleThumb *shadow = self.overlayView.overlayThumb;
        CGRect shadowRect = [shadow.superview convertRect:shadow.frame toView:nil];
        
        if (CGRectContainsPoint(shadowRect, point) == YES)
        {
            CGPoint pointInShadowRect = [thumb convertPoint:thumb.centerPoint toView:shadow];
            if (CGPathContainsPoint(shadow.arc.CGPath, NULL, pointInShadowRect, NULL))
            {
                CGAffineTransform current = self.transform;
                CGFloat deltaAngle= - degreesToRadians(180) + atan2(self.transform.a, self.transform.b) + atan2(thumb.transform.a, thumb.transform.b);
                [UIView animateWithDuration:2.2f animations:^{
                    [self setTransform:CGAffineTransformRotate(current, deltaAngle)];
                }];
                
                self.currentThumb = thumb;
                
                //Delegate method
                [self.delegate circle:self didMoveToSegment:thumb.tag thumb:thumb];
                break;
            }
            
        }
    }
    
    return;
}

#pragma mark -旋转减速
- (void)decelerate {
    if (mDragSpeed > 0)
    {
        mDragSpeed -= _decelerateRate;//_decelerateRate初始为0,点击停止按钮后>0.
        
        if (mDragSpeed < K_MAX_SPEED / 8) {
            _decelerateRate = K_FRICTION /5;
        }
        
        if (mDragSpeed < 0.001) {
            [self timerStop];
        }
        
        mAbsoluteTheta += (mDragSpeed / 1000);
        if ((M_PI * 2) < mAbsoluteTheta)
        {
            mAbsoluteTheta -= (M_PI * 2);
        }
        
    }
    
    [UIView beginAnimations:@"pie rotation" context:nil];
    [UIView setAnimationDuration:0.01];
    CGFloat transformRotation = [self rotationThetaForNewTheta:mAbsoluteTheta];
    self.transform = CGAffineTransformMakeRotation(transformRotation);
    [UIView commitAnimations];
    
    return;
}





#pragma Rotated end 



-(void) drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState (ctx);
    CGContextSetBlendMode(ctx, kCGBlendModeCopy);
    
    [self.circleColor setFill];
    circle = [UIBezierPath bezierPathWithOvalInRect:rect];
    [circle closePath];
    [circle fill];
    
    
    CGRect rect1 = CGRectMake(0, 0, CGRectGetHeight(rect) - (2*ringWidth), CGRectGetWidth(rect) - (2*ringWidth));
    rect1.origin.x = rect.size.width / 2  - rect1.size.width / 2;
    rect1.origin.y = rect.size.height / 2  - rect1.size.height / 2;
    
    
    path = [UIBezierPath bezierPathWithOvalInRect:rect1];
    [self.circleColor setFill];
    [path fill];
    CGContextRestoreGState(ctx);
    
    
    //Drawing Thumbs
    CGFloat fNumberOfSegments = self.numberOfSegments;
    CGFloat perSectionDegrees = 360.f / fNumberOfSegments;
    CGFloat totalRotation = 360.f / fNumberOfSegments;
    CGPoint centerPoint = CGPointMake(rect.size.width/2, rect.size.height/2);
    CGFloat deltaAngle;
    
    
    
    //
    //CGFloat angleSize = 2*M_PI/(self.numberOfSegments+1);//DEL
    
    for (int i = 0; i < self.numberOfSegments; i++)
    {
        CDCircleThumb * thumb = [self.thumbs objectAtIndex:i];
        thumb.tag = i;
        //thumb.iconView.image = [self.dataSource circle:self iconForThumbAtRow:thumb.tag];
        CGFloat radius = rect1.size.height/2 + ((rect.size.height/2 - rect1.size.height/2)/2) - thumb.yydifference;
        CGFloat x = centerPoint.x + (radius * cos(degreesToRadians(perSectionDegrees)));
        CGFloat yi = centerPoint.y + (radius * sin(degreesToRadians(perSectionDegrees)));
        [thumb setTransform:CGAffineTransformMakeRotation(degreesToRadians((perSectionDegrees + kRotationDegrees)))];
        if (i==0)
        {
            deltaAngle= degreesToRadians(360 - kRotationDegrees) + atan2(thumb.transform.a, thumb.transform.b);
            //[thumb.iconView setIsSelected:YES];
            self.recognizer.currentThumb = thumb;
        }
       
        
        //set position of the thumb
        thumb.layer.position = CGPointMake(x, yi);
        //thumb.iconView.layer.position = CGPointMake(x,yi);
        perSectionDegrees += totalRotation;
         [self addSubview:thumb];          
    }
    [self bringSubviewToFront:self.centerView];
    [self setTransform:CGAffineTransformRotate(self.transform,deltaAngle)];
    [self drawCircle];
   
 }
- (void)drawCircle
{

    CGFloat angleSize = 2*M_PI/self.numberOfSegments;
    
//    UIImageView *mask = [[UIImageView alloc] initWithFrame:CGRectMake((283-280)/2, (283-280)/2, 280, 280)];
//    mask.image =[UIImage imageNamed:@"background.png"] ;
//    [self addSubview:mask];
    
    
    for (int i = 0; i < self.numberOfSegments; i++)
    {
        UIImageView *im = nil;
        if (i%2==0) {
            im = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"segment.png"]];
        }
        else{
            im = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"segmentWhite.png"]];
        }
        
        im.layer.anchorPoint = CGPointMake(1.0f, 0.5f);
        im.layer.position = CGPointMake(self.bounds.size.width/2,
                                        self.bounds.size.height/2);
        im.transform = CGAffineTransformMakeRotation(angleSize*(i-3));
        //im.alpha = minAlphavalue;
        im.tag = i;
        
        if (i == 0) {
            //im.alpha = maxAlphavalue;
        }
        
        //添加图片
        CustomView *cloveImgeView = [[CustomView alloc]initWithFrame:CGRectMake(28, 10, 108, 90) withImgeString:_sectionImgArr[i]];
        [im addSubview:cloveImgeView];
        
        UIImageView *imageViews = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 137, 109)];
        if (i%2==0) {
            imageViews.image = [UIImage imageNamed:@"greenColor.png"];
        }
        else{
            imageViews.image = [UIImage imageNamed:@"writeColor"];
        }
        [im addSubview:imageViews];
        
        
        CGRect rect1 = CGRectMake(7,10, 90, 90);
        
        
        NSMutableArray *dtaArray  =[[NSMutableArray alloc]init];
        
        NSString *newStr = [_sectionStrArr objectAtIndex:i];
        
        NSString *temp =nil;
        for(int i =0; i < newStr.length; i++)
        {
            temp = [newStr substringWithRange:NSMakeRange(i, 1)];
            [dtaArray addObject:temp];
        }
        
        
        
        CustomViewLabel *cityLabel = [[CustomViewLabel alloc]initWithFrame:rect1 withArray:dtaArray];
        cityLabel.backgroundColor = [UIColor clearColor];
        
        cityLabel.transform = CGAffineTransformMakeRotation(3*M_PI/2);
        [imageViews addSubview:cityLabel];
        [self addSubview:im];
    }


}

-(void) tapped: (CDCircleGestureRecognizer *) arecognizer
{
//    if (arecognizer.ended == NO)
//    {
//        CGPoint point = [arecognizer locationInView:self];
//        if ([path containsPoint:point] == NO)
//        {
//            [self setTransform:CGAffineTransformRotate([self transform], [arecognizer rotation])];
//        }
//    }
    [self setTransform:CGAffineTransformRotate([self transform], [arecognizer rotation])];
}

@end
