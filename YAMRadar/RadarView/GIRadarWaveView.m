//
//  GIRadarWaveView.m
//  YAMRadar
//
//  Created by YAM on 2022/6/17.
//

#import "GIRadarWaveView.h"

#define WJRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

/** 慢速数量 */
static NSInteger const kDefaultRippleCount = 4;
/** 间隔时间 */
static CGFloat const kDefaultRippleDuration = 0.5;
/** 动画时间 */
static CGFloat const kDefaultAnimationDuration = 2;

@interface GIRadarWaveView()
/** 涟漪数量 */
@property (nonatomic, assign) NSInteger rippleCount;
/** 间隔时间 */
@property (nonatomic, assign) CGFloat rippleDuration;
/** 表示动画时间持续时间 */
@property (nonatomic, assign) CGFloat animationDuration;
/** CAReplicatorLayer */
@property (nonatomic, strong) CAReplicatorLayer * replicatorLayer;
@end

@implementation GIRadarWaveView

- (void)setSpeed:(NSInteger)speed {
    _speed = speed;
    if (speed < 0) {
        [_replicatorLayer removeFromSuperlayer];
        return;
    }
    self.rippleCount = (speed == 0) ? kDefaultRippleCount
    : 5;
    self.rippleDuration = (speed == 0) ? kDefaultRippleDuration : 1;
    self.animationDuration = (speed == 0) ? kDefaultAnimationDuration : 5;
    
    [_replicatorLayer removeFromSuperlayer];
    [self.layer addSublayer:[self replicatorLayer:self.frame]];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.scaleFactor = 1.6;
        
        self.rippleCount = kDefaultRippleCount;
        self.rippleDuration = kDefaultRippleDuration;
        self.animationDuration = kDefaultAnimationDuration;
        
        [self.layer addSublayer:[self replicatorLayer:frame]];
    }
    return self;
}

//复制图层
- (CAReplicatorLayer*) replicatorLayer:(CGRect) rect {
    CAReplicatorLayer* replicatorLayer = [[CAReplicatorLayer alloc] init];
    replicatorLayer.instanceCount = self.rippleCount;
    replicatorLayer.instanceDelay = self.rippleDuration;

    [replicatorLayer addSublayer:[self rippleBaseAnimationLayer:rect]];
    _replicatorLayer = replicatorLayer;
    return replicatorLayer;
}

- (CALayer *) rippleBaseAnimationLayer:(CGRect) rect {
    
    CALayer* baseLayer = [CALayer layer];
    baseLayer.opacity = 0;
    baseLayer.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    baseLayer.cornerRadius = rect.size.height / 2;
    baseLayer.borderColor = [UIColor.whiteColor colorWithAlphaComponent:0.1].CGColor;
    baseLayer.borderWidth = 24;
//    baseLayer.opacity = 0.4;
//    CAShapeLayer *borderLayer = [CAShapeLayer layer];
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:baseLayer.bounds cornerRadius:rect.size.width/2.f];
//    borderLayer.frame = baseLayer.bounds;
//    borderLayer.path = path.CGPath;
//    borderLayer.lineWidth = 40;
//    baseLayer.mask = borderLayer;
    
    [baseLayer addAnimation:[self rippleAnimation] forKey:@"rippleAnimationGroup"];
    
    return baseLayer;
}

//缩放动画
-(CABasicAnimation*) scaleAnimation{
    
    CABasicAnimation* scaleAnimation  = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    scaleAnimation.fromValue = @(0.1);
    scaleAnimation.toValue = @(self.scaleFactor);
    
    return scaleAnimation;
    
}

//背景颜色变化
- (CAKeyframeAnimation*) backgroudColorAnimation {
    
    CAKeyframeAnimation *backgroundColorAnimation = [CAKeyframeAnimation animation];
    
    backgroundColorAnimation.keyPath = @"backgroundColor";
    backgroundColorAnimation.values = @[(__bridge id)WJRGBA(255, 255, 255, 0.02).CGColor,
                                        (__bridge id)WJRGBA(255, 255, 255, 0.01).CGColor,
                                        (__bridge id)WJRGBA(255, 255, 255, 0).CGColor,
                                        (__bridge id)WJRGBA(255, 255, 255, 0).CGColor,
                                        ];
    backgroundColorAnimation.keyTimes = @[@0.3,@0.6,@0.9,@1];
    
    return backgroundColorAnimation;
}

//涟漪组合动画
- (CAAnimationGroup*) rippleAnimation{
    
    CAAnimationGroup* animationGroup = [CAAnimationGroup animation];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation2.fromValue = @0.3;
    animation2.toValue = @(0);
    
    animationGroup.duration = self.animationDuration;
    animationGroup.repeatCount = MAXFLOAT;
    animationGroup.animations = @[[self scaleAnimation],animation2, [self backgroudColorAnimation]];
//    animationGroup.animations = @[[self scaleAnimation],[self backgroudColorAnimation]];

    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode=kCAFillModeForwards;
//    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    return animationGroup;
}

@end
