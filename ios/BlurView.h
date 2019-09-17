#import <UIKit/UIKit.h>
#import "BlurEffectWithAmount.h"

@interface BlurView : UIView

@property (nonatomic, copy) NSString *blurType;
@property (nonatomic, copy) NSNumber *blurAmount;
@property (nonatomic) BOOL blurEnabled;
@property (nonatomic) BOOL blurDefaultedToEnabled;

@property (nonatomic, strong) BlurEffectWithAmount *blurEffect;
@property (nonatomic, strong) UIVisualEffectView *blurEffectView;

- (void)updateBlurEffect;
@end
