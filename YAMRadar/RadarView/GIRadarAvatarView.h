//
//  GIRadarAvatarView.h
//  YAMRadar
//
//  Created by YAM on 2022/6/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GIRadarAvatarView : UIImageView
/** 动画key */
@property (nonatomic, copy) NSString * aniKey;
/** 角度 */
@property (nonatomic, assign) CGFloat angle;
@end

NS_ASSUME_NONNULL_END
