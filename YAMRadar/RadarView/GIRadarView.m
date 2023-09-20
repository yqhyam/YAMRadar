//
//  GIRadarView.m
//  YAMRadar
//
//  Created by YAM on 2022/6/17.
//

#import "GIRadarView.h"
#import "GIRadarWaveView.h"
#import "GIRadarAvatarView.h"
#import "UIView+Extension.h"
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)

#define kYNPAGE_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
/** 头像默认宽高 */
static CGFloat const kRadarDefaultAvatarHeight = 52;

@interface GIRadarView()<CAAnimationDelegate>
/** 角度数组 */
@property (nonatomic, copy) NSArray<NSNumber *> * kAvatarAngles;
/** 出现时间 */
@property (nonatomic, copy) NSArray<NSNumber *> * kAvatarTimes;
/** 当前进度 (总11) */
@property (nonatomic, assign) NSInteger currentIndex;
/** isstop */
@property (nonatomic, assign) BOOL isStop;
/** 水波纹动画 */
@property (nonatomic, strong) GIRadarWaveView * waveView;
/** 登录头像 */
@property (nonatomic, strong) UIImageView * avatarImageView;
/** 头像运动时间 */
@property (nonatomic, assign) CGFloat avatarAnimateTime;
/** 图片数组 */
@property (nonatomic, strong) NSMutableArray<GIRadarAvatarView *> * avatars;
@end

@implementation GIRadarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _avatarImageView.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
}

