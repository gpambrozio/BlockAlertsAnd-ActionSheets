//
//  BlockTextPromptAlertView.h
//  BlockAlertsDemo
//
//  Created by Barrett Jacobsen on 2/13/12.
//  Copyright (c) 2012 Barrett Jacobsen. All rights reserved.
//

#import "BlockAlertView.h"

@class BlockTextPromptAlertView, BlockTextAlertViewConfig;

typedef BOOL(^TextFieldReturnCallBack)(BlockTextPromptAlertView *);

@interface BlockTextPromptAlertView : BlockAlertView <UITextFieldDelegate> {
    
    NSCharacterSet *unacceptedInput;
    NSInteger maxLength;
}

@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, readonly) BlockTextAlertViewConfig *config;

+ (BlockTextPromptAlertView *)promptWithTitle:(NSString *)title message:(NSString *)message defaultText:(NSString*)defaultText;

+ (BlockTextPromptAlertView *)promptWithTitle:(NSString *)title message:(NSString *)message defaultText:(NSString*)defaultText block:(TextFieldReturnCallBack) block;

+ (BlockTextPromptAlertView *)promptWithTitle:(NSString *)title message:(NSString *)message textField:(out UITextField**)textField;

+ (BlockTextPromptAlertView *)promptWithTitle:(NSString *)title message:(NSString *)message textField:(out UITextField**)textField block:(TextFieldReturnCallBack) block forConfig: (BlockTextAlertViewConfig *) config;


- (id)initWithTitle:(NSString *)title message:(NSString *)message defaultText:(NSString*)defaultText block: (TextFieldReturnCallBack) block forConfig: (BlockTextAlertViewConfig *) config;


- (void)setAllowableCharacters:(NSString*)accepted;
- (void)setMaxLength:(NSInteger)max;

@end
