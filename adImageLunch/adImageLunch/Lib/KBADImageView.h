//
//  KBADImageView.h
//  adImageLunch
//
//  Created by kangbing on 16/7/7.
//  Copyright © 2016年 kangbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

typedef NS_ENUM(NSInteger, KBADType) {
    FullScreenAdType = 0,  // 全屏
    LogoAdType = 1 // 带底部logo
};


#define KBHeight      [[UIScreen mainScreen] bounds].size.height
#define KBWidth       [[UIScreen mainScreen] bounds].size.width


@interface KBADImageView : UIView

@property (strong, nonatomic) UIImageView *adImgView;
@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) NSInteger secondsCountDown; //倒计时总时长
@property (strong, nonatomic) UIButton *skipBtn;  // 跳过按钮
@property (nonatomic, copy) void(^btnClickBlock)(NSInteger tag);

- (instancetype)initWithWindow:(UIWindow *)window andWithType:(KBADType)type andWithImgUrl:(NSString *)url;

@end
