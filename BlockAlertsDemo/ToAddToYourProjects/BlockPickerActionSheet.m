//
//  BlockPickerActionSheet.m
//  MyiScan
//
//  Created by Andre on 21-01-13.
//  Copyright (c) 2013 MDC International. All rights reserved.
//

#import "BlockPickerActionSheet.h"

#define kPickerViewHeight      180
#define kPickerViewSpacing     5
#define kPickerViewHorizontalMargin 0

@implementation BlockPickerActionSheet

- (id)initWithTitle:(NSString *)title rows:(NSArray *)rows
{
    if ((self = [super initWithTitle:title]))
    {
        [self setRows:rows];
        
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(kPickerViewHorizontalMargin, _height, self.view.bounds.size.width - kPickerViewHorizontalMargin * 2, kPickerViewHeight)];
        [pickerView setDataSource:self];
        [pickerView setDelegate:self];
        [pickerView setShowsSelectionIndicator:YES];
        [self setPickerView:pickerView];
        
        [self.view addSubview:pickerView];
        
        _height += kPickerViewHeight + (kPickerViewSpacing * 2);
    }
    
    return self;
}

+ (BlockPickerActionSheet *)sheetWithTitle:(NSString *)title rows:(NSArray *)rows pickerView:(out UIPickerView **)pickerView
{
    BlockPickerActionSheet *sheet = [[BlockPickerActionSheet alloc] initWithTitle:title rows:rows];
    
    *pickerView = sheet.pickerView;
    
    return sheet;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.rows count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.rows objectAtIndex:row];
}

@end
