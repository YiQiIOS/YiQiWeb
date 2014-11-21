

#import "UIImage+Redraw.h"
@implementation UIImage (Redraw)
+(UIImage*)redraw:(UIImage *)newImage Frame:(CGRect)frame{
    UIImage*image=newImage;
    UIGraphicsBeginImageContext(frame.size);
    [image drawInRect:frame];
    image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end

@implementation UIButton(addtion)

+(UIButton*)buttonWithType:(UIButtonType)buttonType frame:(CGRect)frame backgroundImage:(UIImage *)backgroundImage title:(NSString *)title target:(id)target action:(SEL)action{
    UIButton*button=[UIButton buttonWithType:buttonType];
    button.frame=frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
