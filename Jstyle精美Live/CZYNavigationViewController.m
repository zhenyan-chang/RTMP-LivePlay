//
//  CZYNavigationViewController.m
//  Jstyle精美Live
//
//  Created by 精美 on 16/9/7.
//  Copyright © 2016年 zhenyan_C. All rights reserved.
//

#import "CZYNavigationViewController.h"

@interface CZYNavigationViewController ()
@property (nonatomic, assign) UIInterfaceOrientationMask interfaceOrientationMask;
@end

@implementation CZYNavigationViewController

/**
 *  改变支持的旋转方向
 *
 *  @param interfaceOrientationMask
 */
- (void)changeSupportedInterfaceOrientations:(UIInterfaceOrientationMask)interfaceOrientationMask
{
    self.interfaceOrientationMask = interfaceOrientationMask;
}

/**
 *  返回是否支持屏幕旋转
 *
 *  @return
 */
- (BOOL)shouldAutorotate
{
    return YES;
}

/**
 *  返回支持的旋转方向
 *
 *  @return
 */
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return self.interfaceOrientationMask;
}

@end
