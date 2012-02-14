//
//  BlockTableAlertView.m
//  BlockAlertsDemo
//
//  Created by Barrett Jacobsen on 2/14/12.
//  Copyright (c) 2012 CodeCrop Software. All rights reserved.
//

#import "BlockTableAlertView.h"

@implementation BlockTableAlertView

- (void)addComponents:(CGRect)frame {
    [super addComponents:frame];
    
//    if (!self.textField) {
//        UITextField *theTextField = [[UITextField alloc] initWithFrame:CGRectMake(kTextBoxHorizontalMargin, _height, frame.size.width - kTextBoxHorizontalMargin * 2, kTextBoxHeight)]; 
//        
//        [theTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
//        [theTextField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
//        [theTextField setBorderStyle:UITextBorderStyleRoundedRect];
//        [theTextField setTextAlignment:UITextAlignmentCenter];
//        [theTextField setClearButtonMode:UITextFieldViewModeAlways];
//        
//        theTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//        
//        theTextField.delegate = self;
//        
//        self.textField = theTextField;
//    }
//    else {
//        self.textField.frame = CGRectMake(kTextBoxHorizontalMargin, _height, frame.size.width - kTextBoxHorizontalMargin * 2, kTextBoxHeight);
//    }
//    
//    [_view addSubview:self.textField];
//    _height += kTextBoxHeight + kTextBoxSpacing;
    
}


- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    [super dismissWithClickedButtonIndex:buttonIndex animated:animated];
    
    //[self.textField resignFirstResponder];
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}



@end
