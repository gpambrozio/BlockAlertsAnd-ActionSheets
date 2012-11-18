//
//  BlockAlertsDemoViewController.m
//  BlockAlertsDemo
//
//  Created by Gustavo Ambrozio on 9/1/12.
//  Copyright (c) 2012 CodeCrop Software. All rights reserved.
//

#import "BlockAlertsDemoViewController.h"
#import "BlockAlertView.h"
#import "BlockActionSheet.h"
#import "BlockTextPromptAlertView.h"

@implementation BlockAlertsDemoViewController
@synthesize testKeyboard;

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)showAlert:(id)sender
{
  
    BlockAlertView* alert = [BlockAlertView alertWithTitle:@"Alert Title" message:@"This is a very long message, designed just to show you how smart this class is"];
    __block BlockAlertsDemoViewController* currentViewController = self;
    [alert setCancelButtonWithTitle:@"Cancel" block:nil];
    [alert setDestructiveButtonWithTitle:@"Kill!" block:nil];
    [alert addButtonWithTitle:@"Show Action Sheet on top" block:^{
        [currentViewController showActionSheet:nil];
    }];
    [alert addButtonWithTitle:@"Show another alert" block:^{
        [currentViewController showAlert:nil];
    }];
    [alert show];
}

- (IBAction)showActionSheet:(id)sender
{
    BlockActionSheet *sheet = [BlockActionSheet sheetWithTitle:@"This is a sheet title that will span more than one line"];
    __block BlockAlertsDemoViewController* currentViewController = self;
    [sheet setCancelButtonWithTitle:@"Cancel Button" block:nil];
    [sheet setDestructiveButtonWithTitle:@"Destructive Button" block:nil];
    [sheet addButtonWithTitle:@"Show Action Sheet on top" block:^{
        [currentViewController showActionSheet:nil];
    }];
    [sheet addButtonWithTitle:@"Show another alert" block:^{
        [currentViewController showAlert:nil];
    }];
    [sheet showInView:self.view];
}

- (IBAction)showAlertPlusActionSheet:(id)sender
{
    [self showAlert:nil];
    __block BlockAlertsDemoViewController* currentViewController = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [currentViewController showActionSheet:nil];
    });
}

- (IBAction)showActionSheetPlusAlert:(id)sender
{
    [self showActionSheet:nil];
    __block BlockAlertsDemoViewController* currentViewController = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [currentViewController showAlert:nil];
    });
}

- (IBAction)goNuts:(id)sender
{
    __block BlockAlertsDemoViewController* currentViewController = self;
    for (int i=0; i<6; i++)
    {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * i * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if (arc4random() % 2 == 0)
                [currentViewController showAlert:nil];
            else
                [currentViewController showActionSheet:nil];
        });
    }
}

- (IBAction)showTextPrompt:(id)sender
{
    UITextField *textField;
    BlockTextPromptAlertView* alert = [BlockTextPromptAlertView promptWithTitle:@"Prompt Title" message:@"With prompts you do have to keep in mind limited screen space due to the keyboard" textField:&textField];
    
    
    [alert setCancelButtonWithTitle:@"Cancel" block:nil];
    [alert addButtonWithTitle:@"Okay" block:^{
        NSLog(@"Text: %@", textField.text);
    }];
    [alert show];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self showAlert:nil];
    return YES;
}

- (IBAction)whatsArrived:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.getarrived.com"]];
}

- (IBAction)arrivedBlog:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.getarrived.com/blog/"]];
}

- (IBAction)dismissKeyboard:(id)sender
{
    [self.testKeyboard resignFirstResponder];
}


- (void)viewDidUnload
{
    [self setTestKeyboard:nil];
    [super viewDidUnload];
}
@end
