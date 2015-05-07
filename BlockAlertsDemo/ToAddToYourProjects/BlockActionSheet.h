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

- (void)setCancelButtonWithTitle:(NSString *)title atIndex:(NSInteger)index block:(void (^)())block;
- (void)setDestructiveButtonWithTitle:(NSString *)title atIndex:(NSInteger)index block:(void (^)())block;
- (void)addButtonWithTitle:(NSString *)title atIndex:(NSInteger)index block:(void (^)())block;

- (void)showInView:(UIView *)view;

- (NSUInteger)buttonCount;

@end
