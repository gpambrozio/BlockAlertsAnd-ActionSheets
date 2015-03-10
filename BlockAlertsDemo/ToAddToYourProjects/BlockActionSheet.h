//
//  BlockActionSheet.h
//
//

#import <UIKit/UIKit.h>

/**
 * A simple block-enabled API wrapper on top of UIActionSheet.
 */
@interface BlockActionSheet : NSObject {
@private
    UIView *_view;
    NSMutableArray *_blocks;
    NSMutableArray *_completionBlocks;
    CGFloat _height;
}

@property (nonatomic, readonly) UIView *view;
@property (nonatomic, readwrite) BOOL vignetteBackground;

+ (id)sheetWithTitle:(NSString *)title;

- (id)initWithTitle:(NSString *)title;

// Add buttons with block
- (void)setCancelButtonWithTitle:(NSString *) title block:(void (^)()) block;
- (void)setDestructiveButtonWithTitle:(NSString *) title block:(void (^)()) block;
- (void)addButtonWithTitle:(NSString *) title block:(void (^)()) block;

// Add buttons at index with block
- (void)setCancelButtonWithTitle:(NSString *) title atIndex:(NSInteger)index block:(void (^)()) block;
- (void)setDestructiveButtonWithTitle:(NSString *) title atIndex:(NSInteger)index block:(void (^)()) block;
- (void)addButtonWithTitle:(NSString *) title atIndex:(NSInteger)index block:(void (^)()) block;

// Add button with block and animation completion block
- (void)setCancelButtonWithTitle:(NSString *)title block:(void (^)())block completion:(void (^)())completionBlock;
- (void)setDestructiveButtonWithTitle:(NSString *)title block:(void (^)())block completion:(void (^)())completionBlock;
- (void)addButtonWithTitle:(NSString *)title block:(void (^)())block completion:(void (^)())completionBlock;

// Add button at index with block and animation completion block
- (void)setCancelButtonWithTitle:(NSString *)title atIndex:(NSInteger)index block:(void (^)())block completion:(void (^)())completionBlock;
- (void)setDestructiveButtonWithTitle:(NSString *)title atIndex:(NSInteger)index block:(void (^)())block completion:(void (^)())completionBlock;
- (void)addButtonWithTitle:(NSString *)title atIndex:(NSInteger)index block:(void (^)())block completion:(void (^)())completionBlock;

- (void)showInView:(UIView *)view;

- (NSUInteger)buttonCount;

@end
