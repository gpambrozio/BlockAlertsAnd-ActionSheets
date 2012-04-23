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

- (id)initWithTitle:(NSString *)title message:(NSString *)message defaultText:(NSString*)defaultText block: (TextFieldReturnCallBack) block {
    
    self = [super initWithTitle:title message:message];
    
    if (self) {
        UITextField *theTextField = [[[UITextField alloc] initWithFrame:CGRectMake(kTextBoxHorizontalMargin, _height, _view.bounds.size.width - kTextBoxHorizontalMargin * 2, kTextBoxHeight)] autorelease]; 
        
        [theTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [theTextField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
        [theTextField setBorderStyle:UITextBorderStyleRoundedRect];
        [theTextField setTextAlignment:UITextAlignmentCenter];
        [theTextField setClearButtonMode:UITextFieldViewModeAlways];
        
        if (defaultText)
            theTextField.text = defaultText;
        
        if(block){
            theTextField.delegate = self;
        }
        
        [_view addSubview:theTextField];
        
        self.textField = theTextField;
        
        _height += kTextBoxHeight + kTextBoxSpacing;
        
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
    
    [self.textField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.5];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    [super dismissWithClickedButtonIndex:buttonIndex animated:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    __block CGRect frame = _view.frame;
    
    if (frame.origin.y + frame.size.height > screenHeight - keyboardSize.height) {
        
        frame.origin.y = screenHeight - keyboardSize.height - frame.size.height;
        
        if (frame.origin.y < 0)
            frame.origin.y = 0;
        
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationCurveEaseOut
                         animations:^{
                             _view.frame = frame;
                         } 
                         completion:nil];
    }
}


- (void)setAllowableCharacters:(NSString*)accepted {
    unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:accepted] invertedSet];
    self.textField.delegate = self;
}

- (void)setMaxLength:(NSInteger)max {
    maxLength = max;
    self.textField.delegate = self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)_textField{
    if(callBack){
        return callBack(self);
    }
    return NO;
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

- (void)dealloc
{
    self.callBack = nil;
    [super dealloc];
}

@end
