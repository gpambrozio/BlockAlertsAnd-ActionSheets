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
typedef BOOL(^TextFieldReturnCallBack)(BlockTextPromptAlertView *);

@interface BlockTextPromptAlertView : BlockAlertView <UITextFieldDelegate> {
    
    NSCharacterSet *unacceptedInput;
    NSInteger maxLength;
    NSInteger buttonIndexForReturn;
    NSString* defaultText;
    NSArray* placeholders;
    int numberOfPlaceholders;
}

@property (nonatomic, retain) UITextField *textField;

@property (nonatomic, assign) BOOL disableAutoBecomeFirstResponder;
@property (nonatomic, assign) BOOL selectAllOnBeginEdit;

+ (BlockTextPromptAlertView *)promptWithTitle:(NSString *)title message:(NSString *)message withPlaceholdersForTextFields:(NSArray*)placeHolderArray block:(TextFieldReturnCallBack) block;


- (id)initWithTitle:(NSString *)title message:(NSString *)message defaultText:(NSString*)defaultText;

- (id)initWithTitle:(NSString *)title message:(NSString *)message defaultText:(NSString*)defaultText textPlaceholders:(NSArray*)placeholderArray block: (TextFieldReturnCallBack) block;
- (NSMutableArray*)getArrayOfTextInAlertViewTextFields;

@property (readwrite, copy) BlockTextPromptAlertShouldDismiss shouldDismiss;

- (void)setAllowableCharacters:(NSString*)accepted;
- (void)setUnacceptedInput:(NSCharacterSet*)charSet;
- (void)setMaxLength:(NSInteger)max;

- (void)setButtonIndexForReturn:(NSInteger)index;


@end
