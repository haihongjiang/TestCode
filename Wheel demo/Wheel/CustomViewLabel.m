//
//  CustomViewLabel.m
//  RotaryWheelProject
//
//  Created by Leo on 13-12-27.
//
//

#import "CustomViewLabel.h"
#define PI 3.14159265358979323846
#define   DEGREES_TO_RADIANS(degrees)  ((PI * degrees)/ 180)
@implementation CustomViewLabel
@synthesize label0,label1,label2,label3,label4,label5,label6,label7,arrayData;

- (id)initWithFrame:(CGRect)frame withArray:(NSMutableArray*)array{
    
    self = [super initWithFrame:frame];
    arrayData = [array copy];
    
//    NSLog(@"%@",[arrayData  objectAtIndex:0]);
  
    if (self) {
       

//        NSLog(@"%@",arrayData);
       
        UIFont *font1   =  [UIFont fontWithName:@"Helvetica" size:12];
        label0 = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 20, 20)];
        label0.textColor = [UIColor blackColor];
        label0.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-15));
        label0.font = font1;
        label0.backgroundColor = [UIColor clearColor];
        [self addSubview:label0];
        
        
        label1 = [[UILabel alloc]initWithFrame:CGRectMake(11,2, 20, 20)];
        label1.backgroundColor = [UIColor clearColor];
        label1.font =  font1;
        label1.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-15)) ;
        [self addSubview:label1];
       
       label2 = [[UILabel alloc]initWithFrame:CGRectMake(22,-1, 20, 20)];
       label2.backgroundColor = [UIColor clearColor];
       label2.font = font1;
       label2.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-12));
       [self addSubview:label2];
        
        label3 = [[UILabel alloc]initWithFrame:CGRectMake(35, -1, 20, 20)];
        label3.backgroundColor = [UIColor clearColor];
        label3.font = font1;
        label3.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0));
        [self addSubview:label3];
        
        label4 = [[UILabel alloc]initWithFrame:CGRectMake(48, 0, 20, 20)];
        label4.backgroundColor = [UIColor clearColor];
        label4.font = font1;
        label4.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(5));
        [self addSubview:label4];
        
        label5 = [[UILabel alloc]initWithFrame:CGRectMake(60, 1, 20, 20)];
        label5.backgroundColor = [UIColor clearColor];
        label5.font = font1;
        label5.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(12));
        [self addSubview:label5];
        
        label6 = [[UILabel alloc]initWithFrame:CGRectMake(70, 5, 20, 20)];
        label6.backgroundColor = [UIColor clearColor];
        label6.font = font1;
        label6.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(15));
        [self addSubview:label6];

       label7 = [[UILabel alloc]initWithFrame:CGRectMake(84, 8, 20, 20)];
       label7.backgroundColor = [UIColor clearColor];
       label7.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(15));
       label7.font =font1;
       [self addSubview:label7];
       [self sort];
//        
    }
    return self;
}

