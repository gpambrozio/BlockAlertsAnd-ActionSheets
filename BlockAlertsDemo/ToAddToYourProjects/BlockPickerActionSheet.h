//
//  BlockPickerActionSheet.h
//  MyiScan
//
//  Created by Andre on 21-01-13.
//  Copyright (c) 2013 MDC International. All rights reserved.
//

#import "BlockActionSheet.h"

@interface BlockPickerActionSheet : BlockActionSheet<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *rows;


+ (BlockPickerActionSheet *)sheetWithTitle:(NSString *)title rows:(NSArray *)rows pickerView:(out UIPickerView **)pickerView;

@end
