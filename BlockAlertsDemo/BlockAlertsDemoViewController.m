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
#import "BlockTableAlertView.h"

@implementation BlockAlertsDemoViewController
@synthesize testKeyboard;

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)showAlert:(id)sender
{
    BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Alert Title" message:@"This is a very long message, designed just to show you how smart this class is"];
    
    [alert setCancelButtonWithTitle:@"Cancel" block:nil];
    [alert setDestructiveButtonWithTitle:@"Kill!" block:nil];
    [alert addButtonWithTitle:@"Show Action Sheet on top" imageIdentifier:@"yellow" block:^{
        [self showActionSheet:nil];
    }];
    [alert addButtonWithTitle:@"Show another alert" imageIdentifier:@"green" block:^{
        [self showAlert:nil];
    }];
    alert.direction = BlockAnimateFromTop;
    [alert show];
}

- (IBAction)showActionSheet:(id)sender
{
    BlockActionSheet *sheet = [BlockActionSheet sheetWithTitle:@"This is a sheet title that will span more than one line"];
    [sheet setCancelButtonWithTitle:@"Cancel Button" block:nil];
    [sheet setDestructiveButtonWithTitle:@"Destructive Button" block:nil];
    [sheet addButtonWithTitle:@"Show Action Sheet on top" block:^{
        [self showActionSheet:nil];
    }];
    [sheet addButtonWithTitle:@"Show another alert" block:^{
        [self showAlert:nil];
    }];
    [sheet showInView:self.view];
}

- (IBAction)showAlertPlusActionSheet:(id)sender
{
    [self showAlert:nil];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self showActionSheet:nil];
    });
}

- (IBAction)showActionSheetPlusAlert:(id)sender
{
    [self showActionSheet:nil];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self showAlert:nil];
    });
}

- (IBAction)goNuts:(id)sender
{
    for (int i=0; i<6; i++)
     {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * i * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if (arc4random() % 2 == 0)
                [self showAlert:nil];
            else
                [self showActionSheet:nil];
        });
     }
}

- (IBAction)showTextPrompt:(id)sender
{
    UITextField *textField;
    BlockTextPromptAlertView *alert = [BlockTextPromptAlertView promptWithTitle:@"Prompt Title" message:@"With prompts you do have to keep in mind limited screen space due to the keyboard" textField:&textField block:^(BlockTextPromptAlertView *alert){
        [alert.textField resignFirstResponder];
        return YES;
    }];
    
    
    [alert setCancelButtonWithTitle:@"Cancel" block:nil];
    [alert addButtonWithTitle:@"Okay" block:^{
        NSLog(@"Text: %@", textField.text);
    }];
    [alert show];
}

- (IBAction)showTableAlert:(id)sender
{
    BlockTableAlertView *alert = [[BlockTableAlertView alloc] initWithTitle:@"Prompt Title" message:@"This is a simple table view"];
    
    NSArray *sampleArray = [NSArray arrayWithObjects:@"Row 1", @"Row 2", @"Row 3", @"Row 4", @"Row 5", nil];
    alert.numberOfRowsInTableAlert = ^(BlockTableAlertView *alertView){
        return [sampleArray count];
    };
    alert.cellForRow = ^(BlockTableAlertView *alertView, NSInteger row){
        static NSString *CellIdentifier = @"CellIdentifier";
        
        UITableViewCell *cell = [alertView.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.text = [sampleArray objectAtIndex:row];
        
        return cell;
    };
    alert.didSelectRow = ^(BlockTableAlertView *alertView, NSInteger row){
        NSLog(@"Selected row: %d", row);
    };
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

- (void)dealloc
{
    [testKeyboard release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setTestKeyboard:nil];
    [super viewDidUnload];
}
@end
