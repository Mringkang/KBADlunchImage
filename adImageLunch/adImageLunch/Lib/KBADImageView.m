//
//  KBADImageView.m
//  adImageLunch
//
//  Created by kangbing on 16/7/7.
//  Copyright © 2016年 kangbing. All rights reserved.
//

#import "KBADImageView.h"


@interface KBADImageView ()
// 定时器
@property (nonatomic, strong) NSTimer *timer;
// 点击识别
@property (nonatomic, copy) NSString *isClick;

@end

@implementation KBADImageView

- (instancetype)initWithWindow:(UIWindow *)window andWithType:(KBADType)type andWithImgUrl:(NSString *)url{

    if (self = [super init]) {
        _secondsCountDown = 6; // 倒计时
        self.window = window;
        [window makeKeyAndVisible];
        
        // 获取启动图
        CGSize viewSize  = window.bounds.size;;
        NSString *viewOrientation = @"Portrait";
        NSString *launchImageName = nil;
        NSArray *imageDict = [[[NSBundle mainBundle] infoDictionary]valueForKey:@"UILaunchImages"];
        for (NSDictionary  * dict in imageDict) {
            CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
            if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
                launchImageName = dict[@"UILaunchImageName"];
                
            }
        }
        
        
        UIImage *launchImage = [UIImage imageNamed:launchImageName];
        self.backgroundColor = [UIColor colorWithPatternImage:launchImage];
        self.frame = CGRectMake(0, 0, KBWidth, KBHeight);
        if (type == FullScreenAdType) {
            self.adImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KBWidth, KBHeight)];
        }else{
            self.adImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KBWidth, KBHeight - KBWidth/3)];
        }
        
        //  设置按钮
        self.skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.skipBtn.frame = CGRectMake(KBWidth - 70, 20, 60, 30);
        self.skipBtn.backgroundColor = [UIColor brownColor];
        self.skipBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.skipBtn addTarget:self action:@selector(skipBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.adImgView addSubview:self.skipBtn];
        
        // 设置按钮圆角
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.skipBtn.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(15, 15)]; // 下右和上右
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.skipBtn.bounds;
        maskLayer.path = maskPath.CGPath; // 绘制路径
        self.skipBtn.layer.mask = maskLayer;
        
        SDWebImageManager *manger = [SDWebImageManager sharedManager];
        [manger downloadImageWithURL:[NSURL URLWithString:url] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
           
            if (image) {
                // 画上, 等比例拉伸充满屏幕
                [self.adImgView setImage:[self imageCompressForWidth:image targetWidth:KBWidth]];
            }
            
        }];
        self.adImgView.tag = 1101;
        // 可以设置背景颜色
        self.adImgView.backgroundColor = [UIColor redColor];
        [self addSubview:self.adImgView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(activiTap:)];
        // 允许用户交互
        self.adImgView.userInteractionEnabled = YES;
        [self.adImgView addGestureRecognizer:tap];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        [self.window addSubview:self];
        
    }

    return self;

}
#pragma mark - 点击广告
- (void)activiTap:(UITapGestureRecognizer*)recognizer{
    _isClick = @"1";

    [self btnClick];
    
}
#pragma mark 点击跳过按钮
- (void)skipBtnClick{

    _isClick = @"2";
    
    [self btnClick];
    
}

#pragma mark 倒计时
- (void)onTimer{

    _secondsCountDown--;
    [self.skipBtn setTitle:[NSString stringWithFormat:@"%@ | 跳过",@(_secondsCountDown)] forState:UIControlStateNormal];
    
    
    if (_secondsCountDown == 0) {
        [self.timer invalidate];
        self.timer = nil;
        
        // 倒计时到0 , 开始消失
        [self btnClick];
    }

    

}

#pragma mark 点击按钮, 或者图片执行的方法
- (void)btnClick{

    [self.timer invalidate];
    self.timer = nil;
    self.hidden = YES;
    self.adImgView.hidden = YES;
    [self.adImgView removeFromSuperview];
    if ([_isClick integerValue] == 1) {
        
        if (self.btnClickBlock) {//点击广告
            self.btnClickBlock(1100);
        }
        
    }else if([_isClick integerValue] == 2){
        
        if (self.btnClickBlock) {//点击跳过
            self.btnClickBlock(1101);
        }
        
    }else{
        if (self.btnClickBlock) {//点击跳过
            self.btnClickBlock(1102);
        }
    }


}

#pragma mark - 指定宽度按比例缩放
- (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    //    UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}
    

@end
