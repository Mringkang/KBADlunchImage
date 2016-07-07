//
//  ADPageViewController.m
//  adImageLunch
//
//  Created by kangbing on 16/7/7.
//  Copyright © 2016年 kangbing. All rights reserved.
//

#import "ADPageViewController.h"

@interface ADPageViewController ()

@end

@implementation ADPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UILabel *lbl = [[UILabel alloc]init];
    lbl.text = @"广告详情页";
    [self.view addSubview:lbl];
    
    lbl.bounds = CGRectMake(0, 0, 150, 22);
    
    lbl.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
