//
//  BlockTableAlertView.h
//  BlockAlertsDemo
//
//  Created by Barrett Jacobsen on 2/14/12.
//  Copyright (c) 2012 CodeCrop Software. All rights reserved.
//

#import "BlockAlertView.h"

@class BlockTableAlertView;

typedef void (^TableAlertIndexBlock)(BlockTableAlertView*,NSInteger);
typedef void (^TableAlertGeneralBlock)(BlockTableAlertView*);
typedef NSUInteger (^TableAlertNumberOfRowsBlock)(BlockTableAlertView*);
typedef UITableViewCell* (^TableAlertCellSourceBlock)(BlockTableAlertView*,NSInteger);

#define kDefaultRowHeight 40.0
#define kTableCornerRadius 5

typedef enum {
	BlockTableAlertTypeSingleSelect, // dismiss alert with button index -1 and animated (default)
	BlockTableAlertTypeMultipleSelct, // dismiss handled by user eg. [alert.view dismiss...];
} BlockTableAlertType;


@interface BlockTableAlertView : BlockAlertView <UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
	BlockTableAlertType _type;
    
    NSMutableArray *selectedItems;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic) BlockTableAlertType type;

@property (readwrite,copy)	TableAlertIndexBlock didSelectRow;
@property (readwrite,copy)	TableAlertIndexBlock willDismissWithButtonIndex;
@property (readwrite,copy)	TableAlertGeneralBlock willPresent;
@property (readwrite,copy)	TableAlertCellSourceBlock cellForRow;
@property (readwrite,copy)	TableAlertNumberOfRowsBlock numberOfRowsInTableAlert;

@property (nonatomic, assign) NSInteger maxSelection;

@property (nonatomic, readonly) NSArray* indexPathsForSelectedRows;

- (void)selectRowAtIndexPath:(NSIndexPath*)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scroll;

- (id)initWithTitle:(NSString *)title message:(NSString *)message;

- (void)reloadData;

- (void)insertRowsAtIndexPaths:(NSArray*)rows;
- (void)deleteRowsAtIndexPaths:(NSArray*)rows;

+ (BlockTableAlertView *)tableAlertWithTitle:(NSString *)title message:(NSString *)message;

@end
