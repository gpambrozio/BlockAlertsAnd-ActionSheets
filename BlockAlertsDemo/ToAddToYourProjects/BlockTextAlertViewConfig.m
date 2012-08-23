//
//  BlockTextAlertViewConfig.m
//  BlockAlertsDemo
//
//  Created by Diego Chohfi on 8/22/12.
//  Copyright (c) 2012 CodeCrop Software. All rights reserved.
//

#import "BlockTextAlertViewConfig.h"

@implementation BlockTextAlertViewConfig

+ (BlockTextAlertViewConfig *) defaultConfig {
    BlockTextAlertViewConfig *config = [[[self alloc] init] autorelease];
    [config setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [config setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [config setBorderStyle:UITextBorderStyleRoundedRect];
    [config setTextAlignment:UITextAlignmentCenter];
    [config setClearButtonMode:UITextFieldViewModeAlways];
    [config setPlaceholder:nil];
    [config setFont:nil];
    return config;
}
@end
