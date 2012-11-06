//
//  BlockTableAlertView.m
//  BlockAlertsDemo
//
//  Created by Barrett Jacobsen on 2/14/12.
//  Copyright (c) 2012 CodeCrop Software. All rights reserved.
//

#define SUPPORTS_MULTIPLE_SELECTION [self.tableView respondsToSelector:@selector(setAllowsMultipleSelectionDuringEditing:)]

#define kVerticalSpacing     5
#define kHorizontalMargin   12

#define IS_IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

#define IS_LANDSCAPE UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define kNumMaximumVisibleRowsInTableView (IS_IPAD ? 15 : (IS_LANDSCAPE ? 4 : (IS_IPHONE_5 ? 6 : 5)))

#import "BlockTableAlertView.h"
#import <QuartzCore/QuartzCore.h>
#import <dispatch/dispatch.h>

@implementation BlockTableAlertView
@synthesize tableView=_tableView;
@synthesize type=_type;
@synthesize	didSelectRow;
@synthesize willDismissWithButtonIndex;
@synthesize maxSelection;
@synthesize cellForRow;
@synthesize willPresent;
@synthesize numberOfRowsInTableAlert;

@dynamic indexPathsForSelectedRows;

+ (BlockTableAlertView *)tableAlertWithTitle:(NSString *)title message:(NSString *)message
{
    return [[[BlockTableAlertView alloc] initWithTitle:title message:message] autorelease];
}


- (id)initWithTitle:(NSString *)title message:(NSString *)message {
    self = [super initWithTitle:title message:message];
    
    if (self) {
        if (!SUPPORTS_MULTIPLE_SELECTION)
            selectedItems = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)addComponents:(CGRect)frame {
    [super addComponents:frame];
   
    if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
		[_tableView setDelegate:self];
		[_tableView setDataSource:self];
		[_tableView setBackgroundColor:[UIColor colorWithWhite:0.90 alpha:1.0]];
		[_tableView setRowHeight:kDefaultRowHeight];
		[_tableView setSeparatorColor:[UIColor lightGrayColor]];
		_tableView.layer.cornerRadius = kTableCornerRadius;
    }

    CGFloat tableHeight = kDefaultRowHeight * MIN(self.numberOfRowsInTableAlert(self), kNumMaximumVisibleRowsInTableView);
   
    _tableView.frame = CGRectMake(kHorizontalMargin, _height, frame.size.width - kHorizontalMargin * 2, tableHeight);
  
    [_view addSubview:_tableView];
    _height += tableHeight + kVerticalSpacing;
}


- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    if (self.willDismissWithButtonIndex)
        self.willDismissWithButtonIndex(self, buttonIndex);
    
    [super dismissWithClickedButtonIndex:buttonIndex animated:animated];
}

- (void)updateAlertHeight:(CGFloat)oldTableHeight {
    CGFloat newTableHeight = kDefaultRowHeight * MIN(self.numberOfRowsInTableAlert(self), kNumMaximumVisibleRowsInTableView);
    
    if (newTableHeight != oldTableHeight) {
        CGFloat diff = newTableHeight - oldTableHeight;
        [UIView animateWithDuration:0.3 animations:^{
            [self.view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                UIView *v = obj;
                if (v.frame.origin.y >= _tableView.frame.origin.y + _tableView.frame.size.height)
                    v.frame = CGRectMake(v.frame.origin.x, v.frame.origin.y + diff, v.frame.size.width, v.frame.size.height);
            }];
            
            _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, newTableHeight);
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height + diff);
        }];
    }
}

- (void)reloadData {
    CGFloat oldTableHeight = _tableView.frame.size.height;

    [self.tableView reloadData];
    
    [self updateAlertHeight:oldTableHeight];
}

- (void)insertRowsAtIndexPaths:(NSArray*)rows {
    CGFloat oldTableHeight = _tableView.frame.size.height;
    
    [self.tableView insertRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self updateAlertHeight:oldTableHeight];
}

- (void)deleteRowsAtIndexPaths:(NSArray*)rows {
    CGFloat oldTableHeight = _tableView.frame.size.height;
    
    [self.tableView deleteRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self updateAlertHeight:oldTableHeight];
}


- (void)show {
    if (!_shown)
        [self setupDisplay];
    
    if (self.willPresent)
        self.willPresent(self);
    
    if (self.type == BlockTableAlertTypeMultipleSelct && SUPPORTS_MULTIPLE_SELECTION) {
        self.tableView.allowsMultipleSelectionDuringEditing = YES;
        self.tableView.editing = YES;
    }

    [super show];
}

#pragma mark - iOS 4 Compatibility

- (NSArray*)indexPathsForSelectedRows {
    if (SUPPORTS_MULTIPLE_SELECTION) {
        return self.tableView.indexPathsForSelectedRows;
    }
    else {
        return selectedItems;
    }
}

- (void)selectRowAtIndexPath:(NSIndexPath*)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scroll {
    if (SUPPORTS_MULTIPLE_SELECTION) {
        [self.tableView selectRowAtIndexPath:indexPath animated:animated scrollPosition:scroll];
    }
    else {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        if (cell.accessoryType == UITableViewCellAccessoryNone) {
            [selectedItems addObject:indexPath];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
}


#pragma mark - UITableViewDelegate

- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == BlockTableAlertTypeSingleSelect || self.maxSelection == 0)
        return indexPath;
    
    NSIndexPath *toSelect = indexPath;
    
    if ([self.indexPathsForSelectedRows count] + 1 > self.maxSelection)
        toSelect = nil;
    
    return toSelect;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (_type == BlockTableAlertTypeSingleSelect)
		[self dismissWithClickedButtonIndex:-1 animated:YES];
	
    if (!SUPPORTS_MULTIPLE_SELECTION) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        if (cell.accessoryType == UITableViewCellAccessoryNone) {
            [selectedItems addObject:indexPath];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            if (self.didSelectRow)
                self.didSelectRow(self, [indexPath row]);
        }
        else {
            [selectedItems removeObject:indexPath];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        return;
    }
    
	if (self.didSelectRow)
		self.didSelectRow(self, [indexPath row]);
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
	return self.cellForRow(self,[indexPath row]);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.numberOfRowsInTableAlert(self);
}


@end
