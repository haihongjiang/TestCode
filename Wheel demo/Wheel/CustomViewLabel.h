//
//  CustomViewLabel.h
//  RotaryWheelProject
//
//  Created by Leo on 13-12-27.
//
//

#import <UIKit/UIKit.h>


@interface CustomViewLabel : UIView
{

 

}
@property (nonatomic,retain) UILabel *label0;
@property (nonatomic,retain) UILabel *label1;
@property (nonatomic,retain) UILabel *label2;
@property (nonatomic,retain) UILabel *label3;
@property (nonatomic,retain) UILabel *label4;
@property (nonatomic,retain) UILabel *label5;
@property (nonatomic,retain) UILabel *label6;
@property (nonatomic,retain) UILabel *label7;
@property (nonatomic,retain) NSArray *arrayData;

- (id)initWithFrame:(CGRect)frame withArray:(NSArray*)array;

@end
