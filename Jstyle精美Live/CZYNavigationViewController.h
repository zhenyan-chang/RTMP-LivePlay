//
//  CZYNavigationViewController.h
//  Jstyle精美Live
//
//  Created by 精美 on 16/9/7.
//  Copyright © 2016年 zhenyan_C. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZYNavigationViewController : UINavigationController

/**
 *  改变支持的旋转方向
 *
 *  @param interfaceOrientation
 */
- (void)changeSupportedInterfaceOrientations:(UIInterfaceOrientationMask)interfaceOrientationMask;

@end
