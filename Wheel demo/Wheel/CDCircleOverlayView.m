/*
 Copyright (C) <2012> <Wojciech Czelalski/CzekalskiDev>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
#define K_EPSINON        (1e-127)
#define IS_ZERO_FLOAT(X) (X < K_EPSINON && X > -K_EPSINON)

#define K_FRICTION              5.0f   // 摩擦系数
#define K_MAX_SPEED             120.0f
#define K_POINTER_ANGLE         (M_PI / 2)

//****************************
#define kCDBorderAroundButton 3
#define degreesToRadians(x) (M_PI * x / 180.0)
#import "CDCircleOverlayView.h"
#import "CDCircle.h"
#include <math.h>
#import <QuartzCore/QuartzCore.h>
@interface CDCircleOverlayView ()
{
    float               mAbsoluteTheta;
    float               mRelativeTheta;
    float               mDragSpeed;
    NSDate             *mDragBeforeDate;
    float               mDragBeforeTheta;
    NSTimer            *mDecelerateTimer;
    float              decelerateRate;//减速参数,
    UIButton            *pointerImv;
    UIView              *pointerContainer;
    float                maxSpeed;
    BOOL                stoping;
    CGFloat             stopTransform;//点击停止按钮后,指针弹跳回落角度,(逐渐递增)
    BOOL                isTimeToStop;//进入停止方法的时机
    int                 swayCount;
    CGRect              temRect;
}

@end
@implementation CDCircleOverlayView
@synthesize circle, controlPoint, buttonCenter, overlayThumb;
- (id)initWithCircle:(CDCircle *)cicle
{
    CGRect frame = cicle.frame;
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.opaque = YES;
        self.circle = cicle;
        self.circle.overlayView = self;
        CGRect rect1 = CGRectMake(0, 0, CGRectGetHeight(self.circle.frame) - (2*circle.ringWidth), CGRectGetWidth(self.circle.frame) - (2*circle.ringWidth));
        rect1.origin.x = self.circle.frame.size.width / 2  - rect1.size.width / 2;
        rect1.origin.y = 0;

        
        overlayThumb = [[CDCircleThumb alloc] initWithShortCircleRadius:rect1.size.height/2 longRadius:self.circle.frame.size.height/2 numberOfSegments:self.circle.numberOfSegments];
        overlayThumb.gradientFill = YES;
        
        overlayThumb.layer.position = CGPointMake(CGRectGetWidth(frame)/2, circle.ringWidth/2);
        self.controlPoint = overlayThumb.layer.position;
        overlayThumb.arcColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0f];
        [overlayThumb.sectionLabel removeFromSuperview];
        //[overlayThumb.iconView removeFromSuperview];
        
        UIImage *centerImage = [UIImage imageNamed:@"center.png"];
        UIImage *poinimg = [UIImage imageNamed:@"arrow"];
        UIButton *centerBtn = [[UIButton alloc]initWithFrame:CGRectMake(overlayThumb.centerPoint.x, overlayThumb.centerPoint.y, centerImage.size.width, centerImage.size.height)];
        centerBtn.center = CGPointMake(overlayThumb.centerPoint.x, overlayThumb.centerPoint.y +overlayThumb.frame.size.height/2);
        [centerBtn setImage:centerImage forState:UIControlStateNormal];
        centerBtn.userInteractionEnabled = NO;
        [overlayThumb addSubview:centerBtn];
        
        
        

        
        pointerContainer = [[UIView alloc]initWithFrame:CGRectMake(overlayThumb.centerPoint.x, overlayThumb.centerPoint.y-poinimg.size.height,poinimg.size.width - 20, poinimg.size.height*2)];
        pointerContainer.center =CGPointMake(overlayThumb.centerPoint.x,-30);
        temRect = pointerContainer.frame;
        pointerImv = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, poinimg.size.width, poinimg.size.height)];
        //pointerImv.center = CGPointMake(overlayThumb.centerPoint.x, -15);
        [pointerImv setImage:poinimg forState:UIControlStateNormal];
        pointerImv.userInteractionEnabled = NO;
        pointerImv.center = CGPointMake(pointerContainer.frame.size.width/2, pointerContainer.frame.size.height/2 + pointerImv.frame.size.height/2);
        pointerContainer.backgroundColor = [UIColor clearColor];
        [pointerContainer addSubview:pointerImv];
        
        
        
        [overlayThumb addSubview:pointerContainer];
        
        /////////////
        overlayThumb.backgroundColor = [UIColor clearColor];
        [self addSubview:overlayThumb];
        self.buttonCenter = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(self.circle.frame));
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(goOrStopRotated:)
                                                     name:@"GoOrStop" object:nil];

              }


    return self;
}

#pragma mark -旋转减速
- (void)decelerate {

    
    if (!stoping || !isTimeToStop)
    {

        mDragSpeed -= decelerateRate;//_decelerateRate初始为0,点击停止按钮后>0.
        if (mDragSpeed < -maxSpeed)
        {
            mDragSpeed = maxSpeed;
        }
        
        if (stoping && mDragSpeed == maxSpeed )
        {
            isTimeToStop = YES;
            
            mAbsoluteTheta = -M_PI/4;
            //pointerContainer.transform = CGAffineTransformMakeRotation(-M_PI/4);
            decelerateRate = K_FRICTION / 8;
            maxSpeed = K_MAX_SPEED/4;
            stopTransform = -M_PI/16;
            mDragSpeed = -maxSpeed;
            return;
        }
        
        mAbsoluteTheta += (mDragSpeed / 1000);
        if ((M_PI / 4) < mAbsoluteTheta)
        {
            mAbsoluteTheta = 0;
        }
        else if ((-M_PI / 2) > mAbsoluteTheta)
        {
            mAbsoluteTheta = 0;
        }
    }
    else//减速
    {
        mDragSpeed += decelerateRate;//_decelerateRate初始为0,点击停止按钮后>0.
        //maxSpeed -= decelerateRate/5;
       // decelerateRate = decelerateRate * 99/100;
        if (swayCount < 4)
        {
            if (mDragSpeed > maxSpeed)
            {
                //maxSpeed = maxSpeed *0.99;
                
                mDragSpeed = -maxSpeed*0.69;
                NSLog(@">>>>>>>>>>>>>%f",decelerateRate);
                swayCount ++;

            }

        }
        else
        {
            
            decelerateRate = -K_FRICTION/3;
            if (mDragSpeed < 0) {
                [self timerStop];
            }
            //[self timerStop];
        }

 
        
        mAbsoluteTheta += (mDragSpeed / 1000);

        float x = fabsf(stopTransform);
    
        if (x < mAbsoluteTheta)
        {
            if (swayCount < 4)
            {
                mAbsoluteTheta = 0;
                stopTransform += M_PI/64;
                mDragSpeed = -maxSpeed * 0.9;
                swayCount++;
            }

            
            
        }
        else if ((-M_PI / 2) > mAbsoluteTheta)
        {
            mAbsoluteTheta = 0;
            //mDragSpeed = 0;
            
        }
    }

    
    [UIView beginAnimations:@"pie rotation" context:nil];
    [UIView setAnimationDuration:0.01];
    CGFloat transformRotation = [self rotationThetaForNewTheta:mAbsoluteTheta];
    pointerContainer.transform = CGAffineTransformMakeRotation(transformRotation);
    [UIView commitAnimations];
    
    return;
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
    if (isTimeToStop > (3 * M_PI / 2) && (newTheta < M_PI / 2))
    {
        rotationTheta = newTheta + (2 * M_PI - mRelativeTheta);
    }
    else
    {
        rotationTheta = newTheta - mRelativeTheta;
    }
    return rotationTheta;
}

#pragma mark Private & handle rotation
- (void)timerStop
{
    [mDecelerateTimer invalidate];
    mDecelerateTimer = nil;
    mDragSpeed = 0;
    
   
}


#pragma mark -响应开始/停止按钮点击事件
- (void)goOrStopRotated:(NSNotification *)notification
{
    BOOL isGo = [notification.object boolValue];
    //[_currentThumb.iconView setIsSelected:NO];
    
    if (isGo)
    {
        stoping = NO;
        swayCount = 0;
        isTimeToStop = NO;
        mAbsoluteTheta = -M_PI/4 - 0.2;
        maxSpeed = K_MAX_SPEED;
        decelerateRate = K_FRICTION*8;
        if ([mDecelerateTimer isValid])
        {
            [mDecelerateTimer invalidate];
            mDecelerateTimer = nil;
        }
        mDragSpeed = 0;
        mDragBeforeDate  = [[NSDate date] copy];//??是否内存泄露,待定
        mDragBeforeTheta = 0.0f;
        mDragSpeed = -K_MAX_SPEED/2;
        pointerContainer.transform = CGAffineTransformMakeRotation(-M_PI/4);
        mDecelerateTimer = [NSTimer timerWithTimeInterval:0.01
                                                   target:self
                                                 selector:@selector(decelerate)
                                                 userInfo:nil
                                                  repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:mDecelerateTimer forMode:NSDefaultRunLoopMode];
        
    }
    else//点击了停止按钮
    {
        stoping = YES;


        
    }
}


-(BOOL) pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return NO;
    
}

-(void) setCenter:(CGPoint)center {
    [super setCenter:center];
    [self.circle setCenter:buttonCenter];
}

@end
