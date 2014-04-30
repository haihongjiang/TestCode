#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface CustomView : UIView{
    NSString *_imageStr;
}

- (id)initWithFrame:(CGRect)frame withImgeString:(NSString *)imgStr;
@end