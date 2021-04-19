//
//  UIAlertController+Extension.m
//  LCIphone
//
//  Owned by jiang_bin on 16/09/20.
//  Created by jiangbin on 16/8/2.
//  Copyright © 2016年 dahua. All rights reserved.
//

#import "UIAlertController+SupportedInterfaceOrientations.h"

@implementation UIAlertController (SupportedInterfaceOrientations)

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    return true;
}
@end
