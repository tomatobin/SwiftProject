//
//  NSData+LeChange.h
//  LCIphone
//
//  Owned by peng_kongan on 16/09/30.
//  Created by dh on 16/3/8.
//  Copyright © 2016年 dahua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (LeChange)

//加密
- (NSData *)lc_AES256Encrypt:(NSString *)key;

//解密
- (NSData *)lC_AES256Decrypt:(NSString *)key;


@end
