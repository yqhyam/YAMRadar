//
//  GIRadarView.h
//  YAMRadar
//
//  Created by YAM on 2022/6/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GIRadarViewSpeed) {
    GIRadarViewSpeedSlow,
    GIRadarViewSpeedFast
};

@interface GIRadarView : UIView
/** 运动速度 */
@property (nonatomic, assign) GIRadarViewSpeed speed;

- (void)add;
- (void)stop;
- (void)start;
- (void)reload;

@end

NS_ASSUME_NONNULL_END