- (void)sort
{
   
//    NSLog(@"%d",arrayData.count);
    for (int a = 0; a < arrayData.count; a++) {
        if (arrayData.count>0&&arrayData.count<=8) {
            
       
      
        switch (arrayData.count) {
            case 0:
                
                break;
            case 1:
                
                label3.frame =CGRectMake(40, -1, 20, 20);
                label3.backgroundColor = [UIColor clearColor];
              
                label3.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0));

                label3.text = [arrayData objectAtIndex:0];

                             break;
            case 2 :
               
                label0.text = @"";
                label1.text = @"";
                label2.text = [arrayData objectAtIndex:0];
                label3.text = @"";
                label4.text = @"";
                label5.frame = CGRectMake(60, 0, 20, 20);
                label5.text = [arrayData objectAtIndex:1];
                label6.text = @"";
                label7.text = @"";
               
                break;
          case 3:
                
                label0.frame = CGRectMake(6, 4, 20, 20);
                label0.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-15)) ;
                
                label1.frame = CGRectMake(38, 0, 20, 20);
                label1.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0));
                
                
                label2.frame =CGRectMake(70, 4, 20, 20);
                label2.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(12));

                
                label0.text = [arrayData objectAtIndex:0];
                label1.text = [arrayData objectAtIndex:1];
                label2.text = [arrayData objectAtIndex:2];
                
                break;
                
                
         case 4:
                
                
                label0.frame = CGRectMake(6, 4, 20, 20);
                label0.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-15)) ;
                
                label1.frame = CGRectMake(28, 1, 20, 20);
                label1.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-5));
                
                
                label2.frame =CGRectMake(50, 2, 20, 20);
                label2.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(5));
                
                
                label3.frame = CGRectMake(70, 6, 20, 20);
                label3.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(15));
                
                label0.text =[arrayData objectAtIndex:0];
                label1.text =[arrayData objectAtIndex:1];
                label2.text =[arrayData objectAtIndex:2];
                label3.text =[arrayData objectAtIndex:3];
            
                
               
                break;
                
           case 5:
               label0.frame = CGRectMake(6, 3, 20, 20);
               label0.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-17));


                label1.frame = CGRectMake(23,0, 20, 20);
                label1.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-8)) ;

                
                
                label2.frame = CGRectMake(40,-1, 20, 20);
                label2.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0));
                
                
                label3.frame = CGRectMake(56,1, 20, 20);
                label3.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(10));
                

                label4.frame = CGRectMake(70,5, 20, 20);
                label4.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(16));

                label0.text = [arrayData objectAtIndex:0];
                label1.text = [arrayData objectAtIndex:1];
                label2.text = [arrayData objectAtIndex:2];
                label3.text = [arrayData objectAtIndex:3];
                label4.text = [arrayData objectAtIndex:4];
                
                break;
                
            case 6:
                
                
                
                label0.frame = CGRectMake(0, 3, 20, 20);
                label0.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-18));
                
                
                label1.frame = CGRectMake(15,-1, 20, 20);
                label1.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-10)) ;
                
                
                
                label2.frame = CGRectMake(33,-2, 20, 20);
                label2.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0));
                
                
                label3.frame = CGRectMake(48,-2, 20, 20);
                label3.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0));
                
                
                label4.frame = CGRectMake(63,1, 20, 20);
                label4.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(10));
                
                label5.frame = CGRectMake(78,5, 20, 20);
                label5.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(15));

      
                label0.text =[arrayData objectAtIndex:0];
                label1.text =[arrayData objectAtIndex:1];
                label2.text =[arrayData objectAtIndex:2];
                label3.text =[arrayData objectAtIndex:3];
                label4.text =[arrayData objectAtIndex:4];
                label5.text =[arrayData objectAtIndex:5];
             
            
                break;
                
            case 7:
                
                label0.frame = CGRectMake(-4, 5, 20, 20);
                label0.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-19));

                label1.frame = CGRectMake(12,1, 20, 20);
                label1.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-10)) ;
                
                
                label2.frame = CGRectMake(26,-1, 20, 20);
                label2.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-5));

                

                label3.frame = CGRectMake(40, -1, 20, 20);
                label3.backgroundColor = [UIColor clearColor];
                label3.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0));




                label4.frame = CGRectMake(53, 0, 20, 20);
                label4.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(5));
                
                
                label5.frame = CGRectMake(66, 2, 20, 20);
                label5.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(12));
               
                label6.frame = CGRectMake(79, 6, 20, 20);
                label6.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(17));

                
                
                label0.text =[arrayData objectAtIndex:0];
                label1.text =[arrayData objectAtIndex:1];
                label2.text =[arrayData objectAtIndex:2];
                label3.text =[arrayData objectAtIndex:3];
                label4.text =[arrayData objectAtIndex:4];
                label5.text =[arrayData objectAtIndex:5];
                label6.text =[arrayData objectAtIndex:6];
//              
//                宜慎加调摄用副
                break;
                
            case 8:
                
                
                label0.frame = CGRectMake(-5, 6, 20, 20);
                label0.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-20));
                
                label1.frame = CGRectMake(8,2, 20, 20);
                label1.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-11)) ;
                
                
                label2.frame = CGRectMake(20,0, 20, 20);
                label2.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-5));
                
                
                
                label3.frame = CGRectMake(32, 0, 20, 20);
                label3.backgroundColor = [UIColor clearColor];
                label3.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-2));
                
                
                
                
                label4.frame = CGRectMake(44, -1, 20, 20);
                label4.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(1));
                
                
                label5.frame = CGRectMake(57,1, 20, 20);
                label5.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(5));
                
                label6.frame = CGRectMake(69, 4, 20, 20);
                label6.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(15));
                

                label7.frame = CGRectMake(81, 7, 20, 20);
                label7.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(18));
                
                
                
                  label0.text =[arrayData objectAtIndex:0];
                  label1.text =[arrayData objectAtIndex:1];
                  label2.text =[arrayData objectAtIndex:2];
                  label3.text =[arrayData objectAtIndex:3];
                  label4.text =[arrayData objectAtIndex:4];
                  label5.text =[arrayData objectAtIndex:5];
                  label6.text =[arrayData objectAtIndex:6];
                  label7.text =[arrayData objectAtIndex:7];
//                不给他个知刀下次
            break;
                
                
            default:
                break;
        }
        
        
        }
        
        
        else {
        
        
            label0.frame = CGRectMake(-5, 6, 20, 20);
            label0.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-20));
            
            label1.frame = CGRectMake(7,2, 20, 20);
            label1.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-10)) ;
            
            
            label2.frame = CGRectMake(19,0, 20, 20);
            label2.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-5));
            
            
            
            label3.frame = CGRectMake(33, 0, 20, 20);
            label3.backgroundColor = [UIColor clearColor];
            label3.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0));
            
            
            
            
            label4.frame = CGRectMake(45, 0, 20, 20);
            label4.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-3));
            
            
            label5.frame = CGRectMake(58,2, 20, 20);
            label5.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(5));
            
            label6.frame = CGRectMake(70, 5, 20, 20);
            label6.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(15));
            
            
            label7.frame = CGRectMake(81, 7, 20, 20);
            label7.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(15));
            
            
            
            label0.text =[arrayData objectAtIndex:0];
            label1.text =[arrayData objectAtIndex:1];
            label2.text =[arrayData objectAtIndex:2];
            label3.text =[arrayData objectAtIndex:3];
            label4.text =[arrayData objectAtIndex:4];
            label5.text =[arrayData objectAtIndex:5];
            label6.text =[arrayData objectAtIndex:6];
            label7.text =[arrayData objectAtIndex:7];
        
        
        }
    }


}



@end
