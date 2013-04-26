//
//  BlockTextPromptAlertView.m
//  BlockAlertsDemo
//
//  Created by Barrett Jacobsen on 2/13/12.
//  Copyright (c) 2012 Barrett Jacobsen. All rights reserved.
//

#import "BlockTextPromptAlertView.h"

#define kTextBoxHeight      31
#define kTextBoxSpacing     5
#define kTextBoxHorizontalMargin 12

#define kKeyboardResizeBounce         20

@interface BlockTextPromptAlertView()
@property(nonatomic, copy) TextFieldReturnCallBack callBack;
@end

@implementation BlockTextPromptAlertView
@synthesize textField, callBack;



+ (BlockTextPromptAlertView *)promptWithTitle:(NSString *)title message:(NSString *)message defaultText:(NSString*)defaultText {
    return [self promptWithTitle:title message:message defaultText:defaultText block:nil];
}

+ (BlockTextPromptAlertView *)promptWithTitle:(NSString *)title message:(NSString *)message defaultText:(NSString*)defaultText block:(TextFieldReturnCallBack)block {
    return [[[BlockTextPromptAlertView alloc] initWithTitle:title message:message defaultText:defaultText block:block] autorelease];
}

+ (BlockTextPromptAlertView *)promptWithTitle:(NSString *)title message:(NSString *)message textField:(out UITextField**)textField {
    return [self promptWithTitle:title message:message textField:textField block:nil];
}


+ (BlockTextPromptAlertView *)promptWithTitle:(NSString *)title message:(NSString *)message textField:(out UITextField**)textField block:(TextFieldReturnCallBack) block{
    BlockTextPromptAlertView *prompt = [[[BlockTextPromptAlertView alloc] initWithTitle:title message:message defaultText:nil block:block] autorelease];
    
    *textField = prompt.textField;
    
    return prompt;
}

- (void)addComponents:(CGRect)frame {
    [super addComponents:frame];
    
    if (!self.textField) {
        UITextField *theTextField = [[UITextField alloc] initWithFrame:CGRectMake(kTextBoxHorizontalMargin, _height, frame.size.width - kTextBoxHorizontalMargin * 2, kTextBoxHeight)];
        
        [theTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [theTextField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
        [theTextField setBorderStyle:UITextBorderStyleRoundedRect];
        [theTextField setTextAlignment:NSTextAlignmentCenter];
        [theTextField setClearButtonMode:UITextFieldViewModeAlways];
        
        theTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        theTextField.delegate = self;
        
        self.textField = theTextField;
    }
    else {
        self.textField.frame = CGRectMake(kTextBoxHorizontalMargin, _height, frame.size.width - kTextBoxHorizontalMargin * 2, kTextBoxHeight);
    }
    
    [_view addSubview:self.textField];
    _height += kTextBoxHeight + kTextBoxSpacing;
    
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message defaultText:(NSString*)defaultText {
    
    self = [super initWithTitle:title message:message];
    
    if (self) {
        maxLength = 0;
        buttonIndexForReturn = 1;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        if ([self class] == [BlockTextPromptAlertView class])
            [self setupDisplay];
    }
    
    return self;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message defaultText:(NSString*)defaultText block: (TextFieldReturnCallBack) block {
    
    self = [self initWithTitle:title message:message defaultText:defaultText];
    
    if (self) {
        self.callBack = block;
    }
    
    return self;
}

- (void)show {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [super show];
    
    [[NSNotificationCenter defaultCenter] addObserver:textField selector:@selector(becomeFirstResponder) name:@"AlertViewFinishedAnimations" object:self];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    if (self.shouldDismiss) {
        if (!self.shouldDismiss(buttonIndex, self))
            return;
    }
    
    [super dismissWithClickedButtonIndex:buttonIndex animated:animated];
    
    [self.textField resignFirstResponder];
    
    [[NSNotificationCenter defaultCenter] removeObserver:textField];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGFloat keyboardHeight = 0;
    CGFloat animationDuration = 0.3;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if(notification) {
        NSDictionary* keyboardInfo = [notification userInfo];
        CGRect keyboardFrame = [[keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        animationDuration = [[keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        if(UIInterfaceOrientationIsPortrait(orientation))
            keyboardHeight = keyboardFrame.size.height;
        else
            keyboardHeight = keyboardFrame.size.width;
    }
    
    CGFloat screenHeight = 0;
    
    if(UIInterfaceOrientationIsPortrait(orientation))
        screenHeight = [UIScreen mainScreen].bounds.size.height;
    else
        screenHeight = [UIScreen mainScreen].bounds.size.width;
    
    
    __block CGRect frame = _view.frame;
    
    if (frame.origin.y + frame.size.height > screenHeight - keyboardHeight) {
        
        frame.origin.y = screenHeight - keyboardHeight - frame.size.height - 10;
        
        if (frame.origin.y < 0)
            frame.origin.y = 0;
        
        _cancelBounce = YES;
        
        [UIView animateWithDuration:animationDuration
                              delay:0.0
                            options:UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             _view.frame = frame;
                         }
                         completion:nil];
    }

}


- (void)setAllowableCharacters:(NSString*)accepted {
    unacceptedInput = [[[NSCharacterSet characterSetWithCharactersInString:accepted] invertedSet] retain];
    self.textField.delegate = self;
}

- (void)setUnacceptedInput:(NSCharacterSet*)charSet {
    unacceptedInput = [charSet copy];
}


- (void)setMaxLength:(NSInteger)max {
    maxLength = max;
    self.textField.delegate = self;
}

- (void)setButtonIndexForReturn:(NSInteger)index {
    buttonIndexForReturn = index;
}

-(BOOL)textFieldShouldReturn:(UITextField *)_textField{
    if(callBack){
        return callBack(self);
    }
    else {
        [self dismissWithClickedButtonIndex:buttonIndexForReturn animated:YES];
    }
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)aTextField {
    if (self.selectAllOnBeginEdit) {
        [aTextField selectAll:self];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger newLength = [self.textField.text length] + [string length] - range.length;
    
    if (maxLength > 0 && newLength > maxLength)
        return NO;
    
    if (!unacceptedInput)
        return YES;
    
    if ([[string componentsSeparatedByCharactersInSet:unacceptedInput] count] > 1)
        return NO;
    else 
        return YES;
}

- (void)dealloc {
    if (unacceptedInput)
        [unacceptedInput release];
    self.callBack = nil;
    [super dealloc];
}

@end