- (void)setupViews {
    /** 角度数组 */
    self.kAvatarAngles = @[@(0), @(62), @(138), @(170), @(234), @(312),
                           @(23), @(88), @(120), @(280), @(240),
                           @(12), @(47), @(138), @(214), @(325),
                           @(35), @(102), @(188), @(248), @(240)];
    /** 出现时间 */
    self.kAvatarTimes = @[@(0.5), @(0.5), @(0.5), @(0.25), @(0.5),
                          @(1), @(0.5), @(1), @(1), @(1),
                          @(0.5), @(0.5), @(0.5), @(0.25), @(0.5),
                          @(0.5), @(1), @(0.5), @(1), @(0.5)];
    self.currentIndex = 0;
    self.avatars = [NSMutableArray array];
    self.backgroundColor = [UIColor clearColor];
    self.avatarAnimateTime = 2;
    
    GIRadarWaveView* animationView = [[GIRadarWaveView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
    animationView.center = CGPointMake(kScreenWidth/2.f, kScreenWidth/2.f);
    [self addSubview:animationView];
    self.waveView = animationView;
    
    _avatarImageView = [UIImageView new];
    _avatarImageView.image = [UIImage imageNamed:@"Unknown"];
    _avatarImageView.layer.cornerRadius = 39;
    _avatarImageView.layer.masksToBounds = true;
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    _avatarImageView.layer.borderWidth = 2.4;
    _avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _avatarImageView.frame = CGRectMake(0, 0, 78, 78);
//    _avatarImageView.alpha = 0.5;
    [self addSubview:_avatarImageView];
    
}

- (CGPoint)randomRadius:(CGPoint)center  andWithAngle:(CGFloat) angle andWithRadius:(CGFloat)radius {
    CGFloat baseR = radius;
    //随机半径
    radius = baseR+arc4random()%(6*10);

    CGPoint point = [self calcCircleCoordinateWithCenter:center andWithAngle:angle andWithRadius:radius];
    
    if (![self isInRect:point]) {
        radius = baseR;
        point = [self calcCircleCoordinateWithCenter:center andWithAngle:angle andWithRadius:radius];
    }
    
    return point;
}

- (CGPoint)calcCircleCoordinateWithCenter:(CGPoint)center  andWithAngle:(CGFloat) angle andWithRadius:(CGFloat)radius{
    
    CGFloat x2 = radius * cosf(angle * M_PI/180);

    CGFloat y2 = radius * sinf(angle * M_PI/180);
        
    return CGPointMake(center.x+x2, center.y + y2);

}

- (BOOL)isInRect:(CGPoint) point{
    
    point.x = point.x - 0.5*kRadarDefaultAvatarHeight;
    point.y = point.y - 0.5*kRadarDefaultAvatarHeight;
    
    if (point.x < 0 || point.x + kRadarDefaultAvatarHeight > self.width || point.y < 0 || point.y+kRadarDefaultAvatarHeight > self.height) {
        
        return NO;
    }
    else {
        return YES;
    }
}

- (void)avatarGroupAnimation {
    
    if (self.isStop) {
        return;
    }
    
    if (self.currentIndex >= _kAvatarAngles.count) {
        self.currentIndex = 0;
    }
    // 随机角度
//    CGFloat angle = arc4random() % 360;
    CGFloat angle = [[_kAvatarAngles objectAtIndex:self.currentIndex] floatValue];
    
    CGPoint orignPoint = [self calcCircleCoordinateWithCenter:CGPointMake(self.width/2.f, self.height/2.f) andWithAngle:angle andWithRadius:kRadarDefaultAvatarHeight/2.0 + 10];
    CGPoint targetPoint = [self calcCircleCoordinateWithCenter:CGPointMake(self.width/2.f, self.height/2.f) andWithAngle:angle andWithRadius:self.width/2.f];

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:orignPoint];
    [path addLineToPoint:targetPoint];
    
    GIRadarAvatarView *animationView = [GIRadarAvatarView new];
    animationView.aniKey = [[NSUUID UUID] UUIDString];
    animationView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Unknown%u", arc4random() % 5]];
    animationView.frame = CGRectMake(self.width/2.0, self.height/2.f, kRadarDefaultAvatarHeight, kRadarDefaultAvatarHeight);
    animationView.layer.cornerRadius = kRadarDefaultAvatarHeight/2.f;
    animationView.layer.masksToBounds = true;
    [self insertSubview:animationView belowSubview:self.avatarImageView];
    [self.avatars addObject:animationView];
    
    //执行动画
    CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation1.path = path.CGPath;
    
    CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    animation2.values = @[@(1), @(0)];
    animation2.keyTimes = @[@0.7, @1];
    
    CABasicAnimation* scaleAnimation  = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = @(0.1);
    scaleAnimation.toValue = @(1);
    
    CAAnimationGroup* animationGroup = [CAAnimationGroup animation];
    animationGroup.delegate = self;
    animationGroup.duration = self.avatarAnimateTime;
    animationGroup.repeatCount = 1;
    animationGroup.animations = @[animation1, animation2, scaleAnimation];
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode=kCAFillModeForwards;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [animationView.layer addAnimation:animationGroup forKey:animationView.aniKey];
    
    if (self.currentIndex >= _kAvatarTimes.count) {
        self.currentIndex = 0;
    }
    CGFloat time = [[_kAvatarTimes objectAtIndex:self.currentIndex] floatValue];
    if (self.speed == GIRadarViewSpeedFast) {
        time = time/2.f;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self avatarGroupAnimation];
    });
    
    self.currentIndex ++;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.avatars enumerateObjectsUsingBlock:^(GIRadarAvatarView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.layer animationForKey:obj.aniKey] == anim) {
            [obj.layer removeAllAnimations];
            [obj removeFromSuperview];
            [self.avatars removeObject:obj];
        }
    }];
}


- (void)add {
    if (self.isStop) {
        return;
    }
    [self avatarGroupAnimation];
}

- (void)start {
    [self avatarGroupAnimation];
}

- (void)stop {
    if (self.isStop) {
        return;
    }
    self.isStop = true;
    self.waveView.speed = -1;
    for (GIRadarAvatarView *v in self.avatars) {
        [v.layer removeAllAnimations];
        [v removeFromSuperview];
    }
    [self.avatars removeAllObjects];
}

- (void)reload {
    switch (_speed) {
        case GIRadarViewSpeedSlow:
        {
            self.avatarAnimateTime = 10;
        }
            break;
        case GIRadarViewSpeedFast:
        {
            self.avatarAnimateTime = 5;
        }
            break;
        default:
            break;
    }
    self.waveView.speed = self.speed;
    self.isStop = false;
}

@end
