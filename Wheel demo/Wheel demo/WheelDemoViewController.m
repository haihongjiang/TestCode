//
//  WheelDemoViewController.m
//  Wheel demo
//
//  Created by Wojciech Czekalski on 01.05.2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WheelDemoViewController.h"
#import "CDCircleOverlayView.h"
@interface WheelDemoViewController ()
@property (nonatomic,strong) UIButton *goAndStopBtn;
@property (nonatomic,assign) BOOL isGo;//按钮标记,是否已按开始
@end

@implementation WheelDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarHidden = YES;
    NSArray *sectionStrArr = [NSArray arrayWithObjects:@"零",@"测一",@"测试二" ,@"测试三三",@"测试四四四",@"测试五五五五",@"测试六六六六六",@"测试七七七七七七", nil];//[NSArray arrayWithObjects:@"零",@"测一",@"测试二" ,@"一一一一",@"一一一一一",@"一一一一一一",@"一一一一一一一",@"一一一一一一一一", nil];
    
    NSArray *sectionImageArr = [NSArray arrayWithObjects:@"rest1.png",@"rest2.png",@"rest3.png",@"rest4.png",@"restau.png",@"rest1.png",@"rest2.png",@"rest3.png", nil];
    CDCircle *circle = [[CDCircle alloc] initWithFrame:CGRectMake(20 , 80, 280, 280) numberOfSegments:8 ringWidth:140.f SectionImageArr:sectionImageArr andSectionStrArr:sectionStrArr];

    circle.delegate = self;
    circle.separatorColor = [UIColor redColor];
    CDCircleOverlayView *overlay = [[CDCircleOverlayView alloc] initWithCircle:circle];
    self.view.backgroundColor = [UIColor whiteColor];
    //*******************************
    //添加顺序不可调转:
    [self.view addSubview:circle];
    [self.view addSubview:overlay];
    //*******************************
    _goAndStopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *goImg = [UIImage imageNamed:@"go.jpg"];
    _goAndStopBtn.frame = CGRectMake((DEVICE_WIDTH - 70)/2, 400, 70, 40);
    [_goAndStopBtn setBackgroundImage:goImg forState:UIControlStateNormal];
    [_goAndStopBtn setTitle:@"Go!" forState:UIControlStateNormal];
    [_goAndStopBtn setBackgroundColor:[UIColor blueColor]];
    [_goAndStopBtn addTarget:self action:@selector(goOrStop:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:_goAndStopBtn];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Circle delegate 转动停止后触发.

-(void) circle:(CDCircle *)circle didMoveToSegment:(NSInteger)segment thumb:(CDCircleThumb *)thumb {
    NSString *alertStr;
    if (segment == 0)
    {
        alertStr = @"恭喜,您什么都没中!";
    }
    else
    {
        alertStr = [NSString stringWithFormat:@"恭喜,您中了%u千万!", segment];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:alertStr delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    
    
}


#pragma mark -按下抽奖按钮
- (void)goOrStop:(id)sender
{
    if (!_isGo)
    {
        [_goAndStopBtn setTitle:@"Stop" forState:UIControlStateNormal];
    }
    else
    {
        [_goAndStopBtn setTitle:@"Go!" forState:UIControlStateNormal];
    }
    _isGo = !_isGo;
    
    //RotatedView接收:
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"GoOrStop"
     object:[NSNumber numberWithBool:_isGo] userInfo:nil];
}


@end
