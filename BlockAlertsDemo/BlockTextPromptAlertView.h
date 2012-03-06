//
//  BlockTextPromptAlertView.h
//  BlockAlertsDemo
//
//  Created by Barrett Jacobsen on 2/13/12.
//  Copyright (c) 2012 Barrett Jacobsen. All rights reserved.
//

#import "BlockAlertView.h"

@class BlockTextPromptAlertView;

typedef BOOL (^BlockTextPromptAlertShouldDismiss)(NSInteger buttonIndex, BlockTextPromptAlertView* theAlert);

@interface BlockTextPromptAlertView : BlockAlertView <UITextFieldDelegate> {
    
    NSCharacterSet *unacceptedInput;
    NSInteger maxLength;
    NSInteger buttonIndexForReturn;
}

@property (nonatomic, retain) UITextField *textField;

+ (BlockTextPromptAlertView *)promptWithTitle:(NSString *)title message:(NSString *)message textField:(out UITextField**)textField;


- (id)initWithTitle:(NSString *)title message:(NSString *)message defaultText:(NSString*)defaultText;

@property (readwrite, copy) BlockTextPromptAlertShouldDismiss shouldDismiss;

- (void)setAllowableCharacters:(NSString*)accepted;
- (void)setMaxLength:(NSInteger)max;

- (void)setButtonIndexForReturn:(NSInteger)index;


@end
