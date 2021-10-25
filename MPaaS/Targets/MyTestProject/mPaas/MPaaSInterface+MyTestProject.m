//
//  MPaaSInterface+MyTestProject.m
//  MyTestProject
//
//  Created by jiangbin on 2021/09/15. All rights reserved.
//

#import "MPaaSInterface+MyTestProject.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@implementation MPaaSInterface (MyTestProject)

- (BOOL)enableSettingService
{
    return NO;
}

- (NSString *)userId
{
    return nil;
}

@end

#pragma clang diagnostic pop

