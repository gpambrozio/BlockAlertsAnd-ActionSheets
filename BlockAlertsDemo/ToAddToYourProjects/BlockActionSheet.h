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
	UIColor *_tintColor;
}

@property(nonatomic, readonly) UIView *view;
@property(nonatomic, readwrite) BOOL vignetteBackground;

+ (id)sheetWithTitle:(NSString *)title;
+ (id)sheetWithTitle:(NSString *)title tintColor:(UIColor *)tintColor textColor:(UIColor *)textColor;
- (id)initWithTitle:(NSString *)title tintColor:(UIColor *)tintColor textColor:(UIColor *)textColor;

- (void)setCancelButtonWithTitle:(NSString *)title block:(void (^)())block;
- (void)setDestructiveButtonWithTitle:(NSString *)title block:(void (^)())block;
- (void)addButtonWithTitle:(NSString *)title block:(void (^)())block;
- (void)addButtonWithTitle:(NSString *)title color:(NSString *)color block:(void (^)())block atIndex:(NSInteger)index;

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
