//
//  BlockTextPromptAlertView.h
//  BlockAlertsDemo
//
//  Created by Barrett Jacobsen on 2/13/12.
//  Copyright (c) 2012 Barrett Jacobsen. All rights reserved.
//

#import "BlockAlertView.h"

@interface BlockTextPromptAlertView : BlockAlertView <UITextFieldDelegate> {
    
    NSCharacterSet *unacceptedInput;
    NSInteger maxLength;
}

@property (nonatomic, retain) UITextField *textField;

+ (BlockTextPromptAlertView *)promptWithTitle:(NSString *)title message:(NSString *)message defaultText:(NSString*)defaultText;

+ (BlockTextPromptAlertView *)promptWithTitle:(NSString *)title message:(NSString *)message textField:(out UITextField**)textField;


- (id)initWithTitle:(NSString *)title message:(NSString *)message defaultText:(NSString*)defaultText;


- (void)setAllowableCharacters:(NSString*)accepted;
- (void)setMaxLength:(NSInteger)max;

@end
