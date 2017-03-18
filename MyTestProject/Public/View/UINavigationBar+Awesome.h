//
//  UINavigationBar+Awesome.h
//  LTNavigationBar
//
//  Created by ltebean on 15-2-15.
//  Copyright (c) 2015 ltebean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (Awesome)
- (void)fp_setBackgroundColor:(UIColor *)backgroundColor;
- (void)fp_setContentAlpha:(CGFloat)alpha;
- (void)fp_setTranslationY:(CGFloat)translationY;
- (void)fp_setShadowImageVisible:(BOOL)visible;
- (void)fp_reset;
@end
