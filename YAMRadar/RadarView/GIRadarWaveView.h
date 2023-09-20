//
//  GIRadarWaveView.h
//  YAMRadar
//
//  Created by YAM on 2022/6/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GIRadarWaveView : UIView
//设置缩放因子
@property (nonatomic, assign) CGFloat scaleFactor;
/** 0 慢 1 快 */
@property (nonatomic, assign) NSInteger speed;
@end

NS_ASSUME_NONNULL_END
