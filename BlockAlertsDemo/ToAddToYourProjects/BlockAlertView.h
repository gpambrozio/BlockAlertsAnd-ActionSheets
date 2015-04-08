//
//  BlockAlertView.h
//
//

#import <UIKit/UIKit.h>

@interface BlockAlertView : NSObject {
 @protected
  UIScrollView *_view;
  NSMutableArray *_blocks;
  CGFloat _height;
  NSString *_title;
  NSString *_message;
  BOOL _shown;
  BOOL _cancelBounce;
}

+ (BlockAlertView *)alertWithTitle:(NSString *)title message:(NSString *)message;
+ (void)showInfoAlertWithTitle:(NSString *)title message:(NSString *)message;
+ (void)showErrorAlert:(NSError *)error;

- (id)initWithTitle:(NSString *)title message:(NSString *)message;

- (void)setDestructiveButtonWithTitle:(NSString *)title block:(void (^)())block;
- (void)setCancelButtonWithTitle:(NSString *)title block:(void (^)())block;
- (void)addButtonWithTitle:(NSString *)title block:(void (^)())block;

// Images should be named in the form "alert-IDENTIFIER-button.png"
- (void)addButtonWithTitle:(NSString *)title imageIdentifier:(NSString *)identifier block:(void (^)())block;

- (void)addComponents:(CGRect)frame;

- (void)show;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

- (void)setupDisplay;

@property(nonatomic, retain) UIImage *backgroundImage;
@property(nonatomic, readonly) UIScrollView *view;
@property(nonatomic, readwrite) BOOL vignetteBackground;

@end
