//
//  BlockTextAlertViewConfig.h
//  BlockAlertsDemo
//
//  Created by Diego Chohfi on 8/22/12.
//  Copyright (c) 2012 CodeCrop Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlockTextAlertViewConfig : NSObject

@property(nonatomic) UIControlContentVerticalAlignment contentVerticalAlignment;
@property(nonatomic) UITextAutocapitalizationType autocapitalizationType;
@property(nonatomic) UITextBorderStyle borderStyle;
@property(nonatomic) UITextAlignment textAlignment;
@property(nonatomic) UITextFieldViewMode clearButtonMode;
@property(nonatomic,copy) NSString *placeholder;
@property(nonatomic,retain) UIFont *font;

+ (BlockTextAlertViewConfig *) defaultConfig;

@end
