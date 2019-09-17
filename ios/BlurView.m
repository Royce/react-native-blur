#import "BlurView.h"
#import "BlurEffectWithAmount.h"

@interface BlurView ()

@end

@implementation BlurView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.blurEffectView = [[UIVisualEffectView alloc] init];
        self.blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.blurEffectView.frame = frame;

        _blurDefaultedToEnabled = true;
        _blurEnabled = true;
        _blurAmount = @10;
        _blurType = @"dark";
        [self updateBlurEffect];

        self.clipsToBounds = true;

        [self addSubview:self.blurEffectView];
    }

    return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  self.blurEffectView.frame = self.bounds;
}


- (void)setBlurEnabled:(BOOL)blurEnabled
{
    if (blurEnabled) {
        if (self.blurDefaultedToEnabled) {
            self.blurDefaultedToEnabled = false;
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.blurEffectView) {
                    [_blurEffectView removeFromSuperview];
                }
                self.blurEffectView = [[UIVisualEffectView alloc] init];
                [self updateBlurEffect];
                
                self.blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                self.blurEffectView.frame = self.bounds;
                self.blurEffectView.alpha = 0;
                [self.superview.superview insertSubview:self.blurEffectView atIndex:self.superview.subviews.count];
                [UIView animateWithDuration:0.5 animations:^{
                    _blurEffectView.alpha = 1.0;
                }];
            });
        }
    } else {
        if (self.blurDefaultedToEnabled) {
            self.blurDefaultedToEnabled = false;
            [_blurEffectView removeFromSuperview];
            self.blurEffectView = nil;
        }
        if (self.blurEnabled && self.blurEffectView) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.5 animations:^{
                    self.blurEffectView.alpha = 0;
                } completion:^(BOOL finished) {
                    [_blurEffectView removeFromSuperview];
                    self.blurEffectView = nil;
                }];
            });
        }
    }
    
    _blurEnabled = blurEnabled;
}

- (void)setBlurType:(NSString *)blurType
{
  if (blurType && ![self.blurType isEqual:blurType]) {
    _blurType = blurType;
    [self updateBlurEffect];
  }
}

- (void)setBlurAmount:(NSNumber *)blurAmount
{
  if (blurAmount && ![self.blurAmount isEqualToNumber:blurAmount]) {
    _blurAmount = blurAmount;
    [self updateBlurEffect];
  }
}


- (UIBlurEffectStyle)blurEffectStyle
{
  if ([self.blurType isEqual: @"xlight"]) return UIBlurEffectStyleExtraLight;
  if ([self.blurType isEqual: @"light"]) return UIBlurEffectStyleLight;
  if ([self.blurType isEqual: @"dark"]) return UIBlurEffectStyleDark;

  #if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000 /* __IPHONE_10_0 */
    if ([self.blurType isEqual: @"regular"]) return UIBlurEffectStyleRegular;
    if ([self.blurType isEqual: @"prominent"]) return UIBlurEffectStyleProminent;
  #endif

  #if TARGET_OS_TV
    if ([self.blurType isEqual: @"regular"]) return UIBlurEffectStyleRegular;
    if ([self.blurType isEqual: @"prominent"]) return UIBlurEffectStyleProminent;
    if ([self.blurType isEqual: @"extraDark"]) return UIBlurEffectStyleExtraDark;
  #endif

  return UIBlurEffectStyleDark;
}

- (void)updateBlurEffect
{
//  if (!self.blurEffectView) return;
  
  UIBlurEffectStyle style = [self blurEffectStyle];
  self.blurEffect = [BlurEffectWithAmount effectWithStyle:style andBlurAmount:self.blurAmount];
  self.blurEffectView.effect = self.blurEffect;
}

@end
